//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Main view that shows the picked values
class PickerView extends WatchUi.View {

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.MainLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This include
    //! loading resources into memory.
    public function onShow() as Void {
        // find and modify the labels based on what is in storage
        var string = findDrawableById("string") as Text;
        var date = findDrawableById("date") as Text;
        var time = findDrawableById("time") as Text;

        var prop = Storage.getValue("string");
        if (prop instanceof String) {
            string.setText(prop);
        }

        prop = Storage.getValue("date");
        if (prop instanceof String) {
            date.setText(prop);
        }

        prop = Storage.getValue("time");
        if (prop instanceof String) {
            time.setText(prop);
        }

        // set the color of each Text object
        prop = Storage.getValue("color");
        if (prop instanceof Number) {
            time.setColor(prop);
            date.setColor(prop);
            string.setColor(prop);
        }
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
    }

}

//! Input handler for the main view
class PickerDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle the menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        return pushPicker();
    }

    //! Handle a button being pressed and released
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKey(evt as KeyEvent) as Boolean {
        var key = evt.getKey();
        if ((WatchUi.KEY_START == key) || (WatchUi.KEY_ENTER == key)) {
            return pushPicker();
        }
        return false;

    }

    //! Handle the select behavior
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        return pushPicker();
    }

    //! Push a new picker view
    //! @return true if handled, false otherwise
    public function pushPicker() as Boolean {
        WatchUi.pushView(new $.PickerChooser(), new $.PickerChooserDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}