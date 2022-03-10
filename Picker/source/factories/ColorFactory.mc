//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Factory that controls which colors can be picked
class ColorFactory extends WatchUi.PickerFactory {
    private var _colorWheel as ColorWheel;

    //! Constructor
    //! @param colors Colors to display in the Color Wheel
    public function initialize(colors as Array<ColorType>) {
        PickerFactory.initialize();
        _colorWheel = new $.ColorWheel(colors);
    }

    //! Get the index of a color item
    //! @param value The color to get the index of
    //! @return The index of the color
    public function getIndex(value as ColorType) as Number {
        return _colorWheel.getColorIndex(value);
    }

    //! Get the number of picker items
    //! @return Number of items
    public function getSize() as Number {
        return _colorWheel.getNumberOfColors();
    }

    //! Get the value of the item at the given index
    //! @param index Index of the item to get the value of
    //! @return Value of the item
    public function getValue(index as Number) as Object? {
        return _colorWheel.getColor(index);
    }

    //! Generate a Drawable instance for an item
    //! @param index The item index
    //! @param selected true if the current item is selected, false otherwise
    //! @return Drawable for the item
    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        _colorWheel.setColor(index);
        return _colorWheel;
    }
}
