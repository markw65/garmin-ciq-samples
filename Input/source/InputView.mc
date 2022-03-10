//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Displays information about which behavior / input events are triggered
class InputView extends WatchUi.View {

    private var _action as Action;
    private var _statusString as String;
    private var _behavior as Behavior;
    private var _button as Button;
    private var _actionHits as Number;
    private var _behaviorHits as Number;

    //! Constructor
    public function initialize() {
        View.initialize();
        _action = $.ACTION_NONE;
        _behavior = $.BEHAVIOR_NONE;
        _statusString = $.STATUS_NONE;
        _button = $.BUTTON_PUSH;
        _actionHits = 0;
        _behaviorHits = 0;
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var dy = dc.getFontHeight(Graphics.FONT_SMALL);
        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        y -= (4 * dy) / 2;

        dc.drawText(x, y, Graphics.FONT_SMALL, _action.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        dc.drawText(x, y, Graphics.FONT_SMALL, _behavior.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        dc.drawText(x, y, Graphics.FONT_SMALL, _statusString, Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        dc.drawText(x, y, Graphics.FONT_SMALL, _button.toString(), Graphics.TEXT_JUSTIFY_CENTER);
    }

    //! Set the status string
    //! @param newStatus The new status
    public function setStatusString(newStatus as String) as Void {
        _statusString = newStatus;
        WatchUi.requestUpdate();
    }

    //! Set the action
    //! @param newAction The new action
    public function setAction(newAction as Action) as Void {
        _action = newAction;
        _actionHits++;

        if (_actionHits > _behaviorHits) {
            _behavior = $.BEHAVIOR_NONE;
            _behaviorHits = _actionHits;
        }

        WatchUi.requestUpdate();
    }

    //! Set the behavior
    //! @param newBehavior The new behavior
    public function setBehavior(newBehavior as Behavior) as Void {
        _behavior = newBehavior;
        _behaviorHits++;
        WatchUi.requestUpdate();
    }

    //! Set the button
    //! @param newButton The new button
    public function setButton(newButton as Button) as Void {
        _button = newButton;
        WatchUi.requestUpdate();
    }
}
