//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Show the current JSON Resource
class JsonDataResourcesView extends WatchUi.View {

    typedef JsonResourceType as Numeric or String or Array<JsonResourceType> or Dictionary<String, JsonResourceType>;

    private var _curLoadedJsonResource as JsonResourceType?;

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
    }

    //! Restore the state of this View and prepare the view to be shown
    public function onShow() as Void {
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Clear the view
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        var headerText = "Press Menu";
        dc.drawText(dc.getWidth() / 2, 5, Graphics.FONT_XTINY, headerText, Graphics.TEXT_JUSTIFY_CENTER);

        if (null != _curLoadedJsonResource) {
            // Draw the current loaded JSON record as text on the screen
            dc.drawText(dc.getWidth() / 2, dc.getFontHeight(Graphics.FONT_XTINY) + 5, Graphics.FONT_XTINY, getDisplayString(_curLoadedJsonResource), Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    //! Handle view being hidden
    public function onHide() as Void {
    }

    //! Get a display string for the current object
    //! @param item A loaded JSON Resource
    //! @return String representation of the item
    private function getDisplayString(item as JsonResourceType) as String {
        var displayString;
        if (item instanceof Array) {
            displayString = getArrayDisplayString(item);
        } else if (item instanceof Dictionary) {
            displayString = getDictionaryDisplayString(item);
        } else {
            displayString = "Simple Value\n";
            displayString += item.toString();
        }

        return displayString;
    }

    //! Get a display string for an array
    //! @param array Array from JSON Resources
    //! @return String representation of the array
    private function getArrayDisplayString(array as Array<JsonResourceType>) as String {
        var displayString = "Array JSON Resource\n";
        displayString += "[\n";
        for (var index = 0; index < array.size(); index++) {
            displayString += array[index].toString();

            if (index < (array.size() - 1)) {
                displayString += ",";
            }

            displayString += "\n";
        }
        displayString += "]\n";

        return displayString;
    }

    //! Get a display string for a dictionary
    //! @param dictionary Dictionary from JSON Resources
    //! @return String representation of the dictionary
    private function getDictionaryDisplayString(dictionary as Dictionary<String, JsonResourceType>) as String {
        var displayString = "Dictionary\nJSON Resource\n";
        displayString += "{\n";
        for (var index = 0; index < dictionary.keys().size(); index++) {
            var key = dictionary.keys()[index];
            var value = dictionary[key];

            if (value != null) {
                displayString += key + "=>" + value.toString();
            } else {
                displayString += key + "=>null";
            }

            if (index < (dictionary.keys().size() - 1)) {
                displayString += ",";
            }

            displayString += "\n";
        }
        displayString += "}\n";

        return displayString;
    }

    //! Load a JSON resource record into _curLoadedResource
    //! @param resourceId Resource identifier for the record
    public function loadJsonRecord(resourceId as Symbol) as Void {
        _curLoadedJsonResource = WatchUi.loadResource(resourceId) as JsonResourceType;
        WatchUi.requestUpdate();
    }

}
