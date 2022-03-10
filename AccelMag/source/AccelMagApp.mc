//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app lets you test the accelerometer and magnetometer. You control a ball
//! on the screen by tipping the device in certain directions. You can 'kick' the
//! ball by pressing the start button.
class AccelMagApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        var mainView = new $.AccelMagView();
        var viewDelegate = new $.AccelMagDelegate(mainView);
        return [mainView, viewDelegate] as Array<Views or InputDelegates>;
    }

}