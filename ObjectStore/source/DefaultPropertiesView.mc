//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

// The object store properties shown here are deprecated in ConnectIQ 4.0.0.
// Use Application.Properties or Application.Storage instead.

import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

enum DefaultProps {
    PROP_NUMBER = "number_prop",
    PROP_FLOAT = "float_prop",
    PROP_STRING = "string_prop",
    PROP_BOOLEAN = "boolean_prop"
}

//! Show the default property values in the object store
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

    //! Load the resources
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.SettingsLayout(dc));
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        var app = Application.getApp();

        var int = app.getProperty($.PROP_NUMBER);
        var float = app.getProperty($.PROP_FLOAT);
        var string = app.getProperty($.PROP_STRING);
        var boolean = app.getProperty($.PROP_BOOLEAN);

        if (null == int) {
            int = "Not set";
        }

        if (null == float) {
            float = "Not set";
        }

        if (null == string) {
            string = "Not set";
        }

        if (null == boolean) {
            boolean = "Not set";
        }

        var intLabel = View.findDrawableById("IntLabel") as Text;
        var floatLabel = View.findDrawableById("FloatLabel") as Text;
        var stringLabel = View.findDrawableById("StringLabel") as Text;
        var boolLabel = View.findDrawableById("BoolLabel") as Text;

        intLabel.setText("Int: " + int.toString());
        floatLabel.setText("Float: " + float.toString());
        stringLabel.setText("String: " + string.toString());
        boolLabel.setText("Boolean: " + boolean.toString());

        View.onUpdate(dc);

        _indicator.draw(dc, 1);
    }
}

//! Handle input on the default properties view
class DefaultPropertiesViewDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        WatchUi.switchToView(new $.ObjectStoreView(), new $.ObjectStoreViewDelegate(), WatchUi.SLIDE_LEFT);
        return true;
    }

    //! Handle going to the previous view
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        WatchUi.switchToView(new $.ObjectStoreView(), new $.ObjectStoreViewDelegate(), WatchUi.SLIDE_RIGHT);
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

    //! Handle a screen tap event
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onTap(evt as ClickEvent?) as Boolean {
        var app = Application.getApp();
        var int = app.getProperty($.PROP_NUMBER);
        if (int instanceof Number) {
            int++;
            app.setProperty($.PROP_NUMBER, int);
        }

        WatchUi.requestUpdate();
        return true;
    }
}
