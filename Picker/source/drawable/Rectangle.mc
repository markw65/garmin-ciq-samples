//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.WatchUi;

//! Draws a filled rectangle
class Rectangle extends WatchUi.Drawable {

    private var _color as ColorType;

    //! Constructor
    //! @param color Color of the rectangle
    public function initialize(color as ColorType) {
        Drawable.initialize({});
        _color = color;
    }

    //! Draw a rectangle
    //! @param dc Device context
    public function draw(dc as Dc) as Void {
        dc.setColor(_color, _color);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
    }
}
