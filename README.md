Apuppet is an utility which allows you to easily launch, and control applications from the command line. It was built to launch different browser versions for cross-browser testing.

### Usage

```
  Usage: apuppet [options] [command]

  Commands:

    start <appName> [args] starts an application

  Options:

    -h, --help           output usage information
    -c, --config <path>  apuppet configuration file
```

### Terminal Example

Launching chrome 25

```
apuppet start chrome@25 http://google.com
```

Launching multiple applications:

```
apuppet start chrome@25+firefox@18 http://google.com
```

### Command line examples

### Example

In `/usr/local/etc/apuppet/config.json`

```javascript
{
  "directory": "/path/to/apps/dir"
}
```

Structure of `/path/to/apps/dir`:

`apps/`
  - `chrome/` - application name
    - `index.coffee`  - application driver
    - `versions/` - application driver
      - `10.lnk`
      - `11.lnk`
    - `settings/`
      - `10 11 12/`
  - `safari/`
    - `index.coffee` 
    - `version/`
      - `...`
    - `settings/`
      - `...`

### apuppet API


### apuppet(options)

```javascript
var apuppet = require("apuppet")({
  directory: "./path/to/apps"
});
```

### Array<AppDriver> apuppet.applications

Returns all the loaded applications

### apuppet.start(options) 

Starts an application

### Application Driver API


A basic application driver looks like this:

```coffeescript

class ChromeDriver extends AppDriver
  
  ###
   starts 
  ###

  start: (options, callback) ->
    callback null, new AppProcess @, callback

```


### Application AppDriver.start options, callback
  
`options`
  - `version` - application version to run
  - `args` - arguments to pass to the command line

`callback` - called when the application has successfuly spawned


### Array<AppProcess> AppDriver.running()

Returns the running processes

### Application.stop callback

Stops the application process

### Application.exec options, callback

executes a command against the running process

### Application.restart options

Restarts the application process

### Application.running 

TRUE if the application is running

### Application.on event, callback

Adds an event listener to the application process

`stop` - emitted when the process exits
`start` - emitted when the application starts



module.exports = ChromeDriver


