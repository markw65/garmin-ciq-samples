//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app uses Drawables to display a train, landscape, and an animated cloud.
class DrawableApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary) as Void {
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary) as Void {
    }

    //! Return the initial view for the app
    //! @return Array [View]
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [new $.DrawableView()] as Array<Views>;
    }

}
