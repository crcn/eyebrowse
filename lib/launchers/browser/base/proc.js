var BaseLauncher = require("./"),
_                = require("underscore"),
spawn            = require("spawn");


function ProcLauncher (options) {
  BaseLauncher.call(this, options);
}

BaseLauncher.extend(ProcLauncher, {

  /**
   */

  _stopProcess: function (message, next) {
    if (!this._process) return next();
    this._process.once("exit", function () {
      next();
    });
    this._process.kill();
  },

  /**
   */

  _startProcess: function (message, next) {
    this._process = this._createProcess(message);
    var self = this;
    this._process.once("exit", function () {
      self._process = undefined;
    })
    next();
  },

  /**
   */

  _createProcess: function (message) {
    // OVERRIDE ME
    var args = this._getProcessArguments(message);
    return spawn(args.shift(), args);
  },

  /**
   */

  _getProcessArguments: function (message) {
    return [];
  }

  /**
   */

  _setupCommands: function (commands) {
    commands.pre("pre stop", _.bind(this._stopProcess, this));
    commands.pre("pre launch", _.bind(this._startProcess, this));
  }
});

module.exports = ProcLauncher;