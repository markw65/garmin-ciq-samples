//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Show the strings for the current device and language
class StringView extends WatchUi.View {

    private var _common as String;
    private var _language as String;
    private var _greeting as String;
    private var _food as String;
    private var _drink as String;
    private var _commonLabel as String;
    private var _languageLabel as String;
    private var _greetingLabel as String;
    private var _foodLabel as String;
    private var _drinkLabel as String;

    private var _centerY as Number = 60; // Default taken from previous hard coded values

    private const FONT = Graphics.FONT_SMALL;
    private const LINE_SPACING = Graphics.getFontHeight(FONT);

    //! Constructor
    public function initialize() {
        View.initialize();
        _common = WatchUi.loadResource($.Rez.Strings.common) as String;
        _language = WatchUi.loadResource($.Rez.Strings.language) as String;
        _greeting = WatchUi.loadResource($.Rez.Strings.greeting) as String;
        _food = WatchUi.loadResource($.Rez.Strings.food) as String;
        _drink = WatchUi.loadResource($.Rez.Strings.drink) as String;
        _commonLabel = WatchUi.loadResource($.Rez.Strings.common_label) as String;
        _languageLabel = WatchUi.loadResource($.Rez.Strings.language_label) as String;
        _greetingLabel = WatchUi.loadResource($.Rez.Strings.greeting_label) as String;
        _foodLabel = WatchUi.loadResource($.Rez.Strings.food_label) as String;
        _drinkLabel = WatchUi.loadResource($.Rez.Strings.drink_label) as String;
    }

    //! Calculate the center y coordinate
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        _centerY = (dc.getHeight() / 2) - (LINE_SPACING / 2);
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawText(85, _centerY - (2 * LINE_SPACING), FONT, _commonLabel,   Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(85, _centerY - (1 * LINE_SPACING), FONT, _languageLabel, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(85, _centerY,                      FONT, _greetingLabel, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(85, _centerY + (1 * LINE_SPACING), FONT, _foodLabel,     Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(85, _centerY + (2 * LINE_SPACING), FONT, _drinkLabel,    Graphics.TEXT_JUSTIFY_RIGHT);

        dc.drawText(95, _centerY - (2 * LINE_SPACING), FONT, _common,   Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(95, _centerY - (1 * LINE_SPACING), FONT, _language, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(95, _centerY,                      FONT, _greeting, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(95, _centerY + (1 * LINE_SPACING), FONT, _food,     Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(95, _centerY + (2 * LINE_SPACING), FONT, _drink,    Graphics.TEXT_JUSTIFY_LEFT);
    }

}

//! This app demonstrates how to create and use string
//! resources that depend on the language and device.
class StringApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view for the app
    //! @return Array [View]
    public function getInitialView() as Array<Views or InputDelegates>? {
        return [new $.StringView()] as Array<Views>;
    }
}
