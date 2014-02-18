var BaseLauncher = require("../base");

function DefaultLauncher (options) {
  BaseLauncher.call(this, options);
}

BaseLauncher.extend(DefaultLauncher, {

  /**
   */

  _getProcessArguments: function () {
    
  }


});

module.exports = DefaultLauncher;