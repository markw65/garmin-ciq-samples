//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.WatchUi;

//! Shows a fact about monkeys
class MonkeysView extends WatchUi.View {

    private var _color as ColorType;

    //! Constructor
    public function initialize() {
        View.initialize();
        _color = Graphics.COLOR_WHITE;
    }

    //! Update the view to display the fact
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);

        var x = dc.getWidth() / 2;
        var y = 20;

        dc.drawText(x, y, Graphics.FONT_MEDIUM, "Monkeys", Graphics.TEXT_JUSTIFY_CENTER);
        y += dc.getFontHeight(Graphics.FONT_MEDIUM);
        dc.drawText(x, y, Graphics.FONT_SMALL, "Monkeys are", Graphics.TEXT_JUSTIFY_CENTER);
        y += dc.getFontHeight(Graphics.FONT_SMALL);
        dc.drawText(x, y, Graphics.FONT_SMALL, "divided into two", Graphics.TEXT_JUSTIFY_CENTER);
        y += dc.getFontHeight(Graphics.FONT_SMALL);
        dc.drawText(x, y, Graphics.FONT_SMALL, "types: Old World", Graphics.TEXT_JUSTIFY_CENTER);
        y += dc.getFontHeight(Graphics.FONT_SMALL);
        dc.drawText(x, y, Graphics.FONT_SMALL, "and New World.", Graphics.TEXT_JUSTIFY_CENTER);
    }

}
