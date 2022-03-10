//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input delegate to start the TextPicker
class KeyboardDelegate extends WatchUi.InputDelegate {

    private var _lastText as String = "";
    private var _view as KeyboardView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as KeyboardView) {
        WatchUi.InputDelegate.initialize();
        _view = view;
    }

    //! Push a text picker if the up button is pressed
    //! @param key The key event that occurred
    //! @return true if event is handled, false otherwise
    public function onKey(key as KeyEvent) as Boolean {
        if ((WatchUi has :TextPicker) && (key.getKey() == WatchUi.KEY_UP)) {
            WatchUi.pushView(new WatchUi.TextPicker(_lastText), new $.KeyboardListener(_view, self), WatchUi.SLIDE_DOWN);
        }
        return true;
    }

    //! Push a text picker if the screen receives a tap.
    //! @param evt The click event that occurred
    //! @return true if event is handled, false otherwise
    public function onTap(evt as ClickEvent) as Boolean {
        if (WatchUi has :TextPicker) {
            WatchUi.pushView(new WatchUi.TextPicker(_lastText), new $.KeyboardListener(_view, self), WatchUi.SLIDE_DOWN);
        }
        return true;
    }

    //! Set the last text entered
    //! @param text The last text entered
    public function setLastText(text as String) as Void {
        _lastText = text;
    }

}

//! TextPicker Delegate to handle text being selected
class KeyboardListener extends WatchUi.TextPickerDelegate {

    private var _delegate as KeyboardDelegate;
    private var _view as KeyboardView;

    //! Constructor
    //! @param view The app view
    //! @param delegate The app delegate
    public function initialize(view as KeyboardView, delegate as KeyboardDelegate) {
        WatchUi.TextPickerDelegate.initialize();
        _delegate = delegate;
        _view = view;
    }

    //! Update the current text when the user enters text
    //! @param text The entered text
    //! @param changed Whether the entered text differs from the previous text
    //! @return true if event is handled, false otherwise
    public function onTextEntered(text as String, changed as Boolean) as Boolean {
        var viewText = text + "\n" + "Changed: " + changed.toString();
        _view.setText(viewText);
        _delegate.setLastText(text);
        return true;
    }

    //! Handle user cancelling the text entry
    //! @return true if event is handled, false otherwise
    public function onCancel() as Boolean {
        _view.setText("Cancelled");
        return true;
    }
}