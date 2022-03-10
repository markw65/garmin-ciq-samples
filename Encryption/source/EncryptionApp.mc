//
// Copyright 2017-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! This application creates an ANT channel and
//! allows the channel to be encrypted or not
class EncryptionApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [new $.EncryptionView(), new $.EncryptionDelegate()] as Array<Views or InputDelegates>;
    }

}
