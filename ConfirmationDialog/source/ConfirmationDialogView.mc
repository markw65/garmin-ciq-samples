//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! Shows the result of the confirmation dialog
class ConfirmationDialogView extends WatchUi.View {

    private var _resultString as String;

    //! Constructor
    public function initialize() {
        View.initialize();
        _resultString = WatchUi.loadResource($.Rez.Strings.DefaultResponse) as String;
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.mainLayout(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        var resultLabel = View.findDrawableById("ResultLabel") as Text;
        resultLabel.setText(_resultString);

        View.onUpdate(dc);
    }

    //! Set the result text
    //! @param resultString The result text
    public function setResultString(resultString as String) as Void {
        _resultString = resultString;
    }
}
