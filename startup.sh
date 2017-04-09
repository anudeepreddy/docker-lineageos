#!/bin/sh

# Initialize ccache if needed
if [ ! -f /srv/ccache/ccache.conf ]; then
	echo "============================================"
	echo "Initializing ccache in /srv/ccache..."
	echo "============================================"
	CCACHE_DIR=/srv/ccache ccache -M 50G
fi

export USER="build"
export PATH=$PATH:/home/build/bin

if [ -z $GITUSER ]; then
		echo "============================================"
        echo "Git user name is not define. Example : Your Name"
		echo "============================================"
        exit 1
fi

if [ -z $GITMAIL ]; then
		echo "============================================"
        echo "Git user mail is not defined. Example : you@example.com."
		echo "============================================"
        exit 1
fi

if [ -z $PRODUCT ]; then
		echo "============================================"
        echo "Env PRODUCT is not defined."
		echo "============================================"
        exit 1
fi

git config --global user.name $GITMAIL
git config --global user.email $GITMAIL

#Skip color with repo command
git config --global color.ui false

if [ -z $BRANCH ]; then
        BRANCH="cm-14.1"
fi

echo "============================================"
echo "Sync repository ..."
echo "============================================"
repo init -u git://github.com/LineageOS/android.git -b cm-14.1
#Sync repo
repo sync

echo "============================================"
echo "Setup env"
echo "============================================"
#Fix Source
source build/envsetup.sh
breakfast $PRODUCT

export USE_CCACHE=1

#Fix Jack out of memory
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

if [ -n $REPO ]; then
		echo "============================================"
        echo "Replacing OTA server"
		echo "============================================"
        sed -i "s,https://download.lineageos.org/api,$REPO,g" packages/apps/CMUpdater/res/values/config.xml
fi

echo "============================================"
echo "Starting build ..."
echo "============================================"
croot
brunch $PRODUCT

if [ -n $POSTBUILD ]; then
	exec $POSTBUILD
fi

exit 0