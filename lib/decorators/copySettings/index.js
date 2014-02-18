
var utils = require("../../utils"),
toarray   = require("toarray"),
async     = require("async"),
dirmr     = require("dirmr"),
fs        = require("fs"),
path      = require("path"),
rmdir     = require("rmdir");

module.exports = {

  /**
   */

  options: function (launcher) {
    return launcher.copySettings;
  },

  /**
   */

  decorate: function (launcher, options) {

    var copySettings = toarray(options).map(function (ops) {
      return {
        from : utils.fixPath(ops.from),
        to   : utils.fixPath(ops.to)
      }
    });
    

    launcher.commands.on("pre launch", function (message, next) {

      var query = message.data,
      version   = query.version;

      async.eachSeries(copySettings, function (options, next) {

        // skip if tester & fails
        if (options.test && !options.test(query)) return next();

        // might be directories - find them!
        var from = fs.readdirSync(options.from).filter(function (name) {
          return ~name.split(" ").indexOf(version);
        }).map(function (name) {
          return path.join(options.from, name, path.basename(options.to));
        });

        // no settings? skip
        if (!from.length) return next();

        console.log("rm -rf %s", options.to);

        rmdir(options.to, function () {
          console.log("copy %s -> %s", from.join(", "), options.to);
          dirmr(from).
            join(options.to).
            complete(function() { 
              next(); 
            });
        });

      }, next);
    });
  }
}