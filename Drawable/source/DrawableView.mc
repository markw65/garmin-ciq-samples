//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.WatchUi;

//! View class for Drawable
class DrawableView extends WatchUi.View {

    private var _train as Drawable;
    private var _backdrop as Drawable;
    private var _cloud as Bitmap;

    //! Constructor
    public function initialize() {
        View.initialize();
        _train = new $.Rez.Drawables.train();
        _backdrop = new $.Rez.Drawables.backdrop();
        _cloud = new WatchUi.Bitmap({:rezId=>$.Rez.Drawables.cloud, :locX=>10, :locY=>30});
    }

    //! Load the resources
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        WatchUi.animate(_cloud, :locX, WatchUi.ANIM_TYPE_LINEAR, 10, dc.getWidth() + 50, 10, null);
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        _backdrop.draw(dc);
        _train.draw(dc);
        _cloud.draw(dc);
    }

}
