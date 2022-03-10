//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler for the confirmation dialog
class ConfirmationDialogDelegate extends WatchUi.ConfirmationDelegate {

    private var _confirmString as String;
    private var _cancelString as String;
    private var _view as ConfirmationDialogView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as ConfirmationDialogView) {
        ConfirmationDelegate.initialize();
        _confirmString = WatchUi.loadResource($.Rez.Strings.Confirm) as String;
        _cancelString = WatchUi.loadResource($.Rez.Strings.Cancel) as String;
        _view = view;
    }

    //! Handle a confirmation selection
    //! @param value The confirmation value
    //! @return true if handled, false otherwise
    public function onResponse(value as Confirm) as Boolean {
        if (value == WatchUi.CONFIRM_NO) {
            _view.setResultString(_cancelString);
        } else {
            _view.setResultString(_confirmString);
        }
        return true;
    }
}

//! Input handler to push confirmation dialog
class BaseInputDelegate extends WatchUi.BehaviorDelegate {

    private var _dialogHeaderString as String;
    private var _view as ConfirmationDialogView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as ConfirmationDialogView) {
        BehaviorDelegate.initialize();
        _dialogHeaderString = WatchUi.loadResource($.Rez.Strings.DialogHeader) as String;
        _view = view;
    }

    //! Handle menu input
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        return pushDialog();
    }

    //! Handle select button
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        return pushDialog();
    }

    //! Push a confirmation dialog view
    //! @return true if handled, false otherwise
    private function pushDialog() as Boolean {
        var dialog = new WatchUi.Confirmation(_dialogHeaderString);
        WatchUi.pushView(dialog, new $.ConfirmationDialogDelegate(_view), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}