//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.

import Toybox.Lang;
import Toybox.WatchUi;

//! Handle input for the home view
class MenuTestDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle the menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        WatchUi.pushView(new $.Rez.Menus.MainMenu(), new $.MenuTestMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}
