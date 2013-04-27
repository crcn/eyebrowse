var puppet = require("puppet")({
  drivers: [
    new BrowserTapDriver(),
    new DirectoryDriver()
  ]
})