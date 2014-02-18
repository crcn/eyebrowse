var eyebrowse = require("..");

module.exports = function () {

  var eb = eyebrowse();

  eb.launcher(eb._loader = eyebrowse.launchers.local({
    path: "/Users/craig/Developer/browsers/*"
  }));

  eb.decorator(eyebrowse.decorators.copySettings);
  eb.decorator(eyebrowse.decorators.killProcess);
  eb.decorator(eyebrowse.decorators.spawn);

  return eb;
}