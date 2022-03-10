//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;

class DataModelFactory {
    // Dependencies
    private var _delegate as ThingyDelegate;
    private var _profileManager as ProfileManager;

    // Model Storage
    private var _scanDataModel as WeakReference?;
    private var _deviceDataModel as WeakReference?;
    private var _envModel as WeakReference?;

    //! Constructor
    //! @param delegate The BLE delegate to use for the models
    //! @param profileManager The profile manager to use for a profile model
    public function initialize(delegate as ThingyDelegate, profileManager as ProfileManager) {
        _delegate = delegate;
        _profileManager = profileManager;
    }

    //! Get a scan data model instance
    //! @return The current scan data model or a new one
    public function getScanDataModel() as ScanDataModel {
        var scanDataModel = _scanDataModel;
        if (scanDataModel != null) {
            if (scanDataModel.stillAlive()) {
                return (scanDataModel.get() as ScanDataModel);
            }
        }

        var dataModel = new $.ScanDataModel(_delegate);
        _scanDataModel = dataModel.weak();

        return dataModel;
    }

    //! Get a device data model instance
    //! @param scanResult The scan result to use for a new model
    //! @return The current device data model or a new one
    public function getDeviceDataModel(scanResult as ScanResult) as DeviceDataModel {
        var deviceDataModel = _deviceDataModel;
        if (deviceDataModel != null) {
            if (deviceDataModel.stillAlive()) {
                return (deviceDataModel.get() as DeviceDataModel);
            }
        }

        var dataModel = new $.DeviceDataModel(_delegate, self, scanResult);
        _deviceDataModel = dataModel.weak();

        return dataModel;
    }

    //! Get a environment profile model instance
    //! @param device The device to use for a new model
    //! @return The current environment profile model or a new one
    public function getEnvironmentModel(device as Device) as EnvironmentProfileModel {
        var envModel = _envModel;
        if (envModel != null) {
            if (envModel.stillAlive()) {
                return (envModel.get() as EnvironmentProfileModel);
            }
        }

        var dataModel = new $.EnvironmentProfileModel(_delegate, _profileManager, device);
        _envModel = dataModel.weak();

        return dataModel;
    }
}
