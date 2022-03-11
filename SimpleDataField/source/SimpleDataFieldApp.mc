//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app is a simple data field that alternates
//! between showing heart rate, distance and total time.
//! It also uses the data field settings and alerts.
class SimpleDataField extends Application.AppBase {
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
    //! @return Array [View]
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [new $.DataField()] as Array<Views>;
    }

    //! Return the settings view and delegate for the app
    //! @return Array Pair [View, Delegate]
    public function getSettingsView() as Array<Views or InputDelegates>? {
        return [
            new $.DataFieldSettingsView(),
            new $.DataFieldSettingsDelegate(),
        ] as Array<Views or InputDelegates>;
    }
}
