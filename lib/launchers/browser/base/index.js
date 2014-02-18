var BaseLauncher = require("../../base/launcher"),
_                = require("underscore"),
outcome          = require("outcome");


function BaseBrowserLauncher (options) {
  BaseLauncher.call(this, options);

  this.version = options.version;
  this.name    = options.name;
}

BaseLauncher.extend(BaseBrowserLauncher, {

  /**
   */

  stop: function (next) {
    var self = this;
    this.commands.execute("stop", outcome.e(next).s(function () {
      next(null, self);
    }));
  },

  /**
   */

  _stop: function (message, next) {
    next(); // OVERRIDE ME
  },

  /** 
   * copies settings from one directory to another just before
   * launching the browser. This is to maintain the state of a given version,
   * along with any plugins, such as development tools.
   */

  _copySettings: function (message, next) {
    next(); // OVERRIDE ME
  },

  /**
   */

  _setupCommands: function (commands) {
    commands.on("stop", _.bind(this._stop, this));
    commands.on("pre launch", _.bind(this._copySettings, this));
  }
});

module.exports = BaseBrowserLauncher;