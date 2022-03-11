//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app shows the different Menu2 menus that can be used,
//! including menus with toggles, checkboxes, icons, and images.
class Menu2Sample extends Application.AppBase {
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
    //! @return Array [View, Delegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [new $.Menu2TestView(), new $.Menu2TestDelegate()] as Array<Views or InputDelegates>;
    }
}
