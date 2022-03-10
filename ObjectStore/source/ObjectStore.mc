//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app demonstrates saving and retrieving data in the object store on
//! the device. The object store has been deprecated in ConnectIQ 4.0.0 and
//! replaced by Application.Properties and Application.Storage.
class ObjectStore extends Application.AppBase {

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
        return [new $.ObjectStoreView(), new $.ObjectStoreViewDelegate()] as Array<Views or InputDelegates>;
    }

    //! For this app all that needs to be done is trigger a WatchUi refresh
    //! since the settings are only used in onUpdate().
    public function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}
