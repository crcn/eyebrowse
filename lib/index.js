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

  getBrowsers: function (next) {
    this._launchers.getBrowsers(next);
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

    var nameParts   = options.name.split("@");
    options.name    = nameParts.shift();
    options.version = nameParts.shift() || options.version;

    this._launchers.launch(options, next || function () { });
  },
});

module.exports = function () {
  return new Eyebrowse();
}


module.exports.launchers  = require("./launchers");
module.exports.decorators = require("./decorators");