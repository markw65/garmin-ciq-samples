//
// Copyright 2017-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

enum StorageKeys {
    KEY_INT,
    KEY_LONG,
    KEY_FLOAT,
    KEY_DOUBLE,
    KEY_STRING,
    KEY_BOOLEAN,
    KEY_ARRAY,
    KEY_DICTIONARY,
    KEY_COUNT
}

//! Show the current storage values
class ApplicationStorageView extends WatchUi.View {

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
        setLayout($.Rez.Layouts.StoreLayout(dc));
    }

    //! Get a string with the storage value and given prefix
    //! @param storagePrefix Label to prefix the storage value
    //! @param storageId The key for the storage item
    //! @return String with the storage prefix and value
    private function getDisplayString(storagePrefix as String, storageId as Number) as String {
        var value = Storage.getValue(storageId);
        if (value == null) {
            value = "Not set";
        }
        return storagePrefix + ": " + value.toString();
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

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        updateLabel("IntLabel", getDisplayString("Int", $.KEY_INT));
        updateLabel("LongLabel", getDisplayString("Long", $.KEY_LONG));
        updateLabel("FloatLabel", getDisplayString("Float", $.KEY_FLOAT));
        updateLabel("DoubleLabel", getDisplayString("Double", $.KEY_DOUBLE));
        updateLabel("StringLabel", getDisplayString("String", $.KEY_STRING));
        updateLabel("BoolLabel", getDisplayString("Boolean", $.KEY_BOOLEAN));
        updateLabel("ArrayLabel", getDisplayString("Array", $.KEY_ARRAY));
        updateLabel("DictLabel", getDisplayString("Dictionary", $.KEY_DICTIONARY));

        View.onUpdate(dc);

        _indicator.draw(dc, 0);
    }
}

//! Input handler for the storage view
class ApplicationStorageViewDelegate extends WatchUi.BehaviorDelegate {
    private var _count as Number;

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
        var count = Storage.getValue("count");
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

    //! Handle a key event
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

    //! On a screen tap event, set or delete the next storage item
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onTap(evt as ClickEvent?) as Boolean {
        switch (_count) {
            case $.KEY_INT:
                Storage.setValue(_count, 3);
                break;
            case $.KEY_LONG:
                Storage.setValue(_count, 4l);
                break;
            case $.KEY_FLOAT:
                Storage.setValue(_count, 3.14159);
                break;
            case $.KEY_DOUBLE:
                Storage.setValue(_count, 1.0d / 3);
                break;
            case $.KEY_STRING:
                Storage.setValue(_count, "pie");
                break;
            case $.KEY_BOOLEAN:
                Storage.setValue(_count, true);
                break;
            case $.KEY_ARRAY:
                Storage.setValue(_count, [1, 2, 3, null] as Array<Number?>);
                break;
            case $.KEY_DICTIONARY:
                Storage.setValue(_count, {1=>"one", "two"=>2, "null"=>null} as Dictionary<Number or String, Number or String or Null>);
                break;
            default:
                Storage.deleteValue(_count - $.KEY_COUNT);
        }

        _count++;

        if (_count == (2 * $.KEY_COUNT)) {
            _count = 0;
        }

        Storage.setValue("count", _count);

        WatchUi.requestUpdate();
        return true;
    }

    //! On a screen hold event, clear all values
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onHold(evt as ClickEvent?) as Boolean {
        Storage.clearValues();
        _count = 0;
        WatchUi.requestUpdate();
        return true;
    }

}
