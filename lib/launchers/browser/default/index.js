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

    var versionPath = glob.sync(this.directory + "/versions/*").filter(function (fileName) {
      return path.basename(fileName).replace(/\.\w+$/, "") === message.data.version;
    }).pop();


    if (!versionPath) return [];

    var args = toarray(message.data.args);


    return utils.isWindows ?
      ["start", "/WAIT", "\"\"", versionPath, args.join(" ")] :
      ["open", versionPath, "-W", "--args", args.join(" ")]
  }
});

module.exports = DefaultLauncher;