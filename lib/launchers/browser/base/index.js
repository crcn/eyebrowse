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

  isBrowserLauncher: true,

  /**
   */

  launch: function (options, next) {

    if (options.name !== this.name) {
      return next(new Error("wrong browser"));
    }

    BaseLauncher.prototype.launch.apply(this, arguments);
  },

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
   */

  _setupCommands: function (commands) {
    BaseLauncher.prototype._setupCommands.call(this, commands);
    commands.on("stop", _.bind(this._stop, this));
  }
});

module.exports = BaseBrowserLauncher;