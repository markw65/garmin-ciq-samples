//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

enum Action {
    ACTION_CLICK_HOLD = "CLICK_TYPE_HOLD",
    ACTION_CLICK_RELEASE = "CLICK_TYPE_RELEASE",
    ACTION_CLICK_TAP = "CLICK_TYPE_TAP",
    ACTION_KEY_POWER = "KEY_POWER",
    ACTION_KEY_LIGHT = "KEY_LIGHT",
    ACTION_KEY_ZIN = "KEY_ZIN",
    ACTION_KEY_ZOUT = "KEY_ZOUT",
    ACTION_KEY_ENTER = "KEY_ENTER",
    ACTION_KEY_ESC = "KEY_ESC",
    ACTION_KEY_FIND = "KEY_FIND",
    ACTION_KEY_MENU = "KEY_MENU",
    ACTION_KEY_DOWN = "KEY_DOWN",
    ACTION_KEY_DOWN_LEFT = "KEY_DOWN_LEFT",
    ACTION_KEY_DOWN_RIGHT = "KEY_DOWN_RIGHT",
    ACTION_KEY_LEFT = "KEY_LEFT",
    ACTION_KEY_RIGHT = "KEY_RIGHT",
    ACTION_KEY_UP = "KEY_UP",
    ACTION_KEY_UP_LEFT = "KEY_UP_LEFT",
    ACTION_KEY_UP_RIGHT = "KEY_UP_RIGHT",
    ACTION_KEY_PAGE = "KEY_PAGE",
    ACTION_KEY_START = "KEY_START",
    ACTION_KEY_LAP = "KEY_LAP",
    ACTION_KEY_RESET = "KEY_RESET",
    ACTION_KEY_SPORT = "KEY_SPORT",
    ACTION_KEY_CLOCK = "KEY_CLOCK",
    ACTION_KEY_MODE = "KEY_MODE",
    ACTION_SWIPE_UP = "SWIPE_UP",
    ACTION_SWIPE_RIGHT = "SWIPE_RIGHT",
    ACTION_SWIPE_DOWN = "SWIPE_DOWN",
    ACTION_SWIPE_LEFT = "SWIPE_LEFT",
    ACTION_NONE = "NO_ACTION",
}

enum Behavior {
    BEHAVIOR_NEXT_PAGE = "NEXT_PAGE",
    BEHAVIOR_PREV_PAGE = "PREVIOUS_PAGE",
    BEHAVIOR_MENU = "ON_MENU",
    BEHAVIOR_BACK = "ON_BACK",
    BEHAVIOR_NEXT_MODE = "ON_NEXT_MODE",
    BEHAVIOR_PREV_MODE = "ON_PREVIOUS_MODE",
    BEHAVIOR_SELECT = "ON_SELECT",
    BEHAVIOR_NONE = "NO_BEHAVIOR",
}

enum Button {
    BUTTON_MORE = "MORE_BUTTONS",
    BUTTON_NO_MORE = "NO_MORE_BUTTONS",
    BUTTON_PUSH = "PUSH_BUTTONS",
    BUTTON_UNKNOWN = "UNKNOWN_BUTTON",
}

enum Status {
    STATUS_PRESSED = "PRESSED",
    STATUS_RELEASED = "RELEASED",
    STATUS_NONE = "NO_EVENT",
}

//! Handles the behavior / input events
class InputDelegate extends WatchUi.BehaviorDelegate {
    private var _lastKey as Key?;
    private var _lastBehavior as Behavior?;
    private var _buttonsPressed as Number?;
    private var _buttonsExpected as ButtonInputs?;
    private var _parentView as InputView;

    //! Constructor
    //! @param view The InputView to operate on
    public function initialize(view as InputView) {
        BehaviorDelegate.initialize();

        _buttonsPressed = 0;
        _parentView = view;

        var deviceSettings = System.getDeviceSettings();
        _buttonsExpected = deviceSettings.inputButtons;
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        _lastBehavior = $.BEHAVIOR_NEXT_PAGE;
        _parentView.setBehavior($.BEHAVIOR_NEXT_PAGE);
        return false;
    }

    //! Handle going to the previous view
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        _lastBehavior = $.BEHAVIOR_PREV_PAGE;
        _parentView.setBehavior($.BEHAVIOR_PREV_PAGE);
        return false;
    }

    //! Handle the menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        _lastBehavior = $.BEHAVIOR_MENU;
        _parentView.setBehavior($.BEHAVIOR_MENU);
        return false;
    }

    //! Handle the back event
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        if ($.BEHAVIOR_BACK == _lastBehavior) {
            System.exit();
        }
        _lastBehavior = $.BEHAVIOR_BACK;
        _parentView.setBehavior($.BEHAVIOR_BACK);
        return false;
    }

    //! Handle the next event
    //! @return true if handled, false otherwise
    public function onNextMode() as Boolean {
        _lastBehavior = $.BEHAVIOR_NEXT_MODE;
        _parentView.setBehavior($.BEHAVIOR_NEXT_MODE);
        return false;
    }

    //! Handle the previous event
    //! @return true if handled, false otherwise
    public function onPreviousMode() as Boolean {
        _lastBehavior = $.BEHAVIOR_PREV_MODE;
        _parentView.setBehavior($.BEHAVIOR_PREV_MODE);
        return false;
    }

    //! Handle the select button
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        _lastBehavior = $.BEHAVIOR_SELECT;
        _parentView.setBehavior($.BEHAVIOR_SELECT);
        return false;
    }

    //! Handle a screen tap event
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onTap(evt as ClickEvent) as Boolean {
        _parentView.setAction($.ACTION_CLICK_TAP);
        return true;
    }

    //! Handle the touch screen hold event
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onHold(evt as ClickEvent) as Boolean {
        _parentView.setAction($.ACTION_CLICK_HOLD);
        return true;
    }

    //! Handle the touch screen release event
    //! @param evt The click event that occurred
    //! @return true if handled, false otherwise
    public function onRelease(evt as ClickEvent) as Boolean {
        _parentView.setAction($.ACTION_CLICK_RELEASE);
        return true;
    }

    //! Handle the touch screen swipe event
    //! @param evt The swipe event that occurred
    //! @return true if handled, false otherwise
    public function onSwipe(evt as SwipeEvent) as Boolean {
        var swipe = evt.getDirection();

        if (swipe == SWIPE_UP) {
            _parentView.setAction($.ACTION_SWIPE_UP);
        } else if (swipe == SWIPE_RIGHT) {
            _parentView.setAction($.ACTION_SWIPE_RIGHT);
        } else if (swipe == SWIPE_DOWN) {
            _parentView.setAction($.ACTION_SWIPE_DOWN);
        } else if (swipe == SWIPE_LEFT) {
            _parentView.setAction($.ACTION_SWIPE_LEFT);
        }

        return true;
    }

    //! Handle a physical button being pressed and released
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKey(evt as KeyEvent) as Boolean {
        var key = evt.getKey();

        var button = getButton(key);

        _parentView.setButton(button);

        var keyAction = getKeyAction(key);

        if (keyAction != null) {
            _parentView.setAction(keyAction);
        }

        if (key == KEY_ESC) {
            if (_lastKey == KEY_ESC) {
                System.exit();
            }
        }

        _lastKey = key;

        return true;
    }

    //! Handle a physical button being pressed
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKeyPressed(evt as KeyEvent) as Boolean {
        var key = getKeyAction(evt.getKey());
        if (key != null) {
            _parentView.setStatusString(key + " " + $.STATUS_PRESSED);
        }

        return true;
    }

    //! Handle a physical button being released
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKeyReleased(evt as KeyEvent) as Boolean {
        var key = getKeyAction(evt.getKey());
        if (key != null) {
            _parentView.setStatusString(key + " " + $.STATUS_RELEASED);
        }

        return true;
    }

    //! Get the action enum corresponding to the given key enum
    //! @param key The key enum
    //! @return Action enum of key, or null if key not found
    private function getKeyAction(key as Key) as Action? {
        if (key == KEY_POWER) {
            return $.ACTION_KEY_POWER;
        } else if (key == KEY_LIGHT) {
            return $.ACTION_KEY_LIGHT;
        } else if (key == KEY_ZIN) {
            return $.ACTION_KEY_ZIN;
        } else if (key == KEY_ZOUT) {
            return $.ACTION_KEY_ZOUT;
        } else if (key == KEY_ENTER) {
            return $.ACTION_KEY_ENTER;
        } else if (key == KEY_ESC) {
            return $.ACTION_KEY_ESC;
        } else if (key == KEY_FIND) {
            return $.ACTION_KEY_FIND;
        } else if (key == KEY_MENU) {
            return $.ACTION_KEY_MENU;
        } else if (key == KEY_DOWN) {
            return $.ACTION_KEY_DOWN;
        } else if (key == KEY_DOWN_LEFT) {
            return $.ACTION_KEY_DOWN_LEFT;
        } else if (key == KEY_DOWN_RIGHT) {
            return $.ACTION_KEY_DOWN_RIGHT;
        } else if (key == KEY_LEFT) {
            return $.ACTION_KEY_LEFT;
        } else if (key == KEY_RIGHT) {
            return $.ACTION_KEY_RIGHT;
        } else if (key == KEY_UP) {
            return $.ACTION_KEY_UP;
        } else if (key == KEY_UP_LEFT) {
            return $.ACTION_KEY_UP_LEFT;
        } else if (key == KEY_UP_RIGHT) {
            return $.ACTION_KEY_UP_RIGHT;
        } else if (key == KEY_PAGE) {
            return $.ACTION_KEY_PAGE;
        } else if (key == KEY_START) {
            return $.ACTION_KEY_START;
        } else if (key == KEY_LAP) {
            return $.ACTION_KEY_LAP;
        } else if (key == KEY_RESET) {
            return $.ACTION_KEY_RESET;
        } else if (key == KEY_SPORT) {
            return $.ACTION_KEY_SPORT;
        } else if (key == KEY_CLOCK) {
            return $.ACTION_KEY_CLOCK;
        } else if (key == KEY_MODE) {
            return $.ACTION_KEY_MODE;
        }

        return null;
    }

    //! Find the button that corresponds to the given key and return
    //! whether there are buttons that haven't been pressed
    //! @param key The key that was pressed
    //! @return Button enum telling whether all buttons have been pressed
    private function getButton(key as Key) as Button {
        var buttonsPressed = _buttonsPressed;
        var buttonBit = getButtonBit(key);
        if (buttonBit == null || buttonsPressed == null) {
            _buttonsPressed = null;
            return $.BUTTON_UNKNOWN;
        } else {
            _buttonsPressed = buttonsPressed | buttonBit;

            if (_buttonsPressed == _buttonsExpected) {
                return $.BUTTON_NO_MORE;
            } else {
                return $.BUTTON_MORE;
            }
        }
    }

    //! Get the button input that corresponds to the given key enum
    //! @param key The key enum
    //! @return Button input of the key, or null if button not found
    private function getButtonBit(key as Key) as ButtonInputs? {
        if (key == KEY_ENTER) {
            return System.BUTTON_INPUT_SELECT;
        } else if (key == KEY_UP) {
            return System.BUTTON_INPUT_UP;
        } else if (key == KEY_DOWN) {
            return System.BUTTON_INPUT_DOWN;
        } else if (key == KEY_MENU) {
            return System.BUTTON_INPUT_MENU;
        } else if (key == KEY_CLOCK && System has :BUTTON_INPUT_CLOCK) {
            return System.BUTTON_INPUT_CLOCK;
        } else if (key == KEY_DOWN_LEFT && System has :BUTTON_INPUT_DOWN_LEFT) {
            return System.BUTTON_INPUT_DOWN_LEFT;
        } else if (
            key == KEY_DOWN_RIGHT &&
            System has :BUTTON_INPUT_DOWN_RIGHT
        ) {
            return System.BUTTON_INPUT_DOWN_RIGHT;
        } else if (key == KEY_ESC && System has :BUTTON_INPUT_ESC) {
            return System.BUTTON_INPUT_ESC;
        } else if (key == KEY_FIND && System has :BUTTON_INPUT_FIND) {
            return System.BUTTON_INPUT_FIND;
        } else if (key == KEY_LAP && System has :BUTTON_INPUT_LAP) {
            return System.BUTTON_INPUT_LAP;
        } else if (key == KEY_LEFT && System has :BUTTON_INPUT_LEFT) {
            return System.BUTTON_INPUT_LEFT;
        } else if (key == KEY_LIGHT && System has :BUTTON_INPUT_LIGHT) {
            return System.BUTTON_INPUT_LIGHT;
        } else if (key == KEY_MODE && System has :BUTTON_INPUT_MODE) {
            return System.BUTTON_INPUT_MODE;
        } else if (key == KEY_PAGE && System has :BUTTON_INPUT_PAGE) {
            return System.BUTTON_INPUT_PAGE;
        } else if (key == KEY_POWER && System has :BUTTON_INPUT_POWER) {
            return System.BUTTON_INPUT_POWER;
        } else if (key == KEY_RESET && System has :BUTTON_INPUT_RESET) {
            return System.BUTTON_INPUT_RESET;
        } else if (key == KEY_RIGHT && System has :BUTTON_INPUT_RIGHT) {
            return System.BUTTON_INPUT_RIGHT;
        } else if (key == KEY_SPORT && System has :BUTTON_INPUT_SPORT) {
            return System.BUTTON_INPUT_SPORT;
        } else if (key == KEY_START && System has :BUTTON_INPUT_START) {
            return System.BUTTON_INPUT_START;
        } else if (key == KEY_UP_LEFT && System has :BUTTON_INPUT_UP_LEFT) {
            return System.BUTTON_INPUT_UP_LEFT;
        } else if (key == KEY_UP_RIGHT && System has :BUTTON_INPUT_UP_RIGHT) {
            return System.BUTTON_INPUT_UP_RIGHT;
        } else if (key == KEY_ZIN && System has :BUTTON_INPUT_ZIN) {
            return System.BUTTON_INPUT_ZIN;
        } else if (key == KEY_ZOUT && System has :BUTTON_INPUT_ZOUT) {
            return System.BUTTON_INPUT_ZOUT;
        }

        return null;
    }
}
