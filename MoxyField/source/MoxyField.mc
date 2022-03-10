//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Activity;
import Toybox.Ant;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class MO2Field extends WatchUi.DataField {
    private const BORDER_PAD = 4;
    private const UNITS_SPACING = 2;

    private const _fonts as Array<FontDefinition> = [Graphics.FONT_XTINY, Graphics.FONT_TINY, Graphics.FONT_SMALL, Graphics.FONT_MEDIUM, Graphics.FONT_LARGE,
             Graphics.FONT_NUMBER_MILD, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_THAI_HOT] as Array<FontDefinition>;

    // Label Variables
    private const _labelString = "M02 Data";
    private const _labelFont = Graphics.FONT_SMALL;
    private const _labelY = 10;
    private var _labelX as Number = 0;

    // Hemoglobin Concentration variables
    private const _hCUnitsString = "g/dl";
    private var _hCUnitsWidth as Number?;
    private var _hCX as Number = 0;
    private var _hCY as Number = 0;

    // Hemoglobin Percentage variables
    private const _hPUnitsString = "%";
    private var _hPUnitsWidth as Number?;
    private var _hPX as Number = 0;
    private var _hPY as Number = 0;

    // Fit Contributor
    private var _fitContributor as MO2FitContributor;

    // Font values
    private const _unitsFont = Graphics.FONT_TINY;
    private var _dataFont as FontDefinition = Graphics.FONT_XTINY;
    private var _dataFontAscent as Number = 0;

    // field separator line
    private var _separator as Array<Number>?;

    private var _sensor as MO2Sensor?;
    private var _xCenter as Number = 0;
    private var _yCenter as Number = 0;

    //! Constructor
    //! @param sensor The ANT channel and data
    public function initialize(sensor as MO2Sensor?) {
        DataField.initialize();
        _sensor = sensor;
        _fitContributor = new MO2FitContributor(self);
    }

    //! Update fit contributor computations
    //! @param info The updated Activity.Info object
    public function compute(info as Info) as Void {
        _fitContributor.compute(_sensor);
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var top = _labelY + Graphics.getFontAscent(_labelFont) + BORDER_PAD;

        // Units width does not change, compute only once
        if (_hCUnitsWidth == null) {
            _hCUnitsWidth = dc.getTextWidthInPixels(_hCUnitsString, _unitsFont) + UNITS_SPACING;
        }
        var hCUnitsWidth = _hCUnitsWidth as Number;

        if (_hPUnitsWidth == null) {
            _hPUnitsWidth = dc.getTextWidthInPixels(_hPUnitsString, _unitsFont) + UNITS_SPACING;
        }
        var hPUnitsWidth = _hPUnitsWidth as Number;

        // Center the field label
        _labelX = width / 2;

        // Compute data width/height for both layouts
        var hLayoutWidth = (width - (4 * BORDER_PAD)) / 2;
        var hLayoutHeight = height - (2 * BORDER_PAD) - top;
        var hLayoutFontIdx = selectFont(dc, (hLayoutWidth - hCUnitsWidth), hLayoutHeight);

        var vLayoutWidth = width - (2 * BORDER_PAD);
        var vLayoutHeight = (height - top - (3 * BORDER_PAD)) / 2;
        var vLayoutFontIdx = selectFont(dc, (vLayoutWidth - hCUnitsWidth), vLayoutHeight);

        // Use the horizontal layout if it supports a larger font
        if (hLayoutFontIdx > vLayoutFontIdx) {
            _dataFont = _fonts[hLayoutFontIdx];
            _dataFontAscent = Graphics.getFontAscent(_dataFont);

            // Compute the draw location of the Hemoglobin Concentration data
            _hCX = BORDER_PAD + (hLayoutWidth / 2) - (hCUnitsWidth / 2);
            _hCY = (height - top) / 2 + top - (_dataFontAscent / 2);

            // Compute the center of the Hemo Percentage data
            _hPX = (2 * BORDER_PAD) + hLayoutWidth + (hLayoutWidth / 2) - (hPUnitsWidth / 2);
            _hPY = _hCY;

            // Use a separator line for horizontal layout
            _separator = [(width / 2), top + BORDER_PAD, (width / 2), height - BORDER_PAD] as Array<Number>;
        } else {
            // otherwise, use the vertical layout
            _dataFont = _fonts[vLayoutFontIdx];
            _dataFontAscent = Graphics.getFontAscent(_dataFont);

            _hCX = BORDER_PAD + (vLayoutWidth / 2) - (hCUnitsWidth / 2);
            _hCY = top + BORDER_PAD + (vLayoutHeight / 2) - (_dataFontAscent / 2);

            _hPX = BORDER_PAD + (vLayoutWidth / 2) - (hPUnitsWidth / 2);
            _hPY = _hCY + BORDER_PAD + vLayoutHeight;

            // Do not use a separator line for vertical layout
            _separator = null;
        }

        _xCenter = dc.getWidth() / 2;
        _yCenter = dc.getHeight() / 2;
    }

    //! Get the largest font that fits in the given width and height
    //! @param dc Device context
    //! @param width Width to fit in
    //! @param height Height to fit in
    //! @return Index of the font that fits
    private function selectFont(dc as Dc, width as Number, height as Number) as Number {
        var testString = "88.88"; // Dummy string to test data width
        var fontIdx;
        // Search through fonts from biggest to smallest
        for (fontIdx = (_fonts.size() - 1); fontIdx > 0; fontIdx--) {
            var dimensions = dc.getTextDimensions(testString, _fonts[fontIdx]);
            if ((dimensions[0] <= width) && (dimensions[1] <= height)) {
                // If this font fits, it is the biggest one that does
                break;
            }
        }

        return fontIdx;
    }

    //! Handle the update event
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        var bgColor = getBackgroundColor();
        var fgColor = Graphics.COLOR_WHITE;

        if (bgColor == Graphics.COLOR_WHITE) {
            fgColor = Graphics.COLOR_BLACK;
        }

        dc.setColor(fgColor, bgColor);
        dc.clear();

        dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT);

        // Draw the field label
        dc.drawText(_labelX, _labelY, _labelFont, _labelString, Graphics.TEXT_JUSTIFY_CENTER);

        // Update status
        var sensor = _sensor;
        if (sensor == null) {
            dc.drawText(_xCenter, _yCenter, Graphics.FONT_MEDIUM, "No Channel!", Graphics.TEXT_JUSTIFY_CENTER);
        } else if (sensor.isSearching()) {
            dc.drawText(_xCenter, _yCenter, Graphics.FONT_MEDIUM, "Searching...", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            var HemoConc = sensor.getData().getTotalHemoConcentration().format("%.2f");
            var HemoPerc = sensor.getData().getCurrentHemoPercent().format("%.1f");

            // Draw Hemoglobin Concentration
            dc.drawText(_hCX, _hCY, _dataFont, HemoConc, Graphics.TEXT_JUSTIFY_CENTER);
            var x = _hCX + (dc.getTextWidthInPixels(HemoConc, _dataFont) / 2) + UNITS_SPACING;
            var y = _hCY + _dataFontAscent - Graphics.getFontAscent(_unitsFont);
            dc.drawText(x, y, _unitsFont, _hCUnitsString, Graphics.TEXT_JUSTIFY_LEFT);

            // Draw Hemoglobin Percentage
            dc.drawText(_hPX, _hPY, _dataFont, HemoPerc, Graphics.TEXT_JUSTIFY_CENTER);
            x = _hPX + (dc.getTextWidthInPixels(HemoPerc, _dataFont) / 2) + UNITS_SPACING;
            y = _hPY + _dataFontAscent - Graphics.getFontAscent(_unitsFont);
            dc.drawText(x, y, _unitsFont, _hPUnitsString, Graphics.TEXT_JUSTIFY_LEFT);

            var separator = _separator;
            if (separator != null) {
                dc.setColor(fgColor, fgColor);
                dc.drawLine(separator[0], separator[1], separator[2], separator[3]);
            }
        }
    }

    //! Handle the activity timer starting
    public function onTimerStart() as Void {
        _fitContributor.setTimerRunning(true);
    }

    //! Handle the activity timer stopping
    public function onTimerStop() as Void {
        _fitContributor.setTimerRunning(false);
    }

    //! Handle an activity timer pause
    public function onTimerPause() as Void {
        _fitContributor.setTimerRunning(false);
    }

    //! Handle the activity timer resuming
    public function onTimerResume() as Void {
        _fitContributor.setTimerRunning(true);
    }

    //! Handle a lap event
    public function onTimerLap() as Void {
        _fitContributor.onTimerLap();
    }

    //! Handle the current activity ending
    public function onTimerReset() as Void {
        _fitContributor.onTimerReset();
    }

}

//! This app uses ANT to create a Moxy data field
class MoxyField extends Application.AppBase {
    private var _sensor as MO2Sensor?;

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
        try {
            // Create the sensor object and open it
            _sensor = new MO2Sensor();
            _sensor.open();
        } catch (e instanceof Ant.UnableToAcquireChannelException) {
            System.println(e.getErrorMessage());
            _sensor = null;
        }
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
        var sensor = _sensor;
        if (sensor != null) {
            sensor.closeSensor();
        }
    }

    //! Return the initial view for the app
    //! @return Array [View]
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [new $.MO2Field(_sensor)] as Array<Views>;
    }
}
