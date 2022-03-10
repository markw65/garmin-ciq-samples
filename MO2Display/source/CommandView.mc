//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! View to show UTC time information
class CommandView extends WatchUi.View {
    private var _index as Number;
    private var _indicator as PageIndicator;
    private var _sensor as MO2Sensor;

    //! Constructor
    //! @param sensor ANT channel and data
    //! @param index Index corresponding to this view
    public function initialize(sensor as MO2Sensor, index as Number) {
        View.initialize();

        _sensor = sensor;
        _index = index;

        var size = 4;
        var selected = Graphics.COLOR_DK_GRAY;
        var notSelected = Graphics.COLOR_LT_GRAY;
        var alignment = $.ALIGN_BOTTOM_RIGHT;
        _indicator = new $.PageIndicator(size, selected, notSelected, alignment, 0);
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var margin = 30;

        var text = "Notifications";
        var font = Graphics.FONT_LARGE;
        var fWidth = dc.getTextWidthInPixels(text, font);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2 - fWidth / 2, margin, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        text = "UTC Time";
        font = Graphics.FONT_MEDIUM;
        fWidth = dc.getTextWidthInPixels(text, font);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2 - fWidth / 2, height / 3 + margin, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        if (_sensor.getData().isUtcTimeSet()) {
            text = "Required";
            fWidth = dc.getTextWidthInPixels(text, font);
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width / 2 - fWidth / 2, height * 2 / 3, font, text, Graphics.TEXT_JUSTIFY_LEFT);

            text = "Tap to set";
            font = Graphics.FONT_SMALL;
            fWidth = dc.getTextWidthInPixels(text, font);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width / 2 - fWidth / 2, height * 2 / 3 + margin, font, text, Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            text = "Not Required";
            fWidth = dc.getTextWidthInPixels(text, font);
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width / 2 - fWidth / 2, height * 2 / 3, font, text, Graphics.TEXT_JUSTIFY_LEFT);
        }

        // Draw page indicator
        _indicator.draw(dc, _index);
    }

}