//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Implementation of a CheckBox using Selectable, with the following rules:
//! 1. A CheckBox is "checked" if selected
//! 2. A CheckBox is only "unchecked" if selected again
//! 3. Only one CheckBox may be highlighted at a time
class CheckBox extends WatchUi.Selectable {
    //! Default state Drawable or color/number
    public var stateHighlightedSelected as Bitmap?;

    //! Constructor
    //! @param options A Dictionary of check box options
    //! @option options :locX The x-coordinate for the check box
    //! @option options :locY The y-coordinate for the check box
    //! @option options :width The clip width of the check box
    //! @option options :height The clip height of the check box
    //! @option options :stateDefault The Drawable or color to display in default state
    //! @option options :stateHighlighted The Drawable or color to display in highlighted state
    //! @option options :stateSelected The Drawable or color to display in selected state
    //! @option options :stateDisabled The Drawable or color to display in disabled state
    //! @option options :stateHighlightedSelected The Drawable or color to display in the
    //!  selected and highlighted state
    public function initialize(options as {
                :locX as Number,
                :locY as Number,
                :width as Number,
                :height as Number,
                :stateDefault as Graphics.ColorType or Drawable,
                :stateHighlighted as Graphics.ColorType or Drawable,
                :stateSelected as Graphics.ColorType or Drawable,
                :stateDisabled as Graphics.ColorType or Drawable,
                :stateHighlightedSelected as Bitmap
            }) {
        Selectable.initialize(options);

        // Set each state value to a Drawable, color/number, or null
        stateHighlightedSelected = options.get(:stateHighlightedSelected);
    }

    //! Handle unhighlighting of a check box
    public function unHighlight() as Void {
        if (getState() == :stateHighlighted) {
            // If we were highlighted, return to default state
            setState(:stateDefault);
        } else if (getState() == :stateHighlightedSelected) {
            // If were were highlighted/selected, move to selected state
            setState(:stateSelected);
        }
    }

    //! Handle onSelectable() returning stateDefault
    //! @param previousState The previous check box state
    public function reset(previousState as Symbol) as Void {
        // If we were highlighted/selected, or selected, move to selected state
        // We only return to the unchecked state if selected again
        if (previousState == :stateSelected) {
            setState(:stateSelected);
        } else if (previousState == :stateHighlightedSelected) {
            setState(:stateSelected);
        }
    }

    //! Handle onSelectable() returning stateHighlighted
    //! @param previousState The previous check box state
    public function highlight(previousState as Symbol) as Void {
        // If we were selected, move to highlighted/selected state,
        // otherwise stay in the highlighted state
        if (previousState == :stateSelected) {
            setState(:stateHighlightedSelected);
        }
    }

    //! Handle onSelectable() returning stateSelected
    //! @param previousState The previous check box state
    public function select(previousState as Symbol) as Void {
        if (previousState == :stateHighlighted) {
            // If we were highlighted, move to highlighted/selected state ("checked")
            setState(:stateHighlightedSelected);
        } else if (previousState == :stateHighlightedSelected) {
            // If were were highlighted/selected state, move to highlighted state
            setState(:stateHighlighted);
        } else if (previousState == :stateSelected) {
            // If we were selected, move to default state ("unchecked")
            setState(:stateDefault);
        }
    }
}

//! Store the check boxes and handle check box events
class CheckBoxList {
    // Store references to our list of CheckBoxes
    private var _list as Array<CheckBox>;

    // Store which CheckBox is actively highlighted
    private var _currentHighlight as CheckBox?;

    //! Constructor
    //! @param dc Device context
    public function initialize(dc as Dc) {
        _currentHighlight = null;

        // Define size of border between CheckBoxes
        var BORDER_PAD = 2;

        // Define our states for each CheckBox
        var checkBoxDefault = new WatchUi.Bitmap({:rezId=>$.Rez.Drawables.checkBoxDefault});
        var checkBoxHighlighted = new WatchUi.Bitmap({:rezId=>$.Rez.Drawables.checkBoxHighlighted});
        var checkBoxSelected = new WatchUi.Bitmap({:rezId=>$.Rez.Drawables.checkBoxSelected});
        var checkBoxHighlightedSelected = new WatchUi.Bitmap({:rezId=>$.Rez.Drawables.checkBoxHighlightedSelected});
        var checkBoxDisabled = Graphics.COLOR_BLACK;

        // Create our array of Selectables
        var dims = checkBoxDefault.getDimensions();
        _list = new Array<CheckBox>[3];

        var slideSymbol, spacing, offset, initX, initY;
        if (dc.getHeight() > dc.getWidth()) {
            slideSymbol = :locY;
            spacing = (dc.getHeight() / 4);
            offset = (dims[1] / 2);
            initY = spacing - offset - BORDER_PAD;
            initX = (dc.getWidth() / 2) - (dims[0] / 2);
        } else {
            slideSymbol = :locX;
            spacing = (dc.getWidth() / 4);
            offset = (dims[0] / 2);
            initX = spacing - offset - BORDER_PAD;
            initY = (dc.getHeight() / 2) - (dims[1] / 2);
        }

        // Create the first check-box
        var options = {
            :stateDefault=>checkBoxDefault,
            :stateHighlighted=>checkBoxHighlighted,
            :stateSelected=>checkBoxSelected,
            :stateDisabled=>checkBoxDisabled,
            :stateHighlightedSelected=>checkBoxHighlightedSelected,
            :locX=>initX,
            :locY=>initY,
            :width=>dims[0],
            :height=>dims[1]
            };
        _list[0] = new CheckBox(options);

        // Create the second check-box
        options.put(slideSymbol, 2 * spacing - offset);
        _list[1] = new CheckBox(options);

        // Create the third check-box
        options.put(slideSymbol, 3 * spacing - offset + BORDER_PAD);
        _list[2] = new CheckBox(options);
    }

    //! Return instance of current list of check boxes
    //! @return List of check boxes
    public function getList() as Array<CheckBox> {
        return _list;
    }

    //! General handler for onSelectable() events
    //! @param instance The check box
    //! @param previousState The previous check box state
    public function handleEvent(instance as CheckBox, previousState as Symbol) as Void {
        // Handle all cases except disabled (handled implicitly)
        if (instance.getState() == :stateHighlighted) {
            // Only one CheckBox may be highlighted
            var currentHighlight = _currentHighlight;
            if (null != currentHighlight) {
                if (!currentHighlight.equals(instance)) {
                    currentHighlight.unHighlight();
                }
            }

            // Note which check box was highlighted
            _currentHighlight = instance;
            instance.highlight(previousState);
        } else if (instance.getState() == :stateSelected) {
            instance.select(previousState);
        } else if (instance.getState() == :stateDefault) {
            instance.reset(previousState);
        }
    }
}

//! Display the check boxes
class CheckBoxView extends WatchUi.View {

    // Storage for our CheckBoxList
    private var _checkBoxes as CheckBoxList?;

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        _checkBoxes = new CheckBoxList(dc);
        setLayout(_checkBoxes.getList());
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
    }

    //! Get the current check boxes
    //! @return CheckBoxList object with current check boxes
    public function getCheckBoxes() as CheckBoxList? {
        return _checkBoxes;
    }
}
