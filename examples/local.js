var eyebrowse = require(".."),
eb            = eyebrowse();

eb.launcher(eyebrowse.launchers.local({
  path: "/Users/craig/Developer/browsers/*"
}));

eb.decorator(eyebrowse.decorators.copySettings);

eb.launch({ name: "firefox", version: "6" }, function () {

});