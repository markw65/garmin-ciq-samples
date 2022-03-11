//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Create the top menu of the Wrap custom menu
function pushWrapCustom() as Void {
    var customMenu = new $.WrapTopMenu(80, Graphics.COLOR_BLACK);
    customMenu.addItem(
        new $.CustomWrapItem(:item1, "Item 1", Graphics.COLOR_WHITE)
    );
    customMenu.addItem(
        new $.CustomWrapItem(:item2, "Item 2", Graphics.COLOR_WHITE)
    );
    customMenu.addItem(
        new $.CustomWrapItem(:item3, "Item 3", Graphics.COLOR_WHITE)
    );
    WatchUi.pushView(
        customMenu,
        new $.WrapTopCustomDelegate(),
        WatchUi.SLIDE_LEFT
    );
}

//! Create the sub-menu menu of the Wrap custom menu
function pushWrapCustomBottom() as Void {
    var customMenu = new $.WrapBottomMenu(80, Graphics.COLOR_WHITE);
    customMenu.addItem(
        new $.CustomWrapItem(:item1, "Item 1", Graphics.COLOR_BLACK)
    );
    customMenu.addItem(
        new $.CustomWrapItem(:item2, "Item 2", Graphics.COLOR_BLACK)
    );
    customMenu.addItem(
        new $.CustomWrapItem(:item3, "Item 3", Graphics.COLOR_BLACK)
    );
    WatchUi.pushView(
        customMenu,
        new $.WrapBottomCustomDelegate(),
        WatchUi.SLIDE_UP
    );
}

//! This is the top menu in the Wrap custom menu
class WrapTopMenu extends WatchUi.CustomMenu {
    //! Constructor
    //! @param itemHeight The pixel height of menu items rendered by this menu
    //! @param backgroundColor The color for the menu background
    public function initialize(
        itemHeight as Number,
        backgroundColor as ColorType
    ) {
        CustomMenu.initialize(itemHeight, backgroundColor, {});
    }

    //! Draw the menu title
    //! @param dc Device Context
    public function drawTitle(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.setPenWidth(3);
        dc.drawLine(0, dc.getHeight() - 2, dc.getWidth(), dc.getHeight() - 2);
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_MEDIUM,
            "Top\nMenu",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    //! Draw the menu footer
    //! @param dc Device Context
    public function drawFooter(dc as Dc) as Void {
        var height = dc.getHeight();
        var centerX = dc.getWidth() / 2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.setPenWidth(3);
        dc.drawLine(0, 1, dc.getWidth(), 1);
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 3,
            Graphics.FONT_MEDIUM,
            "To Sub Menu",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillPolygon(
            [
                [centerX, height - 10] as Array<Number>,
                [centerX + 5, height - 15] as Array<Number>,
                [centerX - 5, height - 15] as Array<Number>,
            ] as Array<Array<Number> >
        );
    }
}

//! This is the sub-menu in the Wrap custom menu
class WrapBottomMenu extends WatchUi.CustomMenu {
    //! Constructor
    //! @param itemHeight The pixel height of menu items rendered by this menu
    //! @param backgroundColor The color for the menu background
    public function initialize(
        itemHeight as Number,
        backgroundColor as ColorType
    ) {
        CustomMenu.initialize(itemHeight, backgroundColor, {});
    }

    //! Draw the menu title
    //! @param dc Device Context
    public function drawTitle(dc as Dc) as Void {
        var centerX = dc.getWidth() / 2;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.setPenWidth(3);
        dc.drawLine(0, dc.getHeight() - 2, dc.getWidth(), dc.getHeight() - 2);
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            (dc.getHeight() / 3) * 2,
            Graphics.FONT_MEDIUM,
            "Back to Top",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillPolygon(
            [
                [centerX, 10] as Array<Number>,
                [centerX + 5, 15] as Array<Number>,
                [centerX - 5, 15] as Array<Number>,
            ] as Array<Array<Number> >
        );
    }
}

//! This is the menu input delegate for the Wrap top menu
class WrapTopCustomDelegate extends WatchUi.Menu2InputDelegate {
    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        WatchUi.requestUpdate();
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the user navigating off the end of the menu
    //! @param key The key triggering the menu wrap
    //! @return true if wrap is allowed, false otherwise
    public function onWrap(key as Key) as Boolean {
        if (key == WatchUi.KEY_DOWN) {
            $.pushWrapCustomBottom();
        }
        return false;
    }

    //! Handle the footer being selected
    public function onFooter() as Void {
        $.pushWrapCustomBottom();
    }
}

//! This is the menu input delegate for the Wrap bottom menu
class WrapBottomCustomDelegate extends WatchUi.Menu2InputDelegate {
    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        WatchUi.requestUpdate();
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    //! Handle the user navigating off the end of the menu
    //! @param key The key triggering the menu wrap
    //! @return true if wrap is allowed, false otherwise
    public function onWrap(key as Key) as Boolean {
        if (key == WatchUi.KEY_UP) {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        return false;
    }

    //! Handle the title being selected
    public function onTitle() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//! This is the custom item drawable.
//! It draws the label it is initialized with at the center of the region
class CustomWrapItem extends WatchUi.CustomMenuItem {
    private var _label as String;
    private var _textColor as ColorValue;

    //! Constructor
    //! @param id The identifier for this item
    //! @param label Text to display
    //! @param textColor Color of the text
    public function initialize(
        id as Symbol,
        label as String,
        textColor as ColorValue
    ) {
        CustomMenuItem.initialize(id, {});
        _label = label;
        _textColor = textColor;
    }

    //! Draw the item string at the center of the item.
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var font = Graphics.FONT_SMALL;
        if (isFocused()) {
            font = Graphics.FONT_LARGE;
        }

        if (isSelected()) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
            dc.clear();
        }

        dc.setColor(_textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            font,
            _label,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
