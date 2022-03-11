//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app displays graphs containing the sensor history data for
//! heart rate, temperature, pressure, elevation, and oxygen saturation.
class SensorHistoryApp extends Application.AppBase {
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
    //! @return Array Pair [View, Delegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [
            new $.SensorHistoryBaseView(),
            new $.SensorHistoryBaseDelegate(),
        ] as Array<Views or InputDelegates>;
    }
}
