//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

// The object store properties shown here are deprecated in ConnectIQ 4.0.0.
// Use Application.Properties or Application.Storage instead.

import Toybox.Graphics;
import Toybox.Lang;

enum Align {
    ALIGN_BOTTOM_RIGHT,
    ALIGN_BOTTOM_LEFT,
    ALIGN_TOP_RIGHT,
    ALIGN_TOP_LEFT
}

//! Draws a graphic indicating which page the user is currently on
class PageIndicator {
    private var _size as Number;
    private var _selectedColor as ColorType;
    private var _notSelectedColor as ColorType;
    private var _alignment as Align;
    private var _margin as Number;

    //! Constructor
    //! @param size Number of pages
    //! @param selectedColor Color to use for the selected page
    //! @param notSelectedColor Color to use for non-selected pages
    //! @param alignment How to align the graphic
    //! @param margin Amount of margin for the graphic
    public function initialize(size as Number, selectedColor as ColorValue, notSelectedColor as ColorValue, alignment as Align, margin as Number) {
        _size = size;
        _selectedColor = selectedColor;
        _notSelectedColor = notSelectedColor;
        _alignment = alignment;
        _margin = margin;
    }

    //! Draw the graphic
    //! @param dc Device context
    //! @param selectedIndex The index of the current page
    public function draw(dc as Dc, selectedIndex as Number) as Void {
        var height = 10;
        var width = _size * height;
        var x = 0;
        var y = 0;

        if (_alignment == $.ALIGN_BOTTOM_RIGHT) {
            x = dc.getWidth() - width - _margin;
            y = dc.getHeight() - (height / 2) - _margin;
        } else if (_alignment == $.ALIGN_BOTTOM_LEFT) {
            x = 0 + _margin;
            y = dc.getHeight() - (height / 2) - _margin;
        } else if (_alignment == $. ALIGN_TOP_RIGHT) {
            x = dc.getWidth() - width - _margin;
            y = 0 + _margin + (height / 2);
        } else if (_alignment == $.ALIGN_TOP_LEFT) {
            x = 0 + _margin;
            y = 0 + _margin + (height / 2);
        } else {
            x = 0;
            y = 0;
        }

        for (var i = 0; i < _size; i++) {
            if (i == selectedIndex) {
                dc.setColor(_selectedColor, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(_notSelectedColor, Graphics.COLOR_TRANSPARENT);
            }

            var tempX = (x + (i * height)) + height / 2;
            dc.fillCircle(tempX, y, height / 2);
        }
    }

}
