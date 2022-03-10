//
// Copyright 2015-2021 by Gar_in Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Show whether the app is currently tracking or searching
class MainView extends WatchUi.View {
    private var _icon as BitmapResource;
    private var _index as Number;
    private var _indicator as PageIndicator;
    private var _sensor as MO2Sensor;
    private var _iconY as Number;

    //! Constructor
    //! @param sensor ANT channel and data
    //! @param index Index corresponding to this view
    public function initialize(sensor as MO2Sensor, index as Number) {
        View.initialize();

        _sensor = sensor;
        _index = index;

        _icon = WatchUi.loadResource($.Rez.Drawables.id_mo2Icon) as BitmapResource;

        var size = 4;
        var selected = Graphics.COLOR_DK_GRAY;
        var notSelected = Graphics.COLOR_LT_GRAY;
        var alignment = $.ALIGN_BOTTOM_RIGHT;
        _indicator = new $.PageIndicator(size, selected, notSelected, alignment, 0);

        _iconY = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE ? 0 : 10;
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var margin = 20;
        var font = Graphics.FONT_SMALL;
        var textY = (_iconY + _icon.getHeight());
        // Show icon
        dc.drawBitmap((width / 2 - _icon.getWidth() / 2), _iconY, _icon);

        // Update status
        if (true == _sensor.isSearching()) {
            var status = "searching...";
            var fWidth = dc.getTextWidthInPixels(status, font);
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width / 2, textY, font, status, Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            var deviceNumber = _sensor.getDeviceConfig().deviceNumber;
            var status = "tracking - " + deviceNumber.toString();
            var fWidth = dc.getTextWidthInPixels(status, font);
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width / 2, textY, font, status, Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Draw page indicator
        _indicator.draw(dc, _index);
    }

}