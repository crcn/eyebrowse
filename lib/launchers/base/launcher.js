var bindable = require("bindable"),
mediocre     = require("mediocre"),
_            = require("underscore"),
outcome      = require("outcome");


function BaseLauncher (options) {
  bindable.Object.call(this, this);
  this._setupCommands(this.commands = mediocre());
  this.setProperties(options);

  this.bind("eyebrowse", _.bind(this._initialize, this)).now();
}

bindable.Object.extend(BaseLauncher, {

  /**
   */

  launch: function (query, next) {
    var self = this;
    this.commands.execute("launch", query, outcome.e(next).s(function () {
      next(null, self);
    }));
  },

  /**
   */

  _initialize: function (eyebrowse) {
    if (!eyebrowse) return;
    eyebrowse.decorators.decorate(this);
  },

  /**
   */

  _launch: function (message, next) {
    // override me
  },

  /**
   */

  _setupCommands: function (commands) {
    commands.on("launch", _.bind(this._launch, this));
  }
});

module.exports = BaseLauncher;