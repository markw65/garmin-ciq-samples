//
// Copyright 2017-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input delegate for the AntSensor data view
class AntDelegate extends WatchUi.BehaviorDelegate {

    private var _sensor as AntModule.AntSensor;

    //! Constructor
    //! @param antSensor an AntModule.AntSensor
    public function initialize(antSensor as AntModule.AntSensor) {
        WatchUi.BehaviorDelegate.initialize();
        _sensor = antSensor;
        _sensor.open();
    }

    //! Toggles channel in and out of encryption mode
    //! @return true if event is handled, false otherwise
    public function onSelect() as Boolean {
        if (_sensor.isEncrypted()) {
            _sensor.disableEncryption();
        } else {
            _sensor.enableChannelEncryption();
        }
        return true;
    }

    //! Returns app back to the menu state
    //! @return true if event is handled, false otherwise
    public function onBack() as Boolean {
        _sensor.disableEncryption();
        _sensor.release();
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}