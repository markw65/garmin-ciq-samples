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

enum Keys {
    KEY_INT,
    KEY_FLOAT,
    KEY_STRING,
    KEY_BOOLEAN,
    KEY_ARRAY,
    KEY_DICTIONARY,
    KEY_COUNT
}

//! Show the object store properties
class ObjectStoreView extends WatchUi.View {

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

    //! Load the resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.StoreLayout(dc));
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        var app = Application.getApp();

        var int = app.getProperty($.KEY_INT);
        var float = app.getProperty($.KEY_FLOAT);
        var string = app.getProperty($.KEY_STRING);
        var boolean = app.getProperty($.KEY_BOOLEAN);
        var array = app.getProperty($.KEY_ARRAY);
        var dictionary = app.getProperty($.KEY_DICTIONARY);

        if (null == int) {
            int="Not set";
        }

        if (null == float) {
            float="Not set";
        }

        if (null == string) {
            string="Not set";
        }

        if (null == boolean) {
            boolean="Not set";
        }

        if (null == array) {
            array="Not set";
        }

        if (null == dictionary) {
            dictionary="Not set";
        }

        var intLabel = View.findDrawableById("IntLabel") as Text;
        var floatLabel = View.findDrawableById("FloatLabel") as Text;
        var stringLabel = View.findDrawableById("StringLabel") as Text;
        var boolLabel = View.findDrawableById("BoolLabel") as Text;
        var arrLabel = View.findDrawableById("ArrayLabel") as Text;
        var dictLabel = View.findDrawableById("DictLabel") as Text;

        intLabel.setText("Int: " + int.toString());
        floatLabel.setText("Float: " + float.toString());
        stringLabel.setText("String: " + string.toString());
        boolLabel.setText("Boolean: " + boolean.toString());
        arrLabel.setText("Array: " + array.toString());
        dictLabel.setText("Dictionary: " + dictionary.toString());

        View.onUpdate(dc);

        _indicator.draw(dc, 0);
    }
}

//! Handle input on the object store view
class ObjectStoreViewDelegate extends WatchUi.BehaviorDelegate {
    private var _count as Number;

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
        var count = Application.getApp().getProperty("count");
        if (count instanceof Number) {
            _count = count;
        } else {
            _count = 0;
        }
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        WatchUi.switchToView(new $.DefaultPropertiesView(), new $.DefaultPropertiesViewDelegate(), WatchUi.SLIDE_LEFT);
        return true;
    }

    //! Handle going to the previous view
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        WatchUi.switchToView(new $.DefaultPropertiesView(), new $.DefaultPropertiesViewDelegate(), WatchUi.SLIDE_RIGHT);
        return true;
    }

    //! Handle a physical button being pressed and released
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKey(evt as KeyEvent) as Boolean {
        if (evt.getKey() == WatchUi.KEY_ENTER) {
            return onTap(null);
        } else if (evt.getKey() == WatchUi.KEY_MENU) {
            return onHold(null);
        }
        return false;
    }

    //! Handle a screen tap event
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onTap(evt as ClickEvent?) as Boolean {
        var app = Application.getApp();

        if ($.KEY_INT == _count) {
            app.setProperty($.KEY_INT, 3);
        } else if ($.KEY_FLOAT == _count) {
            app.setProperty($.KEY_FLOAT, 3.14159);
        } else if ($.KEY_STRING == _count) {
            app.setProperty($.KEY_STRING, "pie");
        } else if ($.KEY_BOOLEAN == _count) {
            app.setProperty($.KEY_BOOLEAN, true);
        } else if ($.KEY_ARRAY == _count) {
            app.setProperty($.KEY_ARRAY, [1, 2, 3, null] as Array<Number?>);
        } else if ($.KEY_DICTIONARY == _count) {
            app.setProperty($.KEY_DICTIONARY, {1=>"one", "two"=>2, "null"=>null} as Dictionary<Number or String, Number or String or Null>);
        } else {
            app.deleteProperty(_count - $.KEY_COUNT);
        }

        _count++;

        if (_count == (2 * $.KEY_COUNT)) {
            _count = 0;
        }

        app.setProperty("count", _count);

        WatchUi.requestUpdate();
        return true;
    }

    //! Handle the touch screen hold event
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onHold(evt as ClickEvent?) as Boolean {
        Application.getApp().clearProperties();
        _count = 0;
        WatchUi.requestUpdate();
        return true;
    }

}
