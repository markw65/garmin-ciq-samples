//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;

//! This data field app uses the Sound Service of the Nordic Thingy:52.
//! The field will pair with the first Thingy it encounters and will
//! play a Coin Collection sample every 2 seconds.
class Thingy52CoinCollectorApp extends Application.AppBase {
    private var _profileManager as ProfileManager?;
    private var _bleDelegate as ThingyDelegate?;
    private var _deviceManager as DeviceManager?;

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
        _profileManager = new $.ProfileManager();
        _bleDelegate = new $.ThingyDelegate(_profileManager as ProfileManager);
        _deviceManager = new $.DeviceManager(
            _bleDelegate as ThingyDelegate,
            _profileManager as ProfileManager
        );

        BluetoothLowEnergy.setDelegate(_bleDelegate as ThingyDelegate);
        (_profileManager as ProfileManager).registerProfiles();
        (_deviceManager as DeviceManager).start();
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
        _deviceManager = null;
        _bleDelegate = null;
        _profileManager = null;
    }

    //! Return the initial view for the app
    //! @return Array [View]
    public function getInitialView() as Array<Views or InputDelegates>? {
        var deviceManager = _deviceManager;
        if (deviceManager != null) {
            return [new $.Thingy52CoinCollectorView(deviceManager)] as Array<Views>;
        }
        return null;
    }
}
