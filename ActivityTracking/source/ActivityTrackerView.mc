//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

//! Main view for the tracker app
class ActivityTrackerView extends WatchUi.View {

    //! Update timer
    private var _timer as Timer.Timer;

    //! Constructor
    public function initialize() {
        View.initialize();

        // Set up a 1Hz update timer because we aren't registering
        // for any data callbacks that can kick our display update.
        _timer = new Timer.Timer();
    }

    //! Starts the timer when the view is visible
    public function onShow() as Void {
        _timer.start(method(:onTimer), 1000, true);
    }

    //! Stops the timer when the view is hidden
    public function onHide() as Void {
        _timer.stop();
    }

    //! Handle the update event
    //! @param dc Draw context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var info = ActivityMonitor.getInfo();

        if ((info has :stepGoal) && (info has :steps)) {
            if (info.stepGoal == 0) {
                info.stepGoal = 5000;
            }

            var steps = info.steps;
            var stepGoal = info.stepGoal;
            if ((steps != null) && (stepGoal != null)) {
                var stepsPercent = steps.toFloat() / stepGoal.toNumber();
                drawBar(dc, "Steps", dc.getHeight() / 4, stepsPercent, Graphics.COLOR_GREEN);
            }
        } else {
            dc.drawText(20, dc.getHeight() / 4, Graphics.FONT_SMALL, "Steps not supported!", Graphics.TEXT_JUSTIFY_LEFT);
        }

        if ((info has :floorsClimbed) && (info has :floorsClimbedGoal)) {
            if (info.floorsClimbedGoal == 0) {
                info.floorsClimbedGoal = 10;
            }

            var floorsClimbed = info.floorsClimbed;
            var floorsClimbedGoal = info.floorsClimbedGoal;
            if ((floorsClimbed != null) && (floorsClimbedGoal != null)) {
                var floorsPercent = floorsClimbed.toFloat() / floorsClimbedGoal.toNumber();
                drawBar(dc, "Floors", dc.getHeight() / 2, floorsPercent, Graphics.COLOR_BLUE);
            }
        } else {
            dc.drawText(20, dc.getHeight() / 2, Graphics.FONT_SMALL, "Floors not supported!", Graphics.TEXT_JUSTIFY_LEFT);
        }

        if ((info has :activeMinutesWeek) && (info has :activeMinutesWeekGoal)) {
            if (info.activeMinutesWeekGoal == 0) {
                info.activeMinutesWeekGoal = 150;
            }

            var activeMinutesWeek = info.activeMinutesWeek;
            var activeMinutesWeekGoal = info.activeMinutesWeekGoal;
            if ((activeMinutesWeek != null) && (activeMinutesWeekGoal != null)) {
                var activePercent = activeMinutesWeek.total.toFloat() / activeMinutesWeekGoal.toNumber();
                drawBar(dc, "Minutes", dc.getHeight() / 4 * 3, activePercent, Graphics.COLOR_ORANGE);
            }
        } else {
            dc.drawText(20, dc.getHeight() / 4 * 3, Graphics.FONT_SMALL, "Minutes not supported!", Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    //! Draw the move bar
    //! @param dc Draw context
    //! @param string Message to draw
    //! @param y y position on string to draw
    //! @param percent Percent of the bar to fill (0 - 1.0)
    //! @param color Color to use
    private function drawBar(dc as Dc, string as String, y as Numeric, percent as Numeric, color as ColorType) as Void {
        var width = dc.getWidth() / 5 * 4;
        var x = dc.getWidth() / 10;

        if (percent > 1) {
            percent = 1.0;
        }

        dc.setColor(color, color);
        dc.fillRectangle(x, y, width * percent, 10);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, width, 10);
        dc.setPenWidth(1);

        var font = Graphics.FONT_SMALL;

        dc.drawText(x, y - Graphics.getFontHeight(font) - 3, font, string, Graphics.TEXT_JUSTIFY_LEFT);
    }

    //! Timer callback
    public function onTimer() as Void {
        //Kick the display update
        WatchUi.requestUpdate();
    }
}
