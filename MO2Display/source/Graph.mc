//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

//! A simple line graph drawing class
class LineGraph {
    private var _graphArray as Array<Number or Float or Null>;
    private var _graphIndex as Number;
    private var _graphRange as Array<Number or Float or Null>;
    private var _graphMinRange as Number;
    private var _graphColor as ColorType;

    //! Constructor
    //! @param size Number of points in the graph
    //! @param minRange Smallest range to use for the graph
    //! @param color Color to use to draw the graph
    public function initialize(size as Number, minRange as Number, color as ColorType) {
        _graphIndex = 0;
        _graphRange = [null, null] as Array<Number or Float or Null>;

        if (size < 2) {
            System.error("graph size less than 2 is not allowed");
        }
        _graphArray = new Array<Number or Float or Null>[size];
        _graphMinRange = minRange;
        _graphColor = color;
    }

    //! Add an item to the line graph
    //! @param value Number to add to the graph
    public function addItem(value as Number or Float) as Void {
        var updateMin = false;
        var updateMax = false;

        if ((value instanceof Number) || (value instanceof Float)) {
            if (_graphRange[0] == null) {
                // This is our first value, save as min and max
                _graphRange[0] = value;
                _graphRange[1] = value;
            }
            var graphMin = _graphRange[0];
            var graphMax = _graphRange[1];

            // Save value if it is a new minimum
            if (graphMin != null) {
                if (value < graphMin) {
                    _graphRange[0] = value;
                } else if (_graphArray[_graphIndex] == graphMin) {
                    updateMin = true;
                }
            }

            // Save value if it is a new maximum
            if (graphMax != null) {
                if (value > graphMax) {
                    _graphRange[1] = value;
                } else if (_graphArray[_graphIndex] == graphMax) {
                    updateMax = true;
                }
            }

            // Fill in new Graph value
            _graphArray[_graphIndex] = value;
            // Increment and wrap graph index
            _graphIndex++;
            if (_graphIndex == _graphArray.size()) {
                _graphIndex = 0;
            }

            if (updateMin) {
                var min = _graphArray[0];
                for (var i = 1; i < _graphArray.size(); i++) {
                    var curPoint = _graphArray[i];
                    if ((curPoint != null) && (min != null)) {
                        if (curPoint < min) {
                            min = curPoint;
                        }
                    }
                }
                _graphRange[0] = min;
            }

            if (updateMax) {
                var max = _graphArray[0];
                for (var i = 1; i < _graphArray.size(); i++) {
                    var curPoint = _graphArray[i];
                    if ((curPoint != null) && (max != null)) {
                        if (curPoint > max) {
                            max = curPoint;
                        }
                    }
                }
                _graphRange[1] = max;
            }
        } else {
            // This isn't allowed
        }

    }

    //! Draw the line graph
    //! @param dc Device context
    //! @param topLeft Array [x, y] of the top left corner
    //! @param bottomRight Array [x, y] of the bottom right corner
    public function draw(dc as Dc, topLeft as Array<Number>, bottomRight as Array<Number>) as Void {
        var drawExtentsX = bottomRight[0] - topLeft[0] + 1;
        var drawExtentsY = bottomRight[1] - topLeft[1] + 1;
        var draw_idx = 1;

        // If the graph range is null, no values have been added yet
        var graphMin = _graphRange[0];
        var graphMax = _graphRange[1];
        if ((graphMin != null) && (graphMax != null)) {
            // Set Graph color
            dc.setColor(_graphColor, _graphColor);

            // Determine Graph minimum and range
            var min = graphMin;
            var range = graphMax - graphMin;
            range = range.toFloat();

            if (range < _graphMinRange) {
                min -= (_graphMinRange - range) / 2;
                range = _graphMinRange;
            }

            var prev_x = topLeft[0];
            var x = topLeft[0] + drawExtentsX * draw_idx / (_graphArray.size() - 1);
            var y = null;
            for (var i = _graphIndex; i < _graphArray.size(); i++) {
                var curPoint = _graphArray[i];
                if (curPoint != null) {
                    var prev_y = y;
                    y = bottomRight[1] - ((curPoint - min) * drawExtentsY / range);
                    y = y.toNumber();

                    if (prev_y != null) {
                        dc.drawLine(prev_x, prev_y as Number, x, y);
                        prev_x = x;
                        draw_idx++;
                        x = topLeft[0] + drawExtentsX * draw_idx / (_graphArray.size() - 1);
                    }
                }
            }

            for (var i = 0; i < _graphIndex; i++) {
                var curPoint = _graphArray[i];
                if (curPoint != null) {
                    var prev_y = y;
                    y = bottomRight[1] - ((curPoint - min) * drawExtentsY / range);
                    y = y.toNumber();

                    if (prev_y != null) {
                        dc.drawLine(prev_x, prev_y, x, y);
                        prev_x = x;
                        draw_idx++;
                        x = topLeft[0] + drawExtentsX * draw_idx / (_graphArray.size() - 1);
                    }
                }
            }
        }
    }
}
