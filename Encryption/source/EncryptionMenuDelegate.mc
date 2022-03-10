//
// Copyright 2017-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Menu delegate for the main view
class EncryptionMenuDelegate extends WatchUi.MenuInputDelegate {

    //! Constructor
    public function initialize() {
        MenuInputDelegate.initialize();
    }

    //! Handle selection of a menu item
    //! @param item Symbol identifier of the menu item that was chosen
    public function onMenuItem(item as Symbol) as Void {
        var sensor;
        if (item == :master) {
            // Creates a AntSensor object with a master channel
            sensor = new $.AntModule.AntSensor(true);
        } else {
            // Creates a AntSensor object with a slave channel
            sensor = new $.AntModule.AntSensor(false);
        }
        // Pushes view that displays AntSensor data
        WatchUi.pushView(new $.AntView(sensor), new $.AntDelegate(sensor), WatchUi.SLIDE_RIGHT);
    }
}