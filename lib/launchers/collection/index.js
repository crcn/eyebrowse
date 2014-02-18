var BaseLauncher = require("../base/launcher"),
outcome          = require("outcome"),
_                = require("underscore");

function CollectionLauncher (source) {
  BaseLauncher.call(this);
  this._launchers = [];
  (source || []).forEach(_.bind(this.add, this));
}

BaseLauncher.extend(CollectionLauncher, {

  /**
   */

  add: function (launcher) {
    this._launchers.push(launcher);
    this.bind("eyebrowse", { target: launcher, to: "eyebrowse" }).now();
  },

  /**
   */

  _launch: function (message, next) {

    var options = message.data, 
    launchers   = this._launchers.concat();

    function _tryLaunchingNext (e) {

      var launcher = launchers.shift();
      if (!launcher) return next(e);

      launcher.launch(message.data, outcome.e(_tryLaunchingNext).s(function () {
        next([null].concat(Array.prototype.slice.call(arguments, 0)));
      }));
    }

    _tryLaunchingNext();
  }
});

module.exports = CollectionLauncher;