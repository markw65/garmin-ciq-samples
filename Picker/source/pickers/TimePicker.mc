//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

const FACTORY_COUNT_24_HOUR = 3;
const FACTORY_COUNT_12_HOUR = 4;
const MINUTE_FORMAT = "%02d";

//! Picker that allows the user to choose a time
class TimePicker extends WatchUi.Picker {

    //! Constructor
    public function initialize() {
        var title = new WatchUi.Text({:text=>$.Rez.Strings.timePickerTitle, :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        var factories;

        if (System.getDeviceSettings().is24Hour) {
            factories = new Array<PickerFactory or Text>[$.FACTORY_COUNT_24_HOUR];
            factories[0] = new $.NumberFactory(0, 23, 1, {});
        } else {
            factories = new Array<PickerFactory or Text>[$.FACTORY_COUNT_12_HOUR];
            factories[0] = new $.NumberFactory(1, 12, 1, {});
            factories[3] = new $.WordFactory([$.Rez.Strings.morning, $.Rez.Strings.afternoon] as Array<Symbol>, {});
        }

        factories[1] = new WatchUi.Text({:text=>$.Rez.Strings.timeSeparator, :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER, :color=>Graphics.COLOR_WHITE});
        factories[2] = new $.NumberFactory(0, 59, 1, {:format=>$.MINUTE_FORMAT});

        var time = splitStoredTime(factories.size());
        var defaults = new Array<Number>[factories.size()];
        if (time != null) {
            var hour = time[0].toNumber();
            if (hour != null) {
                defaults[0] = (factories[0] as NumberFactory).getIndex(hour);
            }

            var min = time[1].toNumber();
            if (min != null) {
                defaults[2] = (factories[2] as NumberFactory).getIndex(min);
            }

            if (defaults.size() == $.FACTORY_COUNT_12_HOUR) {
                defaults[3] = (factories[3] as WordFactory).getIndex(time[2]);
            }
        }

        Picker.initialize({:title=>title, :pattern=>factories, :defaults=>defaults});
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }

    //! Get the stored time in an array
    //! @param factoryCount Number of factories used to make the time
    //! @return Array with the stored time
    private function splitStoredTime(factoryCount as Number) as Array<String>? {
        var storedValue = Storage.getValue("time");
        var defaults = null;
        var separatorIndex = 0;

        if (storedValue instanceof String) {
            defaults = new Array<String>[factoryCount - 1];

            // Parse the stored time from the format HH:MIN AM|PM
            separatorIndex = storedValue.find(WatchUi.loadResource($.Rez.Strings.timeSeparator) as String);
            if (separatorIndex != null) {
                defaults[0] = storedValue.substring(0, separatorIndex);

                if (factoryCount == $.FACTORY_COUNT_24_HOUR) {
                    defaults[1] = storedValue.substring(separatorIndex + 1, storedValue.length());
                } else {
                    var spaceIndex = storedValue.find(" ");
                    if (spaceIndex != null) {
                        defaults[1] = storedValue.substring(separatorIndex + 1, spaceIndex);
                        defaults[2] = storedValue.substring(spaceIndex + 1, storedValue.length());
                    } else {
                        defaults = null;
                    }
                }
            } else {
                defaults = null;
            }
        }

        return defaults;
    }
}

//! Responds to a time picker selection or cancellation
class TimePickerDelegate extends WatchUi.PickerDelegate {

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
        var hour = values[0];
        var min = values[2];

        if ((hour != null) && (min != null)) {
            var time = hour + (WatchUi.loadResource($.Rez.Strings.timeSeparator) as String) + min.format($.MINUTE_FORMAT);

            if (values.size() == $.FACTORY_COUNT_12_HOUR) {
                var dayPart = values[3];
                if (dayPart != null) {
                    time += " " + WatchUi.loadResource(dayPart as Symbol);
                }
            }
            Storage.setValue("time", time);
        }

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
