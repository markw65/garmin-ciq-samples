//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Main picker that shows all the other pickers
class PickerChooser extends WatchUi.Picker {
    //! Constructor
    public function initialize() {
        var title = new WatchUi.Text({
            :text => $.Rez.Strings.pickerChooserTitle,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_BOTTOM,
            :color => Graphics.COLOR_WHITE,
        });
        var factory = new $.WordFactory(
            [
                $.Rez.Strings.pickerChooserColor,
                $.Rez.Strings.pickerChooserDate,
                $.Rez.Strings.pickerChooserString,
                $.Rez.Strings.pickerChooserTime,
                $.Rez.Strings.pickerChooserLayout,
            ] as Array<Symbol>,
            { :font => Graphics.FONT_MEDIUM }
        );
        Picker.initialize({ :title => title, :pattern => [factory] });
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

//! Responds to a picker selection or cancellation
class PickerChooserDelegate extends WatchUi.PickerDelegate {
    //! Constructor
    public function initialize() {
        PickerDelegate.initialize();
    }

    //! Handle a cancel event from the picker
    //! @return true if handled, false otherwise
    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! When a user selects a picker, start that picker
    //! @param values The values chosen in the picker
    //! @return true if handled, false otherwise
    public function onAccept(values as Array) as Boolean {
        if (values[0] == $.Rez.Strings.pickerChooserColor) {
            WatchUi.pushView(
                new $.ColorPicker(),
                new $.ColorPickerDelegate(),
                WatchUi.SLIDE_IMMEDIATE
            );
        } else if (values[0] == $.Rez.Strings.pickerChooserDate) {
            WatchUi.pushView(
                new $.DatePicker(),
                new $.DatePickerDelegate(),
                WatchUi.SLIDE_IMMEDIATE
            );
        } else if (values[0] == $.Rez.Strings.pickerChooserString) {
            var picker = new $.StringPicker();
            WatchUi.pushView(
                picker,
                new $.StringPickerDelegate(picker),
                WatchUi.SLIDE_IMMEDIATE
            );
        } else if (values[0] == $.Rez.Strings.pickerChooserTime) {
            WatchUi.pushView(
                new $.TimePicker(),
                new $.TimePickerDelegate(),
                WatchUi.SLIDE_IMMEDIATE
            );
        } else if (values[0] == $.Rez.Strings.pickerChooserLayout) {
            WatchUi.pushView(
                new $.LayoutPicker(),
                new $.LayoutPickerDelegate(),
                WatchUi.SLIDE_IMMEDIATE
            );
        }
        return true;
    }
}
