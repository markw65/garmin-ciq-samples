//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;

class ThingyDelegate extends BluetoothLowEnergy.BleDelegate {
    private var _profileManager as ProfileManager;

    private var _onScanResult as WeakReference?;
    private var _onConnection as WeakReference?;
    private var _onDescriptorWrite as WeakReference?;
    private var _onCharChanged as WeakReference?;

    //! Constructor
    //! @param profileManager The profile manager
    public function initialize(profileManager as ProfileManager) {
        BleDelegate.initialize();
        _profileManager = profileManager;
    }

    //! Handle new scan results being received
    //! @param scanResults An iterator of new scan results
    public function onScanResults(scanResults as Iterator) as Void {
        for (var result = scanResults.next(); result != null; result = scanResults.next()) {
            if (result instanceof ScanResult) {
                if (contains(result.getServiceUuids(), _profileManager.THINGY_CONFIGURATION_SERVICE)) {
                    broadcastScanResult(result);
                }
            }
        }
    }

    //! Handle pairing and connecting to a device
    //! @param device The device state that was changed
    //! @param state The state of the connection
    public function onConnectedStateChanged(device as Device, state as ConnectionState) as Void {
        var onConnection = _onConnection;
        if (null != onConnection) {
            if (onConnection.stillAlive()) {
                (onConnection.get() as DeviceDataModel).procConnection(device);
            }
        }
    }

    //! Handle the completion of a write operation on a descriptor
    //! @param descriptor The descriptor that was written
    //! @param status The BluetoothLowEnergy status indicating the result of the operation
    public function onDescriptorWrite(descriptor as Descriptor, status as Status) as Void {
        var onDescriptorWrite = _onDescriptorWrite;
        if (null != onDescriptorWrite) {
            if (onDescriptorWrite.stillAlive()) {
                (onDescriptorWrite.get() as EnvironmentProfileModel).onDescriptorWrite(descriptor, status);
            }
        }
    }

    //! Handle a characteristic being changed
    //! @param char The characteristic that changed
    //! @param value The updated value of the characteristic
    public function onCharacteristicChanged(char as Characteristic, value as ByteArray) as Void {
        var onCharChanged = _onCharChanged;
        if (null != onCharChanged) {
            if (onCharChanged.stillAlive()) {
                (onCharChanged.get() as EnvironmentProfileModel).onCharacteristicChanged(char, value);
            }
        }
    }

    //! Store a new model to manage scan results
    //! @param model The model containing scan results
    public function notifyScanResult(model as ScanDataModel) as Void {
        _onScanResult = model.weak();
    }

    //! Store a new model to manage device data connections
    //! @param model The model for device data
    public function notifyConnection(model as DeviceDataModel) as Void {
        _onConnection = model.weak();
    }

    //! Store a new model to handle descriptor writes
    //! @param model The model for descriptors
    public function notifyDescriptorWrite(model as EnvironmentProfileModel) as Void {
        _onDescriptorWrite = model.weak();
    }

    //! Store a new model to handle characteristic changes
    //! @param model The model for characteristics
    public function notifyCharacteristicChanged(model as EnvironmentProfileModel) as Void {
        _onCharChanged = model.weak();
    }

    //! Broadcast a new scan result
    //! @param scanResult The new scan result
    private function broadcastScanResult(scanResult as ScanResult) as Void {
        var onScanResult = _onScanResult;
        if (null != onScanResult) {
            if (onScanResult.stillAlive()) {
                (onScanResult.get() as ScanDataModel).procScanResult(scanResult);
            }
        }
    }

    //! Get whether the iterator contains a specific uuid
    //! @param iter Iterator of uuid objects
    //! @param obj Uuid to search for
    //! @return true if object found, false otherwise
    private function contains(iter as Iterator, obj as Uuid) as Boolean {
        for (var uuid = iter.next(); uuid != null; uuid = iter.next()) {
            if (uuid.equals(obj)) {
                return true;
            }
        }

        return false;
    }
}
