//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

enum PropKeys {
    PROP_INT = "number_prop",
    PROP_LONG = "long_prop",
    PROP_FLOAT = "float_prop",
    PROP_DOUBLE = "double_prop",
    PROP_STRING = "string_prop",
    PROP_BOOLEAN = "boolean_prop"
}

//! Show the current property values
class DefaultPropertiesView extends WatchUi.View {

    private var _indicator as PageIndicator;

    //! Constructor
    public function initialize() {
        View.initialize();

        var size = 2;
        var selected = Graphics.COLOR_DK_GRAY;
        var notSelected = Graphics.COLOR_LT_GRAY;
        var alignment = $.ALIGN_TOP_RIGHT;
        var margin = 3;
        _indicator = new $.PageIndicator(size, selected, notSelected, alignment, margin);
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.SettingsLayout(dc));
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        updateLabel("IntLabel", getDisplayString("Int", $.PROP_INT));
        updateLabel("LongLabel", getDisplayString("Long", $.PROP_LONG));
        updateLabel("FloatLabel", getDisplayString("Float", $.PROP_FLOAT));
        updateLabel("DoubleLabel", getDisplayString("Double", $.PROP_DOUBLE));
        updateLabel("StringLabel", getDisplayString("String", $.PROP_STRING));
        updateLabel("BoolLabel", getDisplayString("Boolean", $.PROP_BOOLEAN));

        View.onUpdate(dc);

        _indicator.draw(dc, 1);
    }

    //! Get a string with the property value and given prefix
    //! @param propertyPrefix Label to prefix the property value
    //! @param propertyId The key for the property
    //! @return String with the property prefix and value
    private function getDisplayString(propertyPrefix as String, propertyId as PropertyKeyType) as String {
        var value = Properties.getValue(propertyId);
        if (value == null) {
            value = "Not set";
        }
        return propertyPrefix + ": " + value.toString();
    }

    //! Update a label with new text
    //! @param labelId The label to update
    //! @param labelText The text for the label
    private function updateLabel(labelId as String, labelText as String) as Void {
        var drawable = View.findDrawableById(labelId);
        if (drawable != null) {
            (drawable as Text).setText(labelText);
        }
    }
}

//! Input handler for the properties view
class DefaultPropertiesViewDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        WatchUi.switchToView(new $.ApplicationStorageView(), new $.ApplicationStorageViewDelegate(), WatchUi.SLIDE_LEFT);
        return true;
    }

    //! Handle going to the previous view
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        WatchUi.switchToView(new $.ApplicationStorageView(), new $.ApplicationStorageViewDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }

    //! Handle a physical button being pressed and released
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKey(evt as KeyEvent) as Boolean {
        if (evt.getKey() == WatchUi.KEY_ENTER) {
            return onTap(null);
        }
        return false;
    }

    //! On a screen tap, increment the int property
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onTap(evt as ClickEvent?) as Boolean {
        var int = Properties.getValue($.PROP_INT);
        if (int instanceof Number) {
            int++;
            Properties.setValue($.PROP_INT, int);
        }
        WatchUi.requestUpdate();
        return true;
    }

}
