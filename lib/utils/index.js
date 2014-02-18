var isWindows = /^win/.test(process.platform);

module.exports = {
  isWindows: isWindows,
  fixPath: function (path) {
    return path.replace("~", process.env[isWindows ? 'USERPROFILE' : 'HOME']).replace(/^\./, process.cwd());
  }
};