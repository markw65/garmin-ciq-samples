//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! This app demonstrates the generic picker features by creating different
//! pickers for selecting colors, dates, strings, or times. It also includes
//! a layout picker to show the layout of the picker on a given device.
class PickerApp extends Application.AppBase {
    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
        // make sure that there is a valid color in storage to
        // prevent null checks in several places
        if (Storage.getValue("color") == null) {
            Storage.setValue("color", Graphics.COLOR_RED);
        }
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {}

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [new $.PickerView(), new $.PickerDelegate()] as Array<Views or InputDelegates>;
    }
}
