module.exports = {
  fixPath: function (path) {
    return path.replace("~", process.env[(process.platform == 'win32') ? 'USERPROFILE' : 'HOME']).replace(/^\./, process.cwd());
  }
};