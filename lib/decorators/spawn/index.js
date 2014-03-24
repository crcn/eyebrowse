var spawn = require("child_process").spawn,
exec      = require("child_process").exec,
toarray   = require("toarray");

module.exports = {
  options: function (launcher) {
    return launcher._getProcessArguments;
  },
  decorate: function (launcher) {

    launcher.commands.on("launch", function (message, next) {

      var args = toarray(launcher._getProcessArguments(message)).concat(),
      proc;

      if (!args.length) {
        return next(new Error("cannot find browser " + message.data.name + "@" + message.data.version));
      }

      var proc = exec(args.join(" "));

      launcher.set("process", proc);
      proc.stdout.pipe(process.stdout);
      proc.stderr.pipe(process.stderr);

      proc.on("exit", function () {
        launcher.set("process", undefined);
      });

      next();
    });
  }
}