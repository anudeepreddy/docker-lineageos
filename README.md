docker-lineageos
==================

Create a [Docker] based environment to build [LineageOS].

This Dockerfile will create a docker container which is based on Ubuntu 16.04.
It will install the "repo" utility and any other build dependencies which are required to compile LineageOS (formerly known as CyanogenMod).

The main working directory is a shared folder on the host system, so the Docker container can be removed at any time.

**NOTE:** Remember that LineageOS is a huge project. It will consume a large amount of disk space (~80 GB) and it can easily take hours to build.

### How to run

**NOTES:**
* You will need to [install Docker][Docker_Installation] to proceed!

### How to build LineageOS for your device

```
docker run -d --name lineageos -v ./android:/home/build/android:z -v ./ccache:/srv/ccache:z -e GITUSER="Your Name" -e GITMAIL="you@exeample.com" -e PRODUCT="terminalcodename" anthodingo/docker-lineageos:autobuild
```

or with compose
```
docker-compose up -d
```

### Variables


| Variable | Description | Type | Default value | Example |
| -------- | ----------- | ---- | ------------- | ------- |
| **GITUSER** | Username for git | *Required* | | Your Name
| **GITMAIL** | User email for git | *Required* | | you@example.com
| **PRODUCT** | Terminal code name | *Required* | | shamu
| **BRANCH** | LineageOS Branch | *optional* | cm-14.1 |
| **REPO** | Change OTA server url | *optional* | https://download.lineageos.org/api

### Links

For further information, check the following links:

* [Build Instructions for Google Nexus 6][LineageOS_Build_Nexus_6] (example device, search the wiki for other devices)
* [Creatre your own OTA update server][Own_OTA_Update_Server]
### More information

* [Discussion thread @ XDA developers]

==================

[Docker]:                      https://www.docker.io/
[LineageOS]:                   http://lineageos.org/
[Docker_Installation]:         https://www.docker.io/gettingstarted/
[Screen_Shortcuts]:            http://www.pixelbeat.org/lkdb/screen.html
[LineageOS_Build_Nexus_6]:    http://wiki.lineageos.org/devices/shamu/build
[Own_OTA_Update_Server]:    https://github.com/julianxhokaxhiu/LineageOTA
[Discussion thread @ XDA developers]: http://forum.xda-developers.com/showthread.php?t=2650345
[dotcloud/docker#2224]:        https://github.com/dotcloud/docker/issues/2224
