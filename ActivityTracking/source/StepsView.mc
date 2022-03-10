//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Timer;
import Toybox.WatchUi;

//! Show the steps summary
class StepsView extends WatchUi.View {

    private var _timer as Timer.Timer;
    private var _screenShape as ScreenShape;

    //! Constructor
    public function initialize() {
        View.initialize();

        // Set up a 1Hz update timer because we aren't registering
        // for any data callbacks that can kick our display update.
        _timer = new Timer.Timer();
        // Get the screen shape
        _screenShape = System.getDeviceSettings().screenShape;
    }

    //! Handle view coming on screen
    public function onShow() as Void {
        _timer.start(method(:onTimer), 1000, true);
    }

    //! Handle view being hidden
    public function onHide() as Void{
        _timer.stop();
    }

    //! Handle the update event
    //! @param dc Draw context
    public function onUpdate(dc as Dc) as Void {
        var clockTime = System.getClockTime();
        var timeOfDay = ((clockTime.hour * 60) + clockTime.min) * 60 + clockTime.sec;
        var stepsFromGoal = 0;
        var progress = 1;
        var goalProgress = 1;

        // Get wake and sleep time from user profile
        timeOfDay -= (6 * 60 * 60); // Assume 6am Start of day.
        var daySeconds = 57600; // 16 * 60 * 60 assume 16 hour day

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var activityInfo = ActivityMonitor.getInfo();

        var stepGoal = activityInfo.stepGoal;
        var steps = activityInfo.steps;

        // Prevent divide by 0 if stepGoal is 0
        if ((stepGoal == 0) || (stepGoal == null)) {
            stepGoal = 5000;
        }

        if (steps != null) {
            // Compute goal
            var goalPace = stepGoal;
            if (timeOfDay < daySeconds) {
                goalPace = (stepGoal * timeOfDay / daySeconds);
                goalProgress = goalPace * 170 / stepGoal;
            } else {
                goalProgress = 170;
            }
            stepsFromGoal = goalPace - steps;
            if (goalProgress == 0) {
                goalProgress = 1;
            }

            // Compute progress
            if (steps < stepGoal) {
                progress = steps * 170 / stepGoal;
            } else {
                progress = 170;
            }
        }


        // Draw progress bar outline
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        if (System.SCREEN_SHAPE_RECTANGLE == _screenShape) {
            dc.drawRectangle(14, 3, 176, 12);
            dc.drawRectangle(15, 4, 174, 10);
            dc.drawRectangle(16, 5, 172, 8);
        } else {
            dc.drawRectangle(24, 43, 176, 12);
            dc.drawRectangle(25, 44, 174, 10);
            dc.drawRectangle(26, 45, 172, 8);
        }

        // Draw progress
        if (stepsFromGoal > 0) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        } else {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
        }

        if (System.SCREEN_SHAPE_RECTANGLE == _screenShape) {
            dc.fillRectangle(15 + goalProgress, 3, 3, 12);
            dc.fillRectangle(17, 6, progress, 6);
        } else {
            dc.fillRectangle(25 + goalProgress, 43, 3, 12);
            dc.fillRectangle(27, 46, progress, 6);
        }

        // Set colors for drawing text
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Draw Goal Progress
        if (steps != null) {
            var string = steps.toString() + " / " + stepGoal.toString();
            dc.drawText(dc.getWidth() / 2, 18, Graphics.FONT_SMALL, string , Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Draw step offset
        stepsFromGoal = stepsFromGoal * -1;
        dc.drawText(dc.getWidth() / 2, (dc.getHeight() - Graphics.getFontAscent(Graphics.FONT_LARGE)) / 2, Graphics.FONT_LARGE, stepsFromGoal.toString() , Graphics.TEXT_JUSTIFY_CENTER);

        // Indicate sleep mode
        if (activityInfo has :isSleepMode) {
            var string;
            if (activityInfo.isSleepMode) {
                string = "Sleep mode: true";
            } else {
                string = "Sleep mode: false";
            }
            dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2) + Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Draw distance...
        var distance = activityInfo.distance;
        if (distance != null) {
            var distMiles = distance.toFloat() / 160934; // convert from cm to miles
            var string = distMiles.format("%.02f");
            string += "mi";
            if (System.SCREEN_SHAPE_RECTANGLE == _screenShape) {
                dc.drawText(5, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_LEFT);
            } else {
                dc.drawText(dc.getWidth() / 2, dc.getHeight() - 2 * Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            }
        }

        // And calories
        var calories = activityInfo.calories;
        if (calories != null) {
            var string = calories.toString() + "kcal";
            if (System.SCREEN_SHAPE_RECTANGLE == _screenShape) {
                dc.drawText(dc.getWidth() - 5, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_RIGHT);
            } else {
                dc.drawText(dc.getWidth() / 2, dc.getHeight() - Graphics.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            }
        }

        // Draw Move text
        var moveBarLevel = activityInfo.moveBarLevel;
        if ((moveBarLevel != null) && (moveBarLevel != ActivityMonitor.MOVE_BAR_LEVEL_MIN)) {
            var string = "MOVE";
            for (var i = 0; i < moveBarLevel; i++) {
                string += "!";
            }

            dc.drawText(dc.getWidth() / 2, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_MEDIUM), Graphics.FONT_MEDIUM, string, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    //! Timer callback to update the screen
    public function onTimer() as Void {
        // Kick the display update
        WatchUi.requestUpdate();
    }
}
