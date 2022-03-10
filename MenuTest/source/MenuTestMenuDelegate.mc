//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.

import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Input handler to respond to main menu selections
class MenuTestMenuDelegate extends WatchUi.MenuInputDelegate {

    //! Constructor
    public function initialize() {
        MenuInputDelegate.initialize();
    }

    //! Handle a menu item being selected
    //! @param item Symbol identifier of the menu item that was chosen
    public function onMenuItem(item as Symbol) as Void {
        if (item == :Item1) {
            System.println("Item 1");
            WatchUi.pushView(new $.Rez.Menus.AuxMenu(), new $.AuxMenuDelegate(), WatchUi.SLIDE_UP);
        } else if (item == :Item2) {
            System.println("Item 2");
        }
    }
}
