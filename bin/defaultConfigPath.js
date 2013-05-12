var os = require("os");

module.exports = os.type() == "Windows_NT" ? "C:\\ProgramData\\eyebrowse\\config" : "/usr/local/etc/eyebrowse/config"