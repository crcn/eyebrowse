var exec = require("child_process").exec,
utils    = require("../../utils"),
async    = require("async"),
sprintf  = require("sprintf").sprintf;

module.exports = {
  options: function (launcher) {
    return launcher.processNames;
  },
  decorate: function (launcher, processNames) {
    launcher.commands.on("pre launch", function (message, next) {
      async.each(processNames, function (processName, next) {
        var command = utils.usWindows ? sprintf("taskkill /F /IM %s", processName) : sprintf("killall \"%s\" QUIT -9", processName);
        console.log(command);
        exec(command, function () {
          next();
        });
      }, next);
    });
  }
}