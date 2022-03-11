//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Picker that allows the user to choose a string
class StringPicker extends WatchUi.Picker {
    private const _characterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private var _curString as String;
    private var _title as Text;
    private var _factory as CharacterFactory;

    //! Constructor
    public function initialize() {
        _factory = new $.CharacterFactory(_characterSet, true);
        _curString = "";

        var lastString = Storage.getValue("string");
        var defaults = null;
        var titleText = $.Rez.Strings.stringPickerTitle;

        if (lastString instanceof String) {
            _curString = lastString;
            titleText = lastString;
            var startValue = lastString.substring(
                lastString.length() - 1,
                lastString.length()
            );
            if (startValue != null) {
                defaults = [_factory.getIndex(startValue)];
            }
        }

        _title = new WatchUi.Text({
            :text => titleText,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_BOTTOM,
            :color => Graphics.COLOR_WHITE,
        });

        Picker.initialize({
            :title => _title,
            :pattern => [_factory],
            :defaults => defaults,
        });
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }

    //! Add a character to the end of the title
    //! @param character Character to add
    public function addCharacter(character as String) as Void {
        _curString += character;
        _title.setText(_curString);
    }

    //! Remove the last character from the title
    public function removeCharacter() as Void {
        _curString = _curString.substring(0, _curString.length() - 1) as String;

        if (0 == _curString.length()) {
            _title.setText(
                WatchUi.loadResource($.Rez.Strings.stringPickerTitle) as String
            );
        } else {
            _title.setText(_curString);
        }
    }

    //! Get the title
    //! @return Title string
    public function getTitle() as String {
        return _curString;
    }

    //! Get how long the title is
    //! @return Length of title
    public function getTitleLength() as Number {
        return _curString.length();
    }

    //! Get whether the user is done picking
    //! @param value Value user selected
    //! @return true if user is done, false otherwise
    public function isDone(value as String or Number) as Boolean {
        return _factory.isDone(value);
    }
}

//! Responds to a string picker selection or cancellation
class StringPickerDelegate extends WatchUi.PickerDelegate {
    private var _picker as StringPicker;

    //! Constructor
    public function initialize(picker as StringPicker) {
        PickerDelegate.initialize();
        _picker = picker;
    }

    //! Handle a cancel event from the picker
    //! @return true if handled, false otherwise
    public function onCancel() as Boolean {
        if (0 == _picker.getTitleLength()) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        } else {
            _picker.removeCharacter();
        }
        return true;
    }

    //! Handle a confirm event from the picker
    //! @param values The values chosen in the picker
    //! @return true if handled, false otherwise
    public function onAccept(values as Array<String>) as Boolean {
        if (!_picker.isDone(values[0])) {
            _picker.addCharacter(values[0]);
        } else {
            if (_picker.getTitle().length() == 0) {
                Storage.deleteValue("string");
            } else {
                Storage.setValue("string", _picker.getTitle());
            }
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        return true;
    }
}
