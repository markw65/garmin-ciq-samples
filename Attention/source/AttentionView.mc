//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Attention;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Shows the options and processes the current action
class AttentionView extends WatchUi.View {
    private var _selectedIndex as Number = 0;
    private var _currentTone as String?;
    private var _currentVibe as String?;

    private var _backlightOn as Boolean = false;
    private var _toneIdx as Number = 0;
    private var _mainText as Array<Drawable>?;
    private
    var _toneNames as Array<String> = [
        "Key",
        "Start",
        "Stop",
        "Message",
        "Alert Hi",
        "Alert Lo",
        "Loud Beep",
        "Interval Alert",
        "Alarm",
        "Reset",
        "Lap",
        "Canary",
        "Time Alert",
        "Distance Alert",
        "Failure",
        "Success",
        "Power",
        "Low Battery",
        "Error",
        "Custom",
    ] as Array<String>;

    private enum Actions {
        ACTION_BACKLIGHT,
        ACTION_TONE,
        ACTION_VIBRATE,
        ACTION_COUNT,
    }

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        _mainText = $.Rez.Layouts.MainText(dc);
        setLayout(_mainText);
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {}

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        var height = dc.getHeight();
        var width = dc.getWidth();

        // Draw selected box
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(
            0,
            (_selectedIndex * height) / ACTION_COUNT,
            width,
            height / ACTION_COUNT
        );
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Draw frames
        dc.drawLine(0, height / ACTION_COUNT, width, height / ACTION_COUNT);
        dc.drawLine(
            0,
            (2 * height) / ACTION_COUNT,
            width,
            (2 * height) / ACTION_COUNT
        );

        var backlightLabel = View.findDrawableById("BacklightLabel") as Text;
        var vibrateLabel = View.findDrawableById("VibeLabel") as Text;
        var toneLabel = View.findDrawableById("ToneLabel") as Text;

        backlightLabel.setText("Toggle Backlight");

        if (_currentVibe != null) {
            vibrateLabel.setText("Vibe: " + _currentVibe);
        } else {
            vibrateLabel.setText("Vibrate");
        }

        if (_currentTone != null) {
            toneLabel.setText("Tone: " + _currentTone);
        } else {
            toneLabel.setText("Play a tone");
        }

        // Draw text fields in layout
        var mainText = _mainText;
        if (mainText != null) {
            for (var i = 0; i < mainText.size(); i++) {
                mainText[i].draw(dc);
            }
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {}

    //! Take a tap coordinate and correspond it to one of three sections
    //! @param yVal Y-coordinate of tap
    public function setIndexFromYVal(yVal as Number) as Void {
        var screenHeight = System.getDeviceSettings().screenHeight;
        _selectedIndex = (yVal / (screenHeight / ACTION_COUNT)).toNumber();
    }

    //! Increment the currently selected option index
    public function incIndex() as Void {
        _selectedIndex = (_selectedIndex + 1) % ACTION_COUNT;
    }

    //! Decrement the currently selected option index
    public function decIndex() as Void {
        _selectedIndex = (_selectedIndex + ACTION_COUNT - 1) % ACTION_COUNT;
    }

    //! Process the current attention action
    public function action() as Void {
        if (ACTION_BACKLIGHT == _selectedIndex) {
            // Toggle backlight
            _currentTone = null;
            _backlightOn = !_backlightOn;
            Attention.backlight(_backlightOn);
            WatchUi.requestUpdate();
        } else if (ACTION_TONE == _selectedIndex) {
            // Play a tone
            if (Attention has :playTone) {
                var currentToneIdx = _toneIdx;
                _currentTone = _toneNames[_toneIdx];

                _toneIdx = (_toneIdx + 1) % _toneNames.size();
                if (_toneIdx == 0) {
                    if (
                        Attention has :ToneProfile &&
                        $.Rez.JsonData has :id_birthday
                    ) {
                        Attention.playTone({
                            :toneProfile
                            =>
                            loadSong($.Rez.JsonData.id_birthday as Symbol),
                        });
                    } else {
                        _currentTone = "Not supported";
                    }
                } else {
                    Attention.playTone(currentToneIdx as Tone);
                }
            } else {
                _currentTone = "Not supported";
            }
            WatchUi.requestUpdate();
        } else if (ACTION_VIBRATE == _selectedIndex) {
            // Vibrate
            _currentTone = null;
            if (Attention has :vibrate) {
                var vibrateData = [
                    new Attention.VibeProfile(25, 100),
                    new Attention.VibeProfile(50, 100),
                    new Attention.VibeProfile(75, 100),
                    new Attention.VibeProfile(100, 100),
                    new Attention.VibeProfile(75, 100),
                    new Attention.VibeProfile(50, 100),
                    new Attention.VibeProfile(25, 100),
                ] as Array<VibeProfile>;

                Attention.vibrate(vibrateData);
            } else {
                _currentVibe = "Not supported";
            }
            WatchUi.requestUpdate();
        }
    }

    //! Load the song from resources into a tone profile
    //! @param rezId Resource id for the song
    //! @return Array of tone profile objects
    private function loadSong(rezId as Symbol) as Array<ToneProfile> {
        var song = WatchUi.loadResource(rezId) as Array<Array<Number> >;
        var songTones = new Array<ToneProfile>[song.size()];

        // convert array of [frequency, duration] into array of ToneProfile
        for (var i = 0; i < song.size(); ++i) {
            songTones[i] = new Attention.ToneProfile(song[i][0], song[i][1]);
        }

        return songTones;
    }
}
