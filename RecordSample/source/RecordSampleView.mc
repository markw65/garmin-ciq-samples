//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.ActivityRecording;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class BaseInputDelegate extends WatchUi.BehaviorDelegate {
    private var _view as RecordSampleView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as RecordSampleView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    //! On menu event, start/stop recording
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        if (Toybox has :ActivityRecording) {
            if (!_view.isSessionRecording()) {
                _view.startRecording();
            } else {
                _view.stopRecording();
            }
        }
        return true;
    }
}

class RecordSampleView extends WatchUi.View {
    private var _session as Session?;

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Stop the recording if necessary
    public function stopRecording() as Void {
        var session = _session;
        if (
            Toybox has :ActivityRecording &&
            isSessionRecording() &&
            session != null
        ) {
            session.stop();
            session.save();
            _session = null;
            WatchUi.requestUpdate();
        }
    }

    //! Start recording a session
    public function startRecording() as Void {
        var session = ActivityRecording.createSession({
            :name => "Walk",
            :sport => ActivityRecording.SPORT_WALKING,
        });
        _session = session;
        session.start();
        WatchUi.requestUpdate();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {}

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {}

    //! Restore the state of the app and prepare the view to be shown.
    public function onShow() as Void {}

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        // Set background color
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(
            dc.getWidth() / 2,
            0,
            Graphics.FONT_XTINY,
            "M:" + System.getSystemStats().usedMemory,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        if (Toybox has :ActivityRecording) {
            // Draw the instructions
            if (!isSessionRecording()) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
                dc.drawText(
                    dc.getWidth() / 2,
                    dc.getHeight() / 2,
                    Graphics.FONT_MEDIUM,
                    "Press Menu to\nStart Recording",
                    Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
                );
            } else {
                var x = dc.getWidth() / 2;
                var y = dc.getFontHeight(Graphics.FONT_XTINY);
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
                dc.drawText(
                    x,
                    y,
                    Graphics.FONT_MEDIUM,
                    "Recording...",
                    Graphics.TEXT_JUSTIFY_CENTER
                );
                y += dc.getFontHeight(Graphics.FONT_MEDIUM);
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
                dc.drawText(
                    x,
                    y,
                    Graphics.FONT_MEDIUM,
                    "Press Menu again\nto Stop and Save\nthe Recording",
                    Graphics.TEXT_JUSTIFY_CENTER
                );
            }
        } else {
            // tell the user this sample doesn't work
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
            dc.drawText(
                dc.getWidth() / 2,
                dc.getWidth() / 2,
                Graphics.FONT_MEDIUM,
                "This product doesn't\nhave FIT Support",
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
    }

    //! Get whether a session is currently recording
    //! @return true if there is a session currently recording, false otherwise
    public function isSessionRecording() as Boolean {
        var session = _session;
        if (session != null) {
            return session.isRecording();
        }
        return false;
    }
}
