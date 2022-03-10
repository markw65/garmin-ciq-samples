//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Factory that controls which words can be picked
class WordFactory extends WatchUi.PickerFactory {
    private var _words as Array<Symbol>;
    private var _font as FontDefinition;

    //! Constructor
    //! @param words Resource identifiers for strings
    //! @param options Dictionary of options
    //! @option options :font The font to use
    public function initialize(words as Array<Symbol>, options as {:font as FontDefinition}) {
        PickerFactory.initialize();

        _words = words;

        var font = options.get(:font);
        if (font != null) {
            _font = font;
        } else {
            _font = Graphics.FONT_LARGE;
        }
    }

    //! Get the index of an item
    //! @param value The string or resource identifier to get the index of
    //! @return The index
    public function getIndex(value as String or Symbol) as Number {
        if (value instanceof String) {
            for (var i = 0; i < _words.size(); i++) {
                if (value.equals(WatchUi.loadResource(_words[i]))) {
                    return i;
                }
            }
        } else {
            for (var i = 0; i < _words.size(); i++) {
                if (_words[i].equals(value)) {
                    return i;
                }
            }
        }

        return 0;
    }

    //! Get the number of picker items
    //! @return Number of items
    public function getSize() as Number {
        return _words.size();
    }

    //! Get the value of the item at the given index
    //! @param index Index of the item to get the value of
    //! @return Value of the item
    public function getValue(index as Number) as Object? {
        return _words[index];
    }

    //! Generate a Drawable instance for an item
    //! @param index The item index
    //! @param selected true if the current item is selected, false otherwise
    //! @return Drawable for the item
    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({:text=>_words[index], :color=>Graphics.COLOR_WHITE, :font=>_font,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
    }
}
