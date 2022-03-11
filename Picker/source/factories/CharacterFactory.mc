//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Factory that controls which characters can be picked
class CharacterFactory extends WatchUi.PickerFactory {
    private var _characterSet as String;
    private var _addOk as Boolean;
    private const DONE = -1;

    //! Constructor
    //! @param characterSet The characters to include in the Picker
    //! @param addOk true to add OK button, false otherwise
    public function initialize(characterSet as String, addOk as Boolean) {
        PickerFactory.initialize();
        _characterSet = characterSet;
        _addOk = addOk;
    }

    //! Get the index of a character item
    //! @param value The character to get the index of
    //! @return The index of the character
    public function getIndex(value as String) as Number {
        return _characterSet.find(value);
    }

    //! Get the number of picker items
    //! @return Number of items
    public function getSize() as Number {
        return _characterSet.length() + (_addOk ? 1 : 0);
    }

    //! Get the value of the item at the given index
    //! @param index Index of the item to get the value of
    //! @return Value of the item
    public function getValue(index as Number) as Object? {
        if (index == _characterSet.length()) {
            return DONE;
        }

        return _characterSet.substring(index, index + 1);
    }

    //! Generate a Drawable instance for an item
    //! @param index The item index
    //! @param selected true if the current item is selected, false otherwise
    //! @return Drawable for the item
    public function getDrawable(
        index as Number,
        selected as Boolean
    ) as Drawable? {
        if (index == _characterSet.length()) {
            return new WatchUi.Text({
                :text => $.Rez.Strings.characterPickerOk,
                :color => Graphics.COLOR_WHITE,
                :font => Graphics.FONT_LARGE,
                :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            });
        }

        return new WatchUi.Text({
            :text => getValue(index) as String,
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_LARGE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
        });
    }

    //! Get whether the user selected OK and is done picking
    //! @param value Value user selected
    //! @return true if user is done, false otherwise
    public function isDone(value as String or Number) as Boolean {
        return _addOk and value == DONE;
    }
}
