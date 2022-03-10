//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This application shows how to use an Ant MO2 Sensor
class MO2DisplayApp extends Application.AppBase {
    private var _sensor as MO2Sensor;

    //! Constructor
    public function initialize() {
        AppBase.initialize();
        _sensor = new $.MO2Sensor();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
        // Open the sensor object
        _sensor.open();
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
        // Release the sensor
        _sensor.closeSensor();
        _sensor.release();
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        // The initial view is located at index 0
        var index = 0;
        return [new $.MainView(_sensor, index), new $.MO2Delegate(_sensor, index)] as Array<Views or InputDelegates>;
    }
}
