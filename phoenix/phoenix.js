// This is my configuration for Phoenix <https://github.com/sdegutis/Phoenix>, an awesome
// and super-lightweight OS X window manager that can be configured and scripted through
// the insanity that is Javascript. Heavily recommended. :)
//
// With my admittedly limited Javascript skills, I'm extending the built-in Phoenix classes
// a little to allow for slightly more expressive window configuration (most importantly,
// by being able to pass screen ratios instead of pixel rects, and controlling specific
// apps just a little bit easier.)
//
// Feedback/forks/improvements highly appreciated!
//
// -- hendrik@mans.de
//    twitter.com/hmans
//

var mash = ["cmd", "alt"];
var padding = 0;

api.bind('f', mash, function() {
  Window.focusedWindow().toFullScreen();
});

api.bind('up', mash, function() {
  Window.focusedWindow().toTopHalf();
});

api.bind('down', mash, function() {
  Window.focusedWindow().toBottomHalf();
});

api.bind('left', mash, function() {
  Window.focusedWindow().toLeftHalf();
});

api.bind('right', mash, function() {
  Window.focusedWindow().toRightHalf();
});

/*
api.bind('1', mash, function() {
  api.alert("Layout 1", 0.5);
  forApp("Google Chrome", function(win) {
    win.toRightHalf();
  });

  forApp("Terminal", function(win) {
    win.toGrid(0, 0.7, 0.5, 0.3);
  });

  forApp("Sublime Text", function(win) {
    win.toGrid(0, 0, 0.5, 0.7);
  });

  forApp("Atom", function(win) {
    win.toGrid(0, 0, 0.5, 0.7);
  });

  forApp("GitX", function(win) {
    win.toGrid(0.2, 0.2, 0.6, 0.6);
  });
});

api.bind('2', mash, function() {
  api.alert("Layout 2", 0.5);

  forApp("Terminal", function(win) {
    win.toRightHalf();
  })

  forApp("Sublime Text", function(win) {
    win.toLeftHalf();
  })

  forApp("Atom", function(win) {
    win.toLeftHalf();
  })
});
*/

// Let's extend the Phoenix classes a little.
//

var lastFrames = {};

Window.prototype.toGrid = function(x, y, width, height) {
  var screen = this.screen().frameWithoutDockOrMenu();

  this.setFrame({
    x:      Math.round(x * screen.width)       + padding    + screen.x,
    y:      Math.round(y * screen.height)      + padding    + screen.y,
    width:  Math.round(width * screen.width)   - 2*padding,
    height: Math.round(height * screen.height) - 2*padding
  });
  return this;
}

Window.prototype.toFullScreen = function() {
  if (lastFrames[this]) {
    this.setFrame(lastFrames[this]);
    this.forgetFrame();
  } else {
    this.rememberFrame();
    return this.toGrid(0, 0, 1, 1);
  }
}

Window.prototype.toTopHalf = function() {
  return this.toGrid(0, 0, 1, 0.5);
}

Window.prototype.toBottomHalf = function() {
  return this.toGrid(0, 0.5, 1, 0.5);
}

Window.prototype.toLeftHalf = function() {
  return this.toGrid(0, 0, 0.5, 1);
}

Window.prototype.toRightHalf = function() {
  return this.toGrid(0.5, 0, 0.5, 1);
}

Window.prototype.rememberFrame = function() {
  lastFrames[this] = this.frame();
}

Window.prototype.forgetFrame = function() {
  delete lastFrames[this];
}

App.byTitle = function(title) {
  var apps = this.runningApps();

  for (i = 0; i < apps.length; i++) {
    var app = apps[i];
    if (app.title() == title) {
      app.show();
      return app;
    }
  }
}

App.prototype.firstWindow = function() {
  return this.visibleWindows()[0];
}

function forApp(name, f) {
  var app = App.byTitle(name);

  if (app) {
    _.each(app.visibleWindows(), f);
  }
}

