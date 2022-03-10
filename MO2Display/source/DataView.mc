//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! View to display the data
class DataView extends WatchUi.View {

    private var _index as Number;
    private var _indicator as PageIndicator;
    private var _sensor as MO2Sensor;
    private var _headingFont as FontDefinition;
    private var _dataFont as FontDefinition;
    private var _unitFont as FontDefinition;

    //! Constructor
    //! @param sensor ANT channel and data
    //! @param index Index corresponding to this view
    public function initialize(sensor as MO2Sensor, index as Number) {
        View.initialize();

        _sensor = sensor;
        _index = index;

        _headingFont = Graphics.FONT_SMALL;
        _dataFont = Graphics.FONT_LARGE;
        _unitFont = Graphics.FONT_TINY;

        var size = 4;
        var selected = Graphics.COLOR_DK_GRAY;
        var notSelected = Graphics.COLOR_LT_GRAY;
        var alignment = $.ALIGN_BOTTOM_RIGHT;
        _indicator = new $.PageIndicator(size, selected, notSelected, alignment, 0);
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var marginTop = 5;
        var marginMid = height / 2 - 5;
        var marginLeft = 3;

        // Update total
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var font = _headingFont;
        var text = "Total";
        var fWidth = dc.getTextWidthInPixels(text, font);
        dc.drawText(width / 4 - fWidth / 2, marginTop, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        font = _dataFont;
        text = _sensor.getData().getTotalHemoConcentration().format("%.2f");
        fWidth = dc.getTextWidthInPixels(text, font);
        dc.drawText(width / 4 - fWidth / 2, marginTop + height / 6, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        font = _unitFont;
        text = "g/dl";
        dc.drawText(width / 4 + fWidth / 2 + marginLeft, marginTop + height / 6, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        // Update events
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        text = "Events";
        fWidth = dc.getTextWidthInPixels(text, font);
        dc.drawText((width * 3 / 4) - fWidth / 2, marginTop, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        font = _dataFont;
        text = _sensor.getData().getEventCount().format("%i");
        fWidth = dc.getTextWidthInPixels(text, font);
        dc.drawText((width * 3 / 4) - fWidth / 2, marginTop + height / 6, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        // Update current
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        font = _headingFont;
        text = "Current";
        fWidth = dc.getTextWidthInPixels(text, font);
        dc.drawText(width / 4 - fWidth / 2, marginMid, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        font = _dataFont;
        text = _sensor.getData().getCurrentHemoPercent().format("%.1f");
        fWidth = dc.getTextWidthInPixels(text, font);
        dc.drawText(width / 4 - fWidth / 2, marginMid + height / 6, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        font = _unitFont;
        text = "%";
        dc.drawText(width / 4 + fWidth / 2 + marginLeft, marginMid + height / 6, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        // Update Previous
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        font = _headingFont;
        text = "Previous";
        fWidth = dc.getTextWidthInPixels(text, font);
        dc.drawText((width * 3 / 4) - fWidth / 2, marginMid, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        font = _dataFont;
        text = _sensor.getData().getPreviousHemoPercent().format("%.1f");
        fWidth = dc.getTextWidthInPixels(text, font);
        dc.drawText((width * 3 / 4) - fWidth / 2, marginMid + height / 6, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        font = _unitFont;
        text = "%";
        dc.drawText((width * 3 / 4) + fWidth / 2 + marginLeft, marginMid + height / 6, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        // Draw the page indicator
        _indicator.draw(dc, _index);
    }

}