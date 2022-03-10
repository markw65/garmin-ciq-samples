//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

class DeviceDelegate extends WatchUi.BehaviorDelegate {
    private var _deviceDataModel as DeviceDataModel;

    //! Constructor
    //! @param deviceDataModel The device data model
    public function initialize(deviceDataModel as DeviceDataModel) {
        BehaviorDelegate.initialize();

        _deviceDataModel = deviceDataModel;
        _deviceDataModel.pair();
    }

    //! Handle the back behavior
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        _deviceDataModel.unpair();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
