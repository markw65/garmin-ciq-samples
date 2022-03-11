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
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Handles the completion of communication operations
class CommListener extends Communications.ConnectionListener {
    //! Constructor
    public function initialize() {
        Communications.ConnectionListener.initialize();
    }

    //! Handle a communications operation completing
    public function onComplete() as Void {
        System.println("Transmit Complete");
    }

    //! Handle a communications operation erroring
    public function onError() as Void {
        System.println("Transmit Failed");
    }
}

//! Input handler for the communications view
class CommInputDelegate extends WatchUi.BehaviorDelegate {
    private var _view as CommView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as CommView) {
        WatchUi.BehaviorDelegate.initialize();
        _view = view;
    }

    //! Handle the menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        var menu = new WatchUi.Menu();

        menu.addItem("Send Data", :sendData);
        menu.addItem("Set Listener", :setListener);
        var delegate = new $.BaseMenuDelegate();
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);

        return true;
    }

    //! Handle a screen tap event
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onTap(evt as ClickEvent) as Boolean {
        _view.changePage(null);
        WatchUi.requestUpdate();
        return true;
    }
}

//! Handle menu selections for the main menu
class BaseMenuDelegate extends WatchUi.MenuInputDelegate {
    //! Constructor
    public function initialize() {
        WatchUi.MenuInputDelegate.initialize();
    }

    //! Handle a menu item being chosen
    //! @param item The identifier of the chosen item
    public function onMenuItem(item as Symbol) as Void {
        var menu = new WatchUi.Menu();
        var delegate = null;

        if (item == :sendData) {
            menu.addItem("Hello World.", :hello);
            menu.addItem("Ackbar", :trap);
            menu.addItem("Garmin", :garmin);
            delegate = new $.SendMenuDelegate();
        } else if (item == :setListener) {
            menu.setTitle("Listener Type");
            menu.addItem("Mailbox", :mailbox);
            if (Communications has :registerForPhoneAppMessages) {
                menu.addItem("Phone Application", :phone);
            }
            menu.addItem("None", :none);
            menu.addItem("Crash if 'Hi'", :phoneFail);
            delegate = new $.ListenerMenuDelegate();
        }

        WatchUi.pushView(menu, delegate, SLIDE_IMMEDIATE);
    }
}

//! Handle menu selections for the send menu
class SendMenuDelegate extends WatchUi.MenuInputDelegate {
    //! Constructor
    public function initialize() {
        WatchUi.MenuInputDelegate.initialize();
    }

    //! Handle a menu item being chosen
    //! @param item The identifier of the chosen item
    public function onMenuItem(item as Symbol) as Void {
        var listener = new $.CommListener();

        if (item == :hello) {
            Communications.transmit("Hello World.", null, listener);
        } else if (item == :trap) {
            Communications.transmit("IT'S A TRAP!", null, listener);
        } else if (item == :garmin) {
            Communications.transmit("ConnectIQ", null, listener);
        }

        WatchUi.popView(SLIDE_IMMEDIATE);
    }
}

//! Handle menu selections for the listener menu
class ListenerMenuDelegate extends WatchUi.MenuInputDelegate {
    //! Constructor
    public function initialize() {
        WatchUi.MenuInputDelegate.initialize();
    }

    //! Handle a menu item being chosen
    //! @param item The identifier of the chosen item
    public function onMenuItem(item as Symbol) as Void {
        var app = Application.getApp() as CommExample;
        if (item == :mailbox) {
            Communications.setMailboxListener(app.getMailMethod());
        } else if (item == :phone) {
            if (Communications has :registerForPhoneAppMessages) {
                Communications.registerForPhoneAppMessages(
                    app.getPhoneMethod()
                );
            }
        } else if (item == :none) {
            Communications.registerForPhoneAppMessages(null);
            Communications.setMailboxListener(null);
        } else if (item == :phoneFail) {
            app.crashOnMessage();
            Communications.registerForPhoneAppMessages(app.getPhoneMethod());
        }

        WatchUi.popView(SLIDE_IMMEDIATE);
    }
}
