### 
 starts an EC2 instance
###

exports.client = () =>
  (launcher) =>
    launcher.pre "load", (next) => 
      console.log "OK"
      next()
