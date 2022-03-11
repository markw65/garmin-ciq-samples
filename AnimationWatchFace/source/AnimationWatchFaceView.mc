//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Responds to animation events
class AnimationDelegate extends WatchUi.AnimationDelegate {
    private var _view as AnimationWatchFaceView;

    //! Constructor
    //! @param view The watch face view
    public function initialize(view as AnimationWatchFaceView) {
        _view = view;
        WatchUi.AnimationDelegate.initialize();
    }

    //! Handle an animation event
    //! @param event The animation event
    //! @param options A dictionary of animation options
    public function onAnimationEvent(
        event as AnimationEvent,
        options as Dictionary
    ) as Void {
        if (event == WatchUi.ANIMATION_EVENT_COMPLETE) {
            var playCount = _view.getPlayCount();
            System.println("onComplete: " + playCount);
            System.println("play: " + playCount);
            _view.play();
        } else if (event == WatchUi.ANIMATION_EVENT_CANCELED) {
            System.println("canceled");
        } else {
            System.println("on unknown event");
        }
    }
}

//! Displays the animated watch face
class AnimationWatchFaceView extends WatchUi.WatchFace {
    private var _playCount as Number = 0;
    private var _backgroundAnimationLayer as AnimationLayer;
    private var _foregroundAnimationLayer as AnimationLayer;
    private var _drawLayer as Layer;

    private var _drawLayerArea as Array<Number>;
    private var _partialUpdateClip as Array<Number>;

    private var _majorTextOffsetX as Number;
    private var _majorTextOffsetY as Number;

    private var _minorTextOffsetX as Number;
    private var _minorTextOffsetY as Number;

    private const MAJOR_FONT = Graphics.FONT_NUMBER_MEDIUM;
    private const MINOR_FONT = Graphics.FONT_NUMBER_MILD;
    private const GAP = 10;

    private const RAND_BASE = 0x7fffffff;

    //! Constructor
    public function initialize() {
        WatchFace.initialize();

        var settings = System.getDeviceSettings();
        var majorFontHeight = Graphics.getFontHeight(MAJOR_FONT);
        var majorFontWidth = (majorFontHeight * 2) / 3;
        var minorFontHeight = Graphics.getFontHeight(MINOR_FONT);
        var minorFontWidth = (minorFontHeight * 2) / 3;

        var drawLayerWidth = majorFontWidth * 5;
        var drawLayerHeight = majorFontHeight + GAP + minorFontHeight;

        var partialUpdateWidth = minorFontWidth * 2;
        var partialUpdateHeight = minorFontHeight;

        _drawLayerArea = [
            (settings.screenWidth - drawLayerWidth) / 2,
            settings.screenHeight / 3,
            drawLayerWidth,
            drawLayerHeight,
        ] as Array<Number>;

        // set the text offsets with in the draw layer
        _majorTextOffsetX = _drawLayerArea[2] / 2;
        _majorTextOffsetY = 0;
        _minorTextOffsetX = _majorTextOffsetX;
        _minorTextOffsetY = _majorTextOffsetY + majorFontHeight + GAP;

        // partial update clip in the draw layer
        _partialUpdateClip = [
            (_drawLayerArea[2] - partialUpdateWidth) / 2,
            _minorTextOffsetY,
            partialUpdateWidth,
            partialUpdateHeight,
        ] as Array<Number>;

        // seed the random number
        Math.srand(0);

        // create animation and draw layers
        _backgroundAnimationLayer = new WatchUi.AnimationLayer(
            $.Rez.Drawables.backgroundmonkey,
            null
        );
        _drawLayer = new WatchUi.Layer({
            :locX => _drawLayerArea[0],
            :locY => _drawLayerArea[1],
            :width => _drawLayerArea[2],
            :height => _drawLayerArea[3],
        });
        _foregroundAnimationLayer = new WatchUi.AnimationLayer(
            $.Rez.Drawables.transparentmonkey,
            null
        );
    }

    //! Set the layout and layers for the view
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.WatchFace(dc));
        // clear the whole screen with solid color
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // add the layers to the view
        addLayer(_backgroundAnimationLayer);
        addLayer(_drawLayer);
        addLayer(_foregroundAnimationLayer);
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {
        _playCount = 0;
        // start the playback
        play();
    }

    //! Play the animation
    public function play() as Void {
        // alternate the playback between foreground and background animations
        if (_playCount % 4 == 0) {
            _backgroundAnimationLayer.setVisible(true);
            _backgroundAnimationLayer.play({
                :delegate => new $.AnimationDelegate(self),
            });
        } else {
            // set the foreground animation to be visible
            _foregroundAnimationLayer.setVisible(true);

            // change foreground layer level to play
            // above or below draw layer (clock)
            removeLayer(_foregroundAnimationLayer);
            insertLayer(_foregroundAnimationLayer, (_playCount % 2) + 1);

            // change the foreground animation playback position,
            // so it can be repositioned across the clock text randomly
            var deltaPercX = Math.rand().toDouble() / RAND_BASE;
            var deltaPercY = Math.rand().toDouble() / RAND_BASE;
            var animationRez = _foregroundAnimationLayer.getResource();
            var x =
                _drawLayerArea[0] +
                (_drawLayerArea[2] * deltaPercX).toNumber() -
                animationRez.getWidth() / 2;
            var y =
                _drawLayerArea[1] +
                (_drawLayerArea[3] * deltaPercY).toNumber() -
                animationRez.getHeight() / 2;
            // reset the x and z (layer) to the new coordinates
            _foregroundAnimationLayer.setLocation(x, y);
            // start the playback
            _foregroundAnimationLayer.play({
                :delegate => new $.AnimationDelegate(self),
            });
        }
        _playCount++;
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        // Update the entire draw layer
        updateWatchOverlay(true);
    }

    //! Handle the partial update event
    //! @param dc Device Context
    public function onPartialUpdate(dc as Dc) as Void {
        // Only update the second digit
        updateWatchOverlay(false);
    }

    //! Update the clock
    //! @param isFullUpdate True if updating everything, false if partial update
    private function updateWatchOverlay(isFullUpdate as Boolean) as Void {
        var drawLayerDc = _drawLayer.getDc();
        if (drawLayerDc != null) {
            // Get and overlay the current time on top of the animation background
            var clockTime = System.getClockTime();
            var hourMinString = Lang.format("$1$:$2$", [
                clockTime.hour,
                clockTime.min.format("%02d"),
            ]);
            var secString = Lang.format("$1$", [clockTime.sec.format("%02d")]);

            if (isFullUpdate) {
                // Full update, clear the layer clip
                drawLayerDc.clearClip();
            } else {
                // partial update, update the second digits only
                drawLayerDc.setClip(
                    _partialUpdateClip[0],
                    _partialUpdateClip[1],
                    _partialUpdateClip[2],
                    _partialUpdateClip[3]
                );
            }

            // clear the clip region with transparent background color, so the animation rendered in the background
            // can be seen through the overlay
            drawLayerDc.setColor(
                Graphics.COLOR_BLACK,
                Graphics.COLOR_TRANSPARENT
            );
            drawLayerDc.clear();

            // draw clock text
            if (isFullUpdate) {
                // only re-draw hour/min during full update
                drawLayerDc.drawText(
                    _majorTextOffsetX,
                    _majorTextOffsetY,
                    MAJOR_FONT,
                    hourMinString,
                    Graphics.TEXT_JUSTIFY_CENTER
                );
            }
            drawLayerDc.drawText(
                _minorTextOffsetX,
                _minorTextOffsetY,
                MINOR_FONT,
                secString,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
        // invoke default View.onHide() which will stop all animations
        View.onHide();
    }

    //! When not in sleep mode, play the animation
    public function onExitSleep() as Void {
        // reset the play count and start playing the animations
        _playCount = 0;
        play();
    }

    //! During sleep mode, stop the animation
    public function onEnterSleep() as Void {
        // animation playback will be stopped by system after entering sleep mode
        // set the foreground animation to be invisible so it won't block the clock text
        _foregroundAnimationLayer.setVisible(false);
    }

    //! Get the play count
    //! @return The play count
    public function getPlayCount() as Number {
        return _playCount;
    }
}
