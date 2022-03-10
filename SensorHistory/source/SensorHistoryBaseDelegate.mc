//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Handle input on initial view
class SensorHistoryBaseDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle the select button
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        var view = new $.SensorHistoryView();
        var delegate = new $.SensorHistoryDelegate(view);
        pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}