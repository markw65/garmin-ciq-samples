//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Picker that allows the user to choose a color
class ColorPicker extends WatchUi.Picker {

    //! Constructor
    public function initialize() {
        var title = new WatchUi.Text({:text=>$.Rez.Strings.colorPickerTitle, :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        var factory = new $.ColorFactory([Graphics.COLOR_RED, Graphics.COLOR_GREEN, Graphics.COLOR_BLUE,
            Graphics.COLOR_ORANGE, Graphics.COLOR_YELLOW, Graphics.COLOR_PURPLE] as Array<ColorType>);
        var defaults = null;
        var value = Storage.getValue("color");
        if (value instanceof Number) {
            defaults = [factory.getIndex(value)];
        }

        var nextArrow = new WatchUi.Bitmap({:rezId=>$.Rez.Drawables.nextArrow, :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
        var previousArrow = new WatchUi.Bitmap({:rezId=>$.Rez.Drawables.previousArrow, :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
        var brush = new WatchUi.Bitmap({:rezId=>$.Rez.Drawables.brush, :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
        Picker.initialize({:title=>title, :pattern=>[factory], :defaults=>defaults, :nextArrow=>nextArrow, :previousArrow=>previousArrow, :confirm=>brush});
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

//! Responds to a color picker selection or cancellation
class ColorPickerDelegate extends WatchUi.PickerDelegate {

    //! Constructor
    public function initialize() {
        PickerDelegate.initialize();
    }

    //! Handle a cancel event
    //! @return true if handled, false otherwise
    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! Handle a confirm event
    //! @param values The values chosen
    //! @return true if handled, false otherwise
    public function onAccept(values as Array<Number>) as Boolean {
        Storage.setValue("color", values[0]);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
