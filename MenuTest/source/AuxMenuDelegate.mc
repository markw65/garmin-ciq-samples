//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Input handler to respond to Aux menu selections
class AuxMenuDelegate extends WatchUi.MenuInputDelegate {

    //! Constructor
    public function initialize() {
        MenuInputDelegate.initialize();
    }

    //! Handle a menu item being selected
    //! @param item Symbol identifier of the menu item that was chosen
    public function onMenuItem(item as Symbol) as Void {
        if (item == :AuxItem1) {
            System.println("Aux Item 1");
        } else if (item == :AuxItem2) {
            System.println("Aux Item 2");
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }
}
