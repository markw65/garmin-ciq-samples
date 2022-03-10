//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Class to show the picker layout for the current device
class LayoutPicker extends WatchUi.Picker {

    //! Constructor
    public function initialize() {
        var factory = new $.RectangleFactory(Graphics.COLOR_PURPLE);
        Picker.initialize({:title=>new $.Rectangle(Graphics.COLOR_RED),
                           :pattern=>[factory, factory, factory, factory, factory],
                           :nextArrow=>new $.Rectangle(Graphics.COLOR_GREEN),
                           :previousArrow=>new $.Rectangle(Graphics.COLOR_GREEN),
                           :confirm=>new $.Rectangle(Graphics.COLOR_WHITE)});
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

//! Responds to a layout picker selection or cancellation
class LayoutPickerDelegate extends WatchUi.PickerDelegate {

    //! Constructor
    public function initialize() {
        PickerDelegate.initialize();
    }

    //! Handle a cancel event from the picker
    //! @return true if handled, false otherwise
    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! Handle a confirm event from the picker
    //! @param values The values chosen in the picker
    //! @return true if handled, false otherwise
    public function onAccept(values as Array) as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
