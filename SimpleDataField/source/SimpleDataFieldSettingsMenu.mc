//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;

//! The settings menu
class DataFieldSettingsMenu extends WatchUi.Menu2 {

    //! Constructor
    public function initialize() {
        Menu2.initialize({:title=>"Settings"});
    }
}

//! Handles menu input and stores the menu data
class DataFieldSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle a menu item selection
    //! @param menuItem The selected menu item
    public function onSelect(menuItem as ToggleMenuItem) as Void {
        var id = menuItem.getId();
        if (id instanceof Number) {
            Storage.setValue(id as Number, menuItem.isEnabled());
        }
    }
}
