# HRLibrary V1
- How can you develop scripts without knowing script functions?

## Installation
1. Download the dependency
    - Download [HRNotify](https://github.com/HRScripts/HRNotify) and move it to your resources folder
    - Write `start HRNotify` in your `server.cfg` file
2. Download the script
    - Download the script and then move it from the archite to your resources folder
    - Write `start HRLib` in your `server.cfg` file under the row `start HRNotify` (it is very important to be under the row that starts HRNotify!!!!)
    - Configurate it
 
## Take a look of the configuration file (config.lua)
```lua
Config = {}

Config.DefaultWebHook = 'https://discord.com/api/webhooks/********************' -- Default webhook URL for the `HRLib.DiscordMsg` function (not required)
```


## How can you develop scripts without knowing script functions?
- Go to our [documentation](https://hrscripts.gitbook.io/hrscripts-documentation) site
