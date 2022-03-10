//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! DataField View class to show the current lap number
class FieldTimerEventsView extends WatchUi.DataField
{
    private enum TimerState
    {
        STATE_STOPPED,
        STATE_PAUSED,
        STATE_RUNNING
    }

    private var _lapNumber as Number = 0;
    private var _timerState as TimerState = STATE_STOPPED;
    private var _lapCertainty as String = "";

    //! Constructor
    public function initialize()
    {
        DataField.initialize();

        var info = Activity.getActivityInfo();

        // If the activity timer is greater than 0, then we don't know the lap or timer state.
        if (info != null) {
            var timerTime = info.timerTime;
            if (timerTime != null) {
                if (timerTime > 0) {
                    _lapCertainty = "?";
                }
            }
        }
    }

    //! This is called each time a lap is created, so increment the lap number.
    public function onTimerLap() as Void {
        _lapNumber++;
    }

    //! This is called each time a Workout Step finishes, so increment the lap number.
    public function onWorkoutStepComplete() as Void {
        _lapNumber++;
    }

    //! This is called each time a Multisport activity advances to the next leg. Reset the laps
    public function onNextMultisportLeg() as Void {
        _lapNumber = 0;
    }

    //! The timer was started, so set the state to running.
    public function onTimerStart() as Void {
        _timerState = STATE_RUNNING;
    }

    //! The timer was stopped, so set the state to stopped.
    public function onTimerStop() as Void {
        _timerState = STATE_STOPPED;
    }

    //! The timer was started, so set the state to running.
    public function onTimerPause() as Void {
        _timerState = STATE_PAUSED;
    }

    //! The timer was stopped, so set the state to stopped.
    public function onTimerResume() as Void {
        _timerState = STATE_RUNNING;
    }

    //! The timer was reset, so reset all our tracking variables
    public function onTimerReset() as Void {
        _lapNumber = 0;
        _timerState = STATE_STOPPED;
        _lapCertainty = "";
    }

    //! The given info object contains all the current workout
    //! information. Calculate a value and save it locally in this method.
    //! @param info Activity.Info object
    public function compute(info as Info) as Void {
    }

    //! Display the value you computed here. This will be called
    //! once a second when the data field is visible.
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        // Timer events are supported so update the view with the
        // current timer/lap information.
        if (WatchUi.DataField has :onTimerLap) {
            var dataColor = Graphics.COLOR_RED;

            // Select text color based on timer state.
            if (_timerState == null) {
                dataColor = Graphics.COLOR_BLACK;
            } else if (_timerState == STATE_RUNNING) {
                dataColor = Graphics.COLOR_GREEN;
            } else if (_timerState == STATE_PAUSED) {
                dataColor = Graphics.COLOR_YELLOW;
            }

            dc.setColor(dataColor, Graphics.COLOR_WHITE);
            dc.clear();

            // Construct the lap string.
            var lapString = _lapNumber.format("%d") + _lapCertainty;

            // Draw the lap number
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, lapString, (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));

        // Timer events are not supported so show a message letting
        // the user know that.
        } else {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
            dc.clear();

            var message = "Timer Events\nNot Supported";
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, message, (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
        }
    }
}
