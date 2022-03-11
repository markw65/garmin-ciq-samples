//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.WatchUi;

//! Draws a color wheel for the color picker
class ColorWheel extends WatchUi.Drawable {
    private var _colors as Array<ColorType>;
    private var _index as Number;

    private const NUM_POINTS = 30;

    //! Constructor
    //! @param colors The colors to put on the color wheel
    public function initialize(colors as Array<ColorType>) {
        Drawable.initialize({});
        _colors = colors;
        _index = 0;
    }

    //! Draw an object to device context
    //! @param dc Device context
    public function draw(dc as Dc) as Void {
        var index = _index;
        var angle = (Math.PI * 2) / _colors.size();
        var startAngle = Math.PI * (3 / 2.0) - angle / 2.0;

        // draw the wheel
        for (var i = 0; i < _colors.size(); ++i) {
            if (index == _colors.size()) {
                index = 0;
            }
            dc.setColor(_colors[index], _colors[index]);
            drawArc(
                dc,
                dc.getHeight() / 2,
                dc.getWidth() / 2,
                i * angle + startAngle,
                (i + 1) * angle + startAngle,
                true
            );
            index++;
        }

        // highlight the selected one
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        drawArc(
            dc,
            dc.getHeight() / 2,
            dc.getWidth() / 2,
            startAngle,
            startAngle + angle,
            false
        );
    }

    //! Draw an arc that is a section of the color wheel
    //! @param dc Device context
    //! @param centerX Center of the wheel, x coordinate
    //! @param centerY Center of the wheel, y coordinate
    //! @param startAngle Angle for the start of the arc
    //! @param endAngle Angle for the end of the arc
    //! @param fill Whether to fill the section drawn
    public function drawArc(
        dc as Dc,
        centerX as Number,
        centerY as Number,
        startAngle as Float,
        endAngle as Float,
        fill as Boolean
    ) as Void {
        var points = new Array<Array<Number or Float> >[NUM_POINTS];
        var halfHeight = dc.getHeight() / 2;
        var halfWidth = dc.getWidth() / 2;
        var radius = halfHeight > halfWidth ? halfWidth : halfHeight;
        var arcSize = NUM_POINTS - 2;
        for (var i = arcSize; i >= 0; --i) {
            var angle =
                (i / arcSize.toFloat()) * (endAngle - startAngle) + startAngle;
            points[i] = [
                halfWidth + radius * Math.cos(angle),
                halfHeight + radius * Math.sin(angle),
            ] as Array<Float>;
        }
        points[NUM_POINTS - 1] = [halfWidth, halfHeight] as Array<Number>;

        if (fill) {
            dc.fillPolygon(points);
        } else {
            for (var i = 0; i < NUM_POINTS - 1; ++i) {
                dc.drawLine(
                    points[i][0],
                    points[i][1],
                    points[i + 1][0],
                    points[i + 1][1]
                );
            }
            dc.drawLine(
                points[NUM_POINTS - 1][0],
                points[NUM_POINTS - 1][1],
                points[0][0],
                points[0][1]
            );
        }
    }

    //! Set the current color index
    //! @param index Current color index
    public function setColor(index as Number) as Void {
        _index = index;
    }

    //! Get the color of the item at the given index
    //! @param index Index of the item to get the color of
    //! @return Color of the item
    public function getColor(index as Number) as ColorType {
        return _colors[index];
    }

    //! Get the number of colors in the wheel
    //! @return Number of colors
    public function getNumberOfColors() as Number {
        return _colors.size();
    }

    //! Get the index of a color
    //! @param color The color to get the index of
    //! @return The index of the color
    public function getColorIndex(color as ColorType) as Number {
        for (var i = 0; i < _colors.size(); i++) {
            if (color == _colors[i]) {
                return i;
            }
        }
        return -1;
    }
}
