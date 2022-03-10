//
// Copyright 2017-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! The primary input handling delegate for the background timer.
(:typecheck(disableBackgroundCheck))
class BackgroundTimerDelegate extends WatchUi.BehaviorDelegate {
    private var _parentView as BackgroundTimerView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as BackgroundTimerView) {
        BehaviorDelegate.initialize();
        _parentView = view;
    }

    //! Call the start stop timer method on the parent view
    //! when the select action occurs (start/stop button on most products)
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        _parentView.startStopTimer();
        return true;
    }

    //! Call the reset method on the parent view when the
    //! back action occurs.
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        return _parentView.resetTimer();
    }
}