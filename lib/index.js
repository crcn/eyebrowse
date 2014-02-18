var protoclass = require("protoclass"),
Decorators     = require("./decorators"),
Launchers      = require("./launchers/collection");

function Eyebrowse () {
  this.decorators  = new Decorators(this);
  this._launchers  = new Launchers();
  this._launchers.set("eyebrowse", this);
}

protoclass(Eyebrowse, {

  /**
   */

  use: function () {
    for (var i = arguments.length; i--;) {
      arguments[i](this);
    }
  },

  /**
   */

  decorator: function (decorator) {
    this.decorators.add(decorator);
  },

  /**
   */

  launcher: function (launcher) {
    this._launchers.add(launcher);
  },

  /**
   */

  launch: function (options, next) {
    this._launchers.launch(options, next);
  },
});

module.exports = function () {
  return new Eyebrowse();
}


module.exports.launchers  = require("./launchers");
module.exports.decorators = require("./decorators");