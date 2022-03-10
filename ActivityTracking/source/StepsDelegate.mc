//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Handle input for the steps view
class StepsDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle the back event
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    //! Handle the next page event
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        WatchUi.switchToView(new $.HistoryView(), new $.HistoryDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    //! Handle the previous page event
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        WatchUi.switchToView(new $.HistoryView(), new $.HistoryDelegate(), WatchUi.SLIDE_DOWN);
        return true;
    }
}