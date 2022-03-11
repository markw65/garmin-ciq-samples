//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Show line graphs for the hemoglobin concentration
class GraphView extends WatchUi.View {
    private var _index as Number;
    private var _indicator as PageIndicator;
    private var _sensor as MO2Sensor;
    private var _fonts as Array<FontDefinition>;
    private var _totalGraph as LineGraph;
    private var _currentGraph as LineGraph;

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
        _indicator = new $.PageIndicator(
            size,
            selected,
            notSelected,
            alignment,
            0
        );

        _totalGraph = new $.LineGraph(30, 10, Graphics.COLOR_RED);
        _currentGraph = new $.LineGraph(30, 1, Graphics.COLOR_BLUE);
        _fonts = [
            Graphics.FONT_SMALL,
            Graphics.FONT_MEDIUM,
            Graphics.FONT_LARGE,
        ] as Array<FontDefinition>;
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        _totalGraph.addItem(
            _sensor.getData().getTotalHemoConcentration().toFloat()
        );
        _currentGraph.addItem(
            _sensor.getData().getCurrentHemoPercent().toFloat()
        );

        if (_sensor.getData().getTotalHemoConcentration() != null) {
            var totalString = _sensor
                .getData()
                .getTotalHemoConcentration()
                .format("%0.2f");
            var font = pickFont(dc, totalString, width / 4);
            var fWidth = dc.getTextWidthInPixels(totalString, font);

            // Draw HR value with drop shadow
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                width / 2 + 1,
                height / 2 - 4 + 1,
                font,
                totalString,
                Graphics.TEXT_JUSTIFY_CENTER
            );
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                width / 2,
                height / 2 - 4,
                font,
                totalString,
                Graphics.TEXT_JUSTIFY_CENTER
            );
            var numberXPos = width / 2 + 1 + fWidth / 2;

            totalString = "Total";
            font = pickFont(dc, totalString, width / 5);
            // Draw with drop shadow
            dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                width / 2 + 1,
                height / 3 + 1,
                font,
                totalString,
                Graphics.TEXT_JUSTIFY_CENTER
            );
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                width / 2,
                height / 3,
                font,
                totalString,
                Graphics.TEXT_JUSTIFY_CENTER
            );

            // Use smallest font for "g / dl"
            font = _fonts[0];
            totalString = "g / dl";
            // Draw with drop shadow
            dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                numberXPos + 2 + 1,
                height / 2 - 4 + 1,
                font,
                totalString,
                Graphics.TEXT_JUSTIFY_LEFT
            );
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                numberXPos + 2,
                height / 2 - 4,
                font,
                totalString,
                Graphics.TEXT_JUSTIFY_LEFT
            );

            // We should have thick lines eventually... this is a hack for now.
            _totalGraph.draw(
                dc,
                [width / 4 + 2, 3] as Array<Number>,
                [width - 3, height / 2 - 3] as Array<Number>
            );
            _totalGraph.draw(
                dc,
                [width / 4 + 2 + 1, 3] as Array<Number>,
                [width - 3 + 1, height / 2 - 3] as Array<Number>
            );
            _totalGraph.draw(
                dc,
                [width / 4 + 2, 3 + 1] as Array<Number>,
                [width - 3, height / 2 - 3 + 1] as Array<Number>
            );
            _totalGraph.draw(
                dc,
                [width / 4 + 2 + 1, 3 + 1] as Array<Number>,
                [width - 3 + 1, height / 2 - 3 + 1] as Array<Number>
            );
        }

        if (_sensor.getData().getCurrentHemoPercent() != null) {
            var currentString = _sensor
                .getData()
                .getCurrentHemoPercent()
                .format("%0.1f");
            var font = pickFont(dc, currentString, width / 4);
            var fWidth = dc.getTextWidthInPixels(currentString, font);
            var numberFHeight = dc.getFontHeight(font);
            var numberYPos = height - numberFHeight + 1;

            // Draw sensor.data.currentHemoPercent value with drop shadow
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                width / 2 + 1,
                numberYPos,
                font,
                currentString,
                Graphics.TEXT_JUSTIFY_CENTER
            );
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                width / 2,
                numberYPos - 1,
                font,
                currentString,
                Graphics.TEXT_JUSTIFY_CENTER
            );
            var numberXPos = width / 2 + 1 + fWidth / 2;

            currentString = "Current";
            font = pickFont(dc, currentString, width / 5);
            var fHeight = dc.getFontHeight(font);

            // Draw with drop shadow
            dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                width / 2 + 1,
                height - (fHeight + (numberFHeight - 1)) + 1,
                font,
                currentString,
                Graphics.TEXT_JUSTIFY_CENTER
            );
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                width / 2,
                height - (fHeight + (numberFHeight - 1)),
                font,
                currentString,
                Graphics.TEXT_JUSTIFY_CENTER
            );

            // Use smallest font for "percent"
            font = _fonts[0];
            currentString = "%";
            fHeight = dc.getFontHeight(font);

            // Draw with drop shadow
            dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                numberXPos + 2 + 1,
                numberYPos,
                font,
                currentString,
                Graphics.TEXT_JUSTIFY_LEFT
            );
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                numberXPos + 2,
                numberYPos - 1,
                font,
                currentString,
                Graphics.TEXT_JUSTIFY_LEFT
            );

            // We should have thick lines eventually... this is a hack for now.
            _currentGraph.draw(
                dc,
                [width / 4 + 2, height / 2] as Array<Number>,
                [width - 3, height - 3] as Array<Number>
            );
            _currentGraph.draw(
                dc,
                [width / 4 + 2 + 1, height / 2] as Array<Number>,
                [width - 3 + 1, height - 3] as Array<Number>
            );
            _currentGraph.draw(
                dc,
                [width / 4 + 2, height / 2 + 1] as Array<Number>,
                [width - 3, height - 3 + 1] as Array<Number>
            );
            _currentGraph.draw(
                dc,
                [width / 4 + 2 + 1, height / 2 + 1] as Array<Number>,
                [width - 3 + 1, height - 3 + 1] as Array<Number>
            );
        }

        // Draw the page indicator
        _indicator.draw(dc, _index);
    }

    //! Get the font that will fit the given string in the given width
    //! @param dc Device context
    //! @param string String that will use the font
    //! @param width Width to fit the string inside
    //! @return Font to use
    private function pickFont(
        dc as Dc,
        string as String,
        width as Number
    ) as FontDefinition {
        var i = _fonts.size() - 1;

        while (i > 0) {
            if (dc.getTextWidthInPixels(string, _fonts[i]) <= width) {
                return _fonts[i];
            }
            i--;
        }

        return _fonts[0];
    }
}
