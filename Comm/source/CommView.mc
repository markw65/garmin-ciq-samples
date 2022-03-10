//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

// The Communications.setMailboxListener method has been
// deprecated in ConnectIQ 4.0.0 and replaced by
// Communications.registerForPhoneAppMessages.

import Toybox.Application;
import Toybox.Communications;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

enum Pages {
    PAGE_INTRO,
    PAGE_MESSAGES
}

//! Show the instructions or strings received
class CommView extends WatchUi.View {
    private var _screenShape as ScreenShape?;
    private var _hasDirectMessagingSupport as Boolean;
    private var _page as Pages = $.PAGE_INTRO;

    //! Constructor
    public function initialize() {
        View.initialize();
        _hasDirectMessagingSupport = (Communications has :setMailboxListener) || (Communications has :registerForPhoneAppMessages);
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        _screenShape = System.getDeviceSettings().screenShape;
    }

    //! Draw the intro page
    //! @param dc Device context
    public function drawIntroPage(dc as Dc) as Void {
        if (System.SCREEN_SHAPE_ROUND == _screenShape) {
            dc.drawText(dc.getWidth() / 2, 25,  Graphics.FONT_SMALL, "Communications", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 55,  Graphics.FONT_SMALL, "Test", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 80,  Graphics.FONT_TINY,  "Connect a phone then", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 100, Graphics.FONT_TINY,  "use the menu to send", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 120, Graphics.FONT_TINY,  "strings to your phone", Graphics.TEXT_JUSTIFY_CENTER);
        } else if (System.SCREEN_SHAPE_SEMI_ROUND == _screenShape) {
            dc.drawText(dc.getWidth() / 2, 20,  Graphics.FONT_MEDIUM, "Communications test", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 50,  Graphics.FONT_SMALL,  "Connect a phone", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 70,  Graphics.FONT_SMALL,  "Then use the menu to send", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 90,  Graphics.FONT_SMALL,  "strings to your phone", Graphics.TEXT_JUSTIFY_CENTER);
        } else if (dc.getWidth() > dc.getHeight()) {
            dc.drawText(10, 20,  Graphics.FONT_MEDIUM, "Communications test", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 50,  Graphics.FONT_SMALL,  "Connect a phone", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 70,  Graphics.FONT_SMALL,  "Then use the menu to send", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 90,  Graphics.FONT_SMALL,  "strings to your phone", Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            dc.drawText(10, 20,  Graphics.FONT_MEDIUM, "Communications test", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 40,  Graphics.FONT_MEDIUM, "Test", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 70,  Graphics.FONT_SMALL,  "Connect a phone", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 90,  Graphics.FONT_SMALL,  "Then use the menu", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 110, Graphics.FONT_SMALL,  "to send strings", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 130, Graphics.FONT_SMALL,  "to your phone", Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if (_hasDirectMessagingSupport) {
            if (_page == $.PAGE_INTRO) {
                drawIntroPage(dc);
            } else {
                var y = 50;
                var width = dc.getWidth();
                var strings = (Application.getApp() as CommExample).getStrings();

                dc.drawText(width / 2, 20,  Graphics.FONT_MEDIUM, "Strings Received:", Graphics.TEXT_JUSTIFY_CENTER);
                for (var i = 0; i < strings.size(); i++) {
                    dc.drawText(width / 2, y,  Graphics.FONT_SMALL, strings[i], Graphics.TEXT_JUSTIFY_CENTER);
                    y += 20;
                }
             }
         } else {
             dc.drawText(dc.getWidth() / 2, dc.getHeight() / 3, Graphics.FONT_MEDIUM, "Direct Messaging API\nNot Supported", Graphics.TEXT_JUSTIFY_CENTER);
         }
    }

    //! Change the current page
    //! @param page The page to show, or null to switch to other page
    public function changePage(page as Pages?) as Void {
        if (page != null) {
            _page = page;
        } else if (_page == $.PAGE_INTRO) {
            _page = $.PAGE_MESSAGES;
        } else {
            _page = $.PAGE_INTRO;
        }
    }
}