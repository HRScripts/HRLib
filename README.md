# HRLibrary V1
- A library script that is needed for all our resources as well as a script to make it easier for others to write by providing functions that will optimize your scripts.

## Installation
    - Download the dependency [HRNotify](https://github.com/HRScripts/HRNotify) and move it to your resources folder
    - Configure the dependency [HRNotify](https://github.com/HRScripts/HRNotify)
    - Write `start HRNotify` in your `server.cfg` file
    - Download HRLib and move it to your resources folder
    - Write `start HRLib` in your `server.cfg` file below the row `start HRNotify` (it is very important to be below the row that starts HRNotify)
    - Configurate it
 
## Take a look of the configuration file (config.lua)
```lua
Config = {}

Config.DefaultWebHook = 'https://discord.com/api/webhooks/********************' -- Default webhook URL for the `HRLib.DiscordMsg` function (not required)
```


## How can you develop scripts without knowing script functions?
- Go to our [documentation](https://hrscripts.gitbook.io/hrscripts-documentation) site
