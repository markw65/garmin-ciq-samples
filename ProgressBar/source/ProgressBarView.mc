//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

//! Initial view
class MyWatchView extends WatchUi.View {
    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var string = "Push 'Select'\n to start the\n progress bar";
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_SMALL,
            string,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}

//! Input handler for the progress bar
class ProgressDelegate extends WatchUi.BehaviorDelegate {
    private var _callback as Method() as Void;

    //! Constructor
    //! @param callback Callback function
    public function initialize(callback as Method() as Void) {
        BehaviorDelegate.initialize();
        _callback = callback;
    }

    //! Handle back behavior
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        _callback.invoke();
        return true;
    }
}

//! Creates and updates the progress bar
class InputDelegate extends WatchUi.BehaviorDelegate {
    private var _progressBar as ProgressBar?;
    private var _timer as Timer.Timer?;
    private var _count as Number = 0;

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! On a select event, create a progress bar
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        if (_timer == null) {
            _timer = new Timer.Timer();
        }
        _count = 0;

        _progressBar = new WatchUi.ProgressBar("Processing", null);
        WatchUi.pushView(
            _progressBar,
            new $.ProgressDelegate(method(:stopTimer)),
            WatchUi.SLIDE_DOWN
        );

        (_timer as Timer.Timer).start(method(:timerCallback), 1000, true);
        return true;
    }

    //! Stop the timer
    public function stopTimer() as Void {
        var timer = _timer;
        if (timer != null) {
            timer.stop();
        }
    }

    //! Update the progress bar every second
    public function timerCallback() as Void {
        _count++;

        var progressBar = _progressBar;
        if (progressBar != null) {
            if (_count > 17) {
                var timer = _timer;
                if (timer != null) {
                    timer.stop();
                }
                WatchUi.popView(WatchUi.SLIDE_UP);
            } else if (_count > 15) {
                progressBar.setDisplayString("Complete");
            } else if (_count > 5) {
                progressBar.setProgress(((_count - 5) * 10).toFloat());
            }
        }
    }
}
