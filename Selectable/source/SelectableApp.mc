//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app demonstrates how to use Selectables and Buttons.
//! The app shows check box Selectable objects that can be highlighted and
//! selected by holding and tapping on touch devices or by pressing menu
//! and then up/down and select on non-touch devices.
class SelectableApp extends Application.AppBase {

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

    //! Return the initial view for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        var view = new $.CheckBoxView();
        var delegate = new $.CheckBoxDelegate(view);
        return [view, delegate] as Array<Views or InputDelegates>;
    }

}