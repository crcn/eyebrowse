var BaseLauncher = require("../base"),
utils            = require("../../../utils"),
sprintf          = require("sprintf").sprintf,
toarray          = require("toarray"),
path             = require("path"),
glob             = require("glob");

function DefaultLauncher (options) {
  BaseLauncher.call(this, options);
}

BaseLauncher.extend(DefaultLauncher, {

  /**
   */

  _getProcessArguments: function (message) {

    var args = toarray(message.data.args);


    return utils.isWindows ?
      ["start", "/WAIT", "\"\"", this.versionPath, args.join(" ")] :
      ["open", this.versionPath, "-W", "--args", args.join(" ")]
  }
});

module.exports = DefaultLauncher;