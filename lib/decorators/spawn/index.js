var spawn = require("child_process").spawn,
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

      console.log(args.join(" "));

      launcher.set("process", proc = spawn(args.shift(), args));

      proc.stdout.pipe(process.stdout);
      proc.stderr.pipe(process.stderr);

      proc.on("exit", function () {
        launcher.set("process", undefined);
      });

      next();
    });
  }
}