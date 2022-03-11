//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class DeviceView extends WatchUi.View {
    private var _dataModel as DeviceDataModel;

    //! Constructor
    //! @param dataModel The data to show
    public function initialize(dataModel as DeviceDataModel) {
        View.initialize();

        _dataModel = dataModel;
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        var statusString;
        if (_dataModel.isConnected()) {
            statusString = "Connected";
        } else {
            statusString = "Disconnected";
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        dc.drawText(
            dc.getWidth() / 2,
            15,
            Graphics.FONT_SMALL,
            statusString,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        var profile = _dataModel.getActiveProfile();
        if (_dataModel.isConnected() && profile != null) {
            drawIndicator(
                dc,
                $.Rez.Drawables.TempInd,
                profile.getTemperature(),
                "%.2f",
                "°C",
                0
            );
            drawIndicator(
                dc,
                $.Rez.Drawables.PressureInd,
                profile.getPressure(),
                "%.2f",
                "hPa",
                1
            );
            drawIndicator(
                dc,
                $.Rez.Drawables.HumidityInd,
                profile.getHumidity(),
                "%d",
                "%",
                2
            );
            drawIndicator(
                dc,
                $.Rez.Drawables.Co2Ind,
                profile.getEco2(),
                "%d",
                "ppm",
                3
            );
            drawIndicator(
                dc,
                $.Rez.Drawables.LeafInd,
                profile.getTvoc(),
                "%d",
                "ppb",
                4
            );
        }
    }

    //! Draw the indicator with the given bitmap and text
    //! @param dc Device context
    //! @param bitmap Identifier for a bitmap
    //! @param value The value
    //! @param format Formatting string for the value
    //! @param units The units for the value
    //! @param cell Which cell to place the indicator in
    private function drawIndicator(
        dc as Dc,
        bitmap as Symbol,
        value as Numeric,
        format as String,
        units as String,
        cell as Number
    ) as Void {
        var gridOffset = dc.getFontHeight(Graphics.FONT_SMALL) + 15;
        var cellHeight = (dc.getHeight() - 2 * gridOffset) / 2;

        var cellWidth;
        var cellY;
        var cellXOffset;

        if (cell < 3) {
            cellWidth = dc.getWidth() / 3;
            cellY = gridOffset;
            cellXOffset = 0;
        } else {
            cell -= 3;
            cellXOffset = dc.getWidth() / 6;
            cellWidth = (dc.getWidth() - 2 * cellXOffset) / 2;
            cellY = gridOffset + cellHeight;
        }

        var cellX = cellXOffset + cellWidth * cell;

        var image = WatchUi.loadResource(bitmap) as BitmapType;
        var label = "";
        if (value != null) {
            label += value.format(format);
        }

        var centerCellX = cellX + cellWidth / 2;
        var imageOffset = centerCellX - image.getWidth() / 2;

        dc.drawBitmap(imageOffset, cellY, image);
        dc.drawText(
            centerCellX,
            cellY + image.getHeight() - 5,
            Graphics.FONT_SYSTEM_XTINY,
            label,
            Graphics.TEXT_JUSTIFY_CENTER
        );
        dc.drawText(
            centerCellX,
            cellY +
                image.getHeight() +
                dc.getFontHeight(Graphics.FONT_SYSTEM_XTINY) -
                8,
            Graphics.FONT_SYSTEM_XTINY,
            units,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}
