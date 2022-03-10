//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler to stop timer on menu press
class TimerDelegate extends WatchUi.BehaviorDelegate {
    private var _view as TimerView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as TimerView) {
        WatchUi.BehaviorDelegate.initialize();
        _view = view;
    }

    //! Stop the first timer on menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        _view.stopTimer();
        return true;
    }
}