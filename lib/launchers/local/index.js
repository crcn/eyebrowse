var BaseLauncher = require("../base/launcher"),
_                = require("underscore"),
memoize          = require("memoizee"),
outcome          = require("outcome"),
glob             = require("glob"),
async            = require("async"),
browserLaunchers = require("../browser"),
sift             = require("sift"),
Launchers        = require("../collection");

/**
 * loads browsers from a specific directory
 */

function LocalLauncher (options) {
  BaseLauncher.call(this, options);
}

BaseLauncher.extend(LocalLauncher, {

  /**
   */

  _launch: function (message, next) {
    this._launchers.launch(message.data, next);
  },

  /**
   */

  _setupCommands: function (commands) {
    BaseLauncher.prototype._setupCommands.call(this, commands);
    commands.on("pre launch", memoize(_.bind(this._load, this), { expire: false }));
  },

  /**
   */

  _load: function (message, next) {

    var self = this;

    async.waterfall([

      // scan the directory for config files
      function (next) {
        glob(self.path, next);
      },

      // instantiate the launchers with the option
      function (configPaths, next) {
        next(null, configPaths.map(require).map(function (options) {
          var clazz = browserLaunchers[module.name] || browserLaunchers.default;
          return new clazz(options);
        }));
      }

    ], outcome.e(next).s(function (launchers) {
      self._launchers = new Launchers(launchers);
      self.bind("eyebrowse", { target: self._launchers, to: "eyebrowse" }).now();
      next();
    }));
  }
});

module.exports = function (options) {
  return new LocalLauncher(options);
};