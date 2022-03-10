//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Handle moving between sensor views
class SensorHistoryDelegate extends WatchUi.BehaviorDelegate {

    private var _view as SensorHistoryView;

    //! Constructor
    public function initialize(view as SensorHistoryView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        _view.nextSensor();
        WatchUi.requestUpdate();
        return true;
    }

    //! Handle going to the previous view
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        _view.previousSensor();
        WatchUi.requestUpdate();
        return true;
    }
}