module.exports = {
  test: function (launcher) {
    return launcher.copyFiles;
  },
  decorate: function (launcher) {
    console.log("DECIT");
  }
}