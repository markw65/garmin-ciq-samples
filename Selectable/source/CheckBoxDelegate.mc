//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Handle behavior of check boxes.
class CheckBoxDelegate extends WatchUi.BehaviorDelegate {
    private var _keyToSelectable as Boolean = false;
    private var _view as CheckBoxView;

    //! Constructor
    //! @param view The check box view
    public function initialize(view as CheckBoxView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    //! Handle the state of a Selectable changing
    //! @param event The selectable event
    //! @return true if handled, false otherwise
    public function onSelectable(event as SelectableEvent) as Boolean {
        var instance = event.getInstance();
        if (instance instanceof CheckBox) {
            var checkBoxes = _view.getCheckBoxes();
            if (checkBoxes != null) {
                checkBoxes.handleEvent(instance, event.getPreviousState());
            }
        }
        return true;
    }

    //! Handle the menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        _keyToSelectable = !_keyToSelectable;
        _view.setKeyToSelectableInteraction(_keyToSelectable);
        return true;
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        return pushMenu(WatchUi.SLIDE_IMMEDIATE);
    }

    //! Push a new menu view
    //! @param slideDir Slide transition to use for the new view
    //! @return true if handled, false otherwise
    private function pushMenu(slideDir as SlideType) as Boolean {
        var view = new $.ButtonView();
        var delegate = new $.ButtonDelegate();
        WatchUi.pushView(view, delegate, slideDir);
        return true;
    }

    //! Handle a key event
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKey(evt as KeyEvent) as Boolean {
        var key = evt.getKey();

        if (key == KEY_ENTER) {
            return pushMenu(WatchUi.SLIDE_IMMEDIATE);
        }

        return false;
    }
}
