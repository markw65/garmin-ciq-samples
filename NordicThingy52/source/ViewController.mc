//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;

class ViewController {
    private var _modelFactory as DataModelFactory;

    //! Constructor
    //! @param modelFactory Factory to create models
    public function initialize(modelFactory as DataModelFactory) {
        _modelFactory = modelFactory;
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as Array<ScanView or ScanDelegate> {
        var scanDataModel = _modelFactory.getScanDataModel();

        return [
            new $.ScanView(scanDataModel),
            new $.ScanDelegate(scanDataModel, self),
        ] as Array<ScanView or ScanDelegate>;
    }

    //! Push the scan menu view
    public function pushScanMenu() as Void {
        WatchUi.pushView(
            new $.Rez.Menus.MainMenu(),
            new $.ScanMenuDelegate(),
            WatchUi.SLIDE_UP
        );
    }

    //! Push the device view
    //! @param scanResult The scan result for the device view to push
    public function pushDeviceView(scanResult as ScanResult) as Void {
        var deviceDataModel = _modelFactory.getDeviceDataModel(scanResult);

        WatchUi.pushView(
            new $.DeviceView(deviceDataModel),
            new $.DeviceDelegate(deviceDataModel),
            WatchUi.SLIDE_UP
        );
    }
}
