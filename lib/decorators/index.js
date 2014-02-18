var protoclass = require("protoclass"),
_              = require("underscore"),
Decorator      = require("./decorator");

function Decorators (eyebrowse) {
  this.eyebrowse   = eyebrowse;
  this._decorators = [];
}

protoclass(Decorators, {

  /**
   */

  add: function (decorator) {
    this._decorators.push(new Decorator(decorator, this));
  },

  /**
   */

  decorate: function (target) { 
    for (var i = this._decorators.length; i--;) {
      var decor = this._decorators[i];
      decor.decorate(target);
    }
  }
});

module.exports = Decorators;

_.extend(module.exports, {

  // copies the settings from the browser directory to 
  // somewhere on the computer
  copySettings: require("./copySettings"),

  // kills browser process on .stop()
  killProcess: require("./killProcess"),

  // spawns browser process
  spawn: require("./spawn")
});