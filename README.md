# fivem-idlogs
Log FiveM user information in a SQL database when the player connects

# What does it log?
- Steam id 64 in hex
- Rockstar license
- IPV4
- Last connection time
- Steam name
- RP name

# Installation
- Clone the project
- Add it to your `start` config file
- Import `fivem-idlogs.sql` to your database

# Requirements
- [esx_identify_es5](https://github.com/ArkSeyonet/esx_identity_es5) (thus es_extended, ES, etc)
- [fivem-mysql-async](https://github.com/brouznouf/fivem-mysql-async)
