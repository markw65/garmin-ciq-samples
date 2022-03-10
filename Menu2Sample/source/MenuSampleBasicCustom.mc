//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Create the Basic Drawables custom menu
function pushBasicCustom() as Void {
    var customMenu = new WatchUi.CustomMenu(35, Graphics.COLOR_WHITE, {
        :focusItemHeight=>45,
        :foreground=>new $.Rez.Drawables.MenuForeground(),
        :title=>new $.DrawableMenuTitle(),
        :footer=>new $.DrawableMenuFooter()
    });
    customMenu.addItem(new $.CustomItem(:item1, "Hello World"));
    customMenu.addItem(new $.CustomItem(:item2, "Foo"));
    customMenu.addItem(new $.CustomItem(:item3, "Bar"));
    customMenu.addItem(new $.CustomItem(:item4, "Run"));
    customMenu.addItem(new $.CustomItem(:item5, "Walk"));
    customMenu.addItem(new $.CustomItem(:item6, "Eat"));
    customMenu.addItem(new $.CustomItem(:item7, "Climb"));
    WatchUi.pushView(customMenu, new $.BasicCustomDelegate(), WatchUi.SLIDE_UP);
}

//! View to show when an item is selected
class ItemView extends WatchUi.View {

    private var _text as Text;

    //! Constructor
    //! @param text The item text
    public function initialize(text as String) {
        View.initialize();
        _text = new WatchUi.Text({:text => text,
            :color => Graphics.COLOR_BLACK,
            :backgroundColor => Graphics.COLOR_WHITE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_CENTER
        });
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
        _text.draw(dc);
    }
}

//! This is the menu input delegate for the Basic Drawables menu
class BasicCustomDelegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as CustomItem) as Void {
        WatchUi.pushView(new $.ItemView(item.getLabel()), null, WatchUi.SLIDE_UP);
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
        // Don't allow wrapping
        return false;
    }
}

//! This is the custom item drawable.
//! It draws the label it is initialized with at the center of the region
class CustomItem extends WatchUi.CustomMenuItem {

    private var _label as String;

    //! Constructor
    //! @param id The identifier for this item
    //! @param text Text to display
    public function initialize(id as Symbol, text as String) {
        CustomMenuItem.initialize(id, {});
        _label = text;
    }

    //! Draw the item string at the center of the item.
    //! @param dc Device context
    public function draw(dc as Dc) as Void {
        var font = Graphics.FONT_SMALL;
        if (isFocused()) {
            font = Graphics.FONT_LARGE;
        }

        if (isSelected()) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
            dc.clear();
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, font, _label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.drawLine(0, 0, dc.getWidth(), 0);
        dc.drawLine(0, dc.getHeight() - 1, dc.getWidth(), dc.getHeight() - 1);
    }

    //! Get the item label
    //! @return The label
    public function getLabel() as String {
        return _label;
    }
}

//! This is the drawable for the custom menu footer
class DrawableMenuFooter extends WatchUi.Drawable {

    //! Constructor
    public function initialize() {
        Drawable.initialize({});
    }

    //! Draw bottom half of the last dividing line below the final item
    //! @param dc Device context
    public function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.drawLine(0, 0, dc.getWidth(), 0);
    }
}
