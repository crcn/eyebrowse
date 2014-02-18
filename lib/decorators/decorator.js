var protoclass = require("protoclass");

function Decorator (options) {
  this._options = options;
}

protoclass(Decorator, {

  /**
   */

  decorate: function (target) {

    var ops;
    if (!(ops = this._options.options(target))) {
      return false;
    }

    this._options.decorate(target, ops);

    return true;
  }
});

module.exports = Decorator;