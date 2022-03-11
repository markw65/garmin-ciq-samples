//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This data field app tracks and displays the lap number.
//! It uses timer events to reset and color the lap number.
class FieldTimerEventsApp extends Application.AppBase {
    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {}

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {}

    //! Return the initial view for the app
    //! @return Array of initial view
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [new $.FieldTimerEventsView()] as Array<Views>;
    }
}
