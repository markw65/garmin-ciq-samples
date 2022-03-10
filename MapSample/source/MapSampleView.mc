//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Initial view that shows the map menu
class MapSampleView extends WatchUi.View {

    private var _menuPushed as Boolean;
    private var _text as String = "Hello";

    //! Constructor
    public function initialize() {
        View.initialize();
        _menuPushed = false;
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
    }

    //! Show the menu when this View is brought to the foreground
    public function onShow() as Void {
        if (WatchUi has :MapView) {
            if (_menuPushed == false) {
                WatchUi.pushView(new $.Rez.Menus.MainMenu(), new $.MapSampleMenuDelegate(), WatchUi.SLIDE_UP);
                _menuPushed = true;
            } else {
                WatchUi.popView(WatchUi.SLIDE_UP);
            }
        } else {
            _text = "Cartography not \navailable on \ncurrent Device";
        }
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        // call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, _text, Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
    }

}
