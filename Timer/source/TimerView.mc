//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

//! Show the three timer callback counts
class TimerView extends WatchUi.View {
    private var _timer1 as Timer.Timer?;
    private var _count1 as Number = 0;
    private var _count2 as Number = 0;
    private var _count3 as Number = 0;

    //! Constructor
    public function initialize() {
        WatchUi.View.initialize();
    }

    //! Callback for timer 1
    public function callback1() as Void {
        _count1++;
        WatchUi.requestUpdate();
    }

    //! Callback for timer 2
    public function callback2() as Void {
        _count2++;
        WatchUi.requestUpdate();
    }

    //! Callback for timer 3
    public function callback3() as Void {
        _count3++;
        WatchUi.requestUpdate();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        var timer1 = new Timer.Timer();
        var timer2 = new Timer.Timer();
        var timer3 = new Timer.Timer();

        timer1.start(method(:callback1), 500, true);
        timer2.start(method(:callback2), 1000, true);
        timer3.start(method(:callback3), 2000, true);

        _timer1 = timer1;
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var string = "Count: " + _count1;
        dc.drawText(
            40,
            dc.getHeight() / 2 - 30,
            Graphics.FONT_MEDIUM,
            string,
            Graphics.TEXT_JUSTIFY_LEFT
        );
        string = "Count: " + _count2;
        dc.drawText(
            40,
            dc.getHeight() / 2,
            Graphics.FONT_MEDIUM,
            string,
            Graphics.TEXT_JUSTIFY_LEFT
        );
        string = "Count: " + _count3;
        dc.drawText(
            40,
            dc.getHeight() / 2 + 30,
            Graphics.FONT_MEDIUM,
            string,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }

    //! Stop the first timer
    public function stopTimer() as Void {
        var timer = _timer1;
        if (timer != null) {
            timer.stop();
        }
    }
}
