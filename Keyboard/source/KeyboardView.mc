//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Show the text the user picked
class KeyboardView extends WatchUi.View {

    private var _text as String = "Push Up\nor Tap\nTo Start";

    //! Constructor
    public function initialize() {
        WatchUi.View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        if (WatchUi has :TextPicker) {
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, _text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, "TextPicker not\nsupported", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }

    //! Set text to show
    //! @param text The text to show
    public function setText(text as String) as Void {
        _text = text;
    }
}