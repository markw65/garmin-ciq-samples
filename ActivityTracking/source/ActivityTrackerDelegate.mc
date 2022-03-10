//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler for the main view
class ActivityTrackerDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle the select button
    //! @return true if event is handled
    public function onSelect() as Boolean {
        WatchUi.pushView(new $.StepsView(), new $.StepsDelegate(), WatchUi.SLIDE_LEFT);
        return true;
    }
}