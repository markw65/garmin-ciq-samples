//
// Copyright 2017-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input delegate for the main view
class EncryptionDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        // Initializes parent class
        BehaviorDelegate.initialize();
    }

    //! Pushes Master Slave menu when they trigger the Menu
    //! @return true if event was handled, false otherwise
    public function onMenu() as Boolean {
        WatchUi.pushView(new $.Rez.Menus.MainMenu(), new $.EncryptionMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    //! Pushes Master Slave menu when they do a select action
    //! @return true if event was handled, false otherwise
    public function onSelect() as Boolean {
        WatchUi.pushView(new $.Rez.Menus.MainMenu(), new $.EncryptionMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}