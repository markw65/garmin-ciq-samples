//
// Copyright 2017-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.WatchUi;

//! Main view for the encryption app
class EncryptionView extends WatchUi.View {

    //! Constructor
    public function initialize() {
        // Initializes parent class
        View.initialize();
    }

    //! Loads start screen
    //! @param dc Device Context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.MainLayout(dc));
    }

    //! Updates the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }
}
