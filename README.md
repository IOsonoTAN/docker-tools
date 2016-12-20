## Docker tools
The one line shell script to building and running a docker container that related with Dockerfile using Node.js.

### Features
- Git reset and clean everything before.
- Create a docker image and running a container.
- Just one line!

### What this script need.
- Node.js
- Node package manager (NPM)
- Docker
- Dockerfile

### Get started
- Create a new folder named "map-config".
- Create a new node.js file named "index.js" in map-config's folder.
~~~javascript
# index.js
'use strict'
const fs = require('fs');
const config = require('./config');
const sprintf = require('sprintf-js').sprintf;
const envTemplatePath = process.argv.slice(2)[0];
if (envTemplatePath[0] === '%') {
  sprintf(envTemplatePath, config);
} else {
  const template = fs.readFileSync(envTemplatePath).toString();
  sprintf(template, config);
}
~~~
- Create a new config named "config.json" in JSON format.
- Replace values into JSON, It depend on you design (Below is example json).
~~~json
{
  "debug": "*",
  "app": {
    "port": "3000"
  },
  "password": {
    "salt": "!+_)@@GGWP#"
  }
}
~~~
- Create .env_template in root project.
- Repalce value into .env_template by json calling (Below is example .env_template).
~~~json
DEBUG=%(debug)s
PORT=%(app.port)s
PASSWORD_SALT=%(password.salt)s
~~~
- Go to project's folder
- Create Dockerfile
~~~json
sh docker_deploy.sh
~~~
- Enjoy your docker container!