var BaseLauncher = require("../base/launcher"),
_                = require("underscore"),
memoize          = require("memoizee"),
outcome          = require("outcome"),
flatten          = require("flatten"),
glob             = require("glob"),
async            = require("async"),
utils            = require("../../utils"),
browserLaunchers = require("../browser"),
sift             = require("sift"),
Launchers        = require("../collection"),
path             = require("path");

/**
 * loads browsers from a specific directory
 */

function LocalLauncher (options) {
  BaseLauncher.call(this, options);
  this._load = memoize(_.bind(this._load, this), { expire: false });
}

BaseLauncher.extend(LocalLauncher, {

  /**
   */

  getBrowsers: function (next) {
    var self = this;
    this._load({}, function () {
      self._launchers.getBrowsers(next);
    });
  },

  /**
   */

  _launch: function (message, next) {
    this._launchers.launch(message.data, next);
  },

  /**
   */

  _setupCommands: function (commands) {
    BaseLauncher.prototype._setupCommands.call(this, commands);
    commands.on("pre launch", this._load);
  },

  /**
   */

  _load: function (message, next) {

    var self = this;

    async.waterfall([

      // scan the directory for config files
      function (next) {
        glob(utils.fixPath(self.path), next);
      },

      // load all the versions
      function (configPaths, next) {
        next(null, flatten(configPaths.map(function (configPath) {

          var config = require(configPath);

          return glob.sync(configPath + "/versions/*").map(function (vp) {
            return _.extend(JSON.parse(JSON.stringify(config)), {
              version     : path.basename(vp).replace(/\.\w+$/, ""),
              versionPath : vp
            });
          });

        })))
      },

      // instantiate the launchers with the option
      function (versionConfigs, next) {
        next(null, versionConfigs.map(function (versionConfig) {
          var clazz = browserLaunchers[versionConfig.name] || browserLaunchers.default;
          return new clazz(versionConfig);
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