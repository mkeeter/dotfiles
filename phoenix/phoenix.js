/**
 * Originally based on
 * https://github.com/garrow/phoenix-configurations/blob/master/phizeup/phizeup.js
 * but then I deleted most of it.
 */

"use strict";

/**
 * Configure PhizeUp's behaviour here.
 */
var config = {
    movementAlertDuration: 0.5,
    sizeUpDefaults: false
};

var setupHandlers = function(useSizeUpDefaults){
    var screenKeys = ['alt', 'cmd'];

    return {
        left:        new Key('left',  screenKeys, putWindow('left')),
        right:       new Key('right', screenKeys, putWindow('right')),

        maximised:   new Key('f',       screenKeys, maximise()),
    };
};


/**
 * Sometimes a window doesn't actually exist.
 *
 * @param window
 * @param action
 * @returns {*}
 */
var withWindow = function withWindow(window, action) {
    if (window) {
        return action(window);
    }
    alertModal("Nothing to move");
};

/**
 * Build and return a handler which puts the focused (active) window into a position on that window's current screen.
 *
 * @param direction [Any Movement]
 * @returns {Function}
 */
var putWindow = function(direction){
    return function() {

        withWindow(Window.focused(), function(window) {
            var screenFrame = window.screen().flippedFrame();

            setInSubFrame(window, screenFrame, direction);
        });
    };
};

/**
 * Place the window into a subframe inside the parent frame.
 *
 * @param window
 * @param parentFrame
 * @param direction
 */
var setInSubFrame = function(window, parentFrame, direction) {
    var newWindowFrame = getSubFrame(parentFrame, direction);
    window.setFrame(newWindowFrame);
};

/**
 * Build and return a handler to maximise the focused window.
 * @returns {Function}
 */
var maximise = function() {
    return function () {
        withWindow(Window.focused(), function(window){
            window.maximise();
        });
    };
};

/**
 * Build a subframe within a parent frame.
 * This fn does the work of subdividing the rectangle. (screen)
 *
 * @param parentFrame
 * @param direction
 * @returns {*} / Rectangle
 */
var getSubFrame = function(parentFrame, direction) {
    var parentX      = parentFrame.x;
    var parentY      = parentFrame.y;
    var parentWidth  = parentFrame.width;
    var parentHeight = parentFrame.height;

    /**
    * When using multiple screens, the current screen may be offset from the Zero point screen,
    * using the raw x,y coords blindly will mess up the positions.
    * Instead, we offset the screen x,y, coords based on the original origin point of the screen.
    *      |---|
    *  |---|---|
    * In this case we have two screens side by side, but aligned on the physical bottom edge.
    * Remember that coords are origin 0,0 top left.
    * screen 1.  { x: 0, y: 0, width: 800, height: 600 }
    * screen 2.  { x: 800, y: -600, width: 1600, height: 1200 }
    **/
    var change = function(original) {
        return function(changeBy) {
            var offset = changeBy || 0;
            return original + offset;
        };
    };

    var y = change(parentY);
    var x = change(parentX);

    var parentHalfWide = parentWidth / 2;
    var parentHalfHigh = parentHeight / 2;
    var parentThird    = parentWidth / 3;
    var parentTwoThirds = parentThird * 2;

    var subFrames = {
        left:         { x: x(),                 y: y(),                 width: parentHalfWide, height: parentHeight   },
        right:        { x: x(parentHalfWide),   y: y(),                 width: parentHalfWide, height: parentHeight   },
        up:           { x: x(),                 y: y(),                 width: parentWidth,    height: parentHalfHigh },
        down:         { x: x(),                 y: y(parentHalfHigh),   width: parentWidth,    height: parentHalfHigh },
        topLeft:      { x: x(),                 y: y(),                 width: parentHalfWide, height: parentHalfHigh },
        bottomLeft:   { x: x(),                 y: y(parentHalfHigh),   width: parentHalfWide, height: parentHalfHigh },
        topRight:     { x: x(parentHalfWide),   y: y(),                 width: parentHalfWide, height: parentHalfHigh },
        bottomRight:  { x: x(parentHalfWide),   y: y(parentHalfHigh),   width: parentHalfWide, height: parentHalfHigh },
        centre:       { x: x(parentHalfWide/2), y: y(parentHalfHigh/2), width: parentHalfWide, height: parentHalfHigh },
        leftThird:    { x: x(),                 y: y(),                 width: parentThird,    height: parentHeight   },
        centreThird:  { x: x(parentThird),      y: y(),                 width: parentThird,    height: parentHeight   },
        rightThird:   { x: x(parentTwoThirds),  y: y(),                 width: parentThird,    height: parentHeight   },
        left2Thirds:  { x: x(),                 y: y(),                 width: parentTwoThirds, height: parentHeight  },
        right2Thirds: { x: x(parentThird),      y: y(),                 width: parentTwoThirds, height: parentHeight  },
        topLeftSix:   { x: x(),                 y: y(),                 width: parentThird,    height: parentHalfHigh },
        topCentreSix: { x: x(parentThird),      y: y(),                 width: parentThird,    height: parentHalfHigh },
        topRightSix:  { x: x(parentTwoThirds),  y: y(),                 width: parentThird,    height: parentHalfHigh },
        botLeftSix:   { x: x(),                 y: y(parentHalfHigh),   width: parentThird,    height: parentHalfHigh },
        botCentreSix: { x: x(parentThird),      y: y(parentHalfHigh),   width: parentThird,    height: parentHalfHigh },
        botRightSix:  { x: x(parentTwoThirds),  y: y(parentHalfHigh),   width: parentThird,    height: parentHalfHigh }
    };

    return subFrames[direction];
};

// Phoenix requires us to keep a reference to the key handlers.
var keyHandlers = setupHandlers(config.sizeUpDefaults);
