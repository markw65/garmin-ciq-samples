//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Picker that allows the user to choose a date
class DatePicker extends WatchUi.Picker {

    //! Constructor
    public function initialize() {
        var months = [$.Rez.Strings.month01, $.Rez.Strings.month02, $.Rez.Strings.month03,
                      $.Rez.Strings.month04, $.Rez.Strings.month05, $.Rez.Strings.month06,
                      $.Rez.Strings.month07, $.Rez.Strings.month08, $.Rez.Strings.month09,
                      $.Rez.Strings.month10, $.Rez.Strings.month11, $.Rez.Strings.month12] as Array<Symbol>;
        var title = new WatchUi.Text({:text=>$.Rez.Strings.datePickerTitle, :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        var separator = new WatchUi.Text({:text=>$.Rez.Strings.dateSeparator, :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER, :color=>Graphics.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[new $.WordFactory(months, {}), separator, new $.NumberFactory(1, 31, 1, {}),
            separator, new $.NumberFactory(15, 18, 1, {:font=>Graphics.FONT_NUMBER_MEDIUM})]});
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

//! Responds to a date picker selection or cancellation
class DatePickerDelegate extends WatchUi.PickerDelegate {

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

    //! Handle a confirm event from the picker
    //! @param values The values chosen in the picker
    //! @return true if handled, false otherwise
    public function onAccept(values as Array<Number?>) as Boolean {
        var separator = WatchUi.loadResource($.Rez.Strings.dateSeparator) as String;
        var monthResource = values[0];
        if (monthResource != null) {
            var month = WatchUi.loadResource(monthResource as Symbol) as String;
            var day = values[2];
            var year = values[4];
            if ((day != null) && (year != null)) {
                var date = month + separator + day + separator + year;
                Storage.setValue("date", date);
            }
        }
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
