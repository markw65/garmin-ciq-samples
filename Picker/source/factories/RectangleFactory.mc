//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Factory for creating rectangles
class RectangleFactory extends WatchUi.PickerFactory {

    private var _color as ColorType;

    //! Constructor
    //! @param color Color for the rectangle
    public function initialize(color as ColorType) {
        PickerFactory.initialize();
        _color = color;
    }

    //! Get the number of picker items
    //! @return Number of items
    public function getSize() as Number {
        return 1;
    }

    //! Get the value of the item at the given index
    //! @param index Index of the item to get the value of
    //! @return Value of the item
    public function getValue(index as Number) as Object? {
        return 0;
    }

    //! Generate a Drawable instance for an item
    //! @param index The item index
    //! @param selected true if the current item is selected, false otherwise
    //! @return Drawable for the item
    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new $.Rectangle(_color);
    }
}
