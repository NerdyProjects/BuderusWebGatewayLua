# Simple Buderus KM100 reader
This folder is a proof of concept on how to read the KM100 buderus heating system gateway within lua.
The script should be able to run on OpenWRT with lua, lua-openssl and lua-socket packages installed.

## Configuration
Copy `config.lua.sample` to `config.lua` and add your settings.

## Cronjob
I use this to log data as CSV. A cronjob works perfectly:
`lua get_buderus.lua | grep -v '#' >> /path/to/logfile`
