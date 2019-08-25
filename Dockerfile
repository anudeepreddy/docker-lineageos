# Build environment for LineageOS

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -qqy upgrade

# Install build dependencies (source: https://wiki.cyanogenmod.org/w/Build_for_bullhead)
RUN apt-get install -y bison build-essential curl flex git gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop maven openjdk-8-jdk pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev

# For 64-bit systems
RUN apt-get install -y g++-multilib gcc-multilib lib32ncurses5-dev lib32readline6-dev lib32z1-dev

# Install additional packages which are useful for building Android
RUN apt-get install -y ccache rsync tig sudo imagemagick
RUN apt-get install -y android-tools-adb android-tools-fastboot
RUN apt-get install -y bc bsdmainutils file screen
RUN apt-get install -y bash-completion wget nano

RUN useradd gitpod && rsync -a /etc/skel/ /workspace/docker-lineageos/

RUN mkdir /workspace/docker-lineageos/bin
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /workspace/docker-lineageos/bin/repo
RUN chmod a+x /workspace/docker-lineageos/bin/repo

# Add sudo permission
RUN echo "gitpod ALL=NOPASSWD: ALL" > /etc/sudoers.d/gitpod

ADD startup.sh /workspace/docker-lineageos/startup.sh
RUN chmod a+x /workspace/docker-lineageos/startup.sh

# Fix ownership
RUN chown -R gitpod:gitpod /workspace/docker-lineageos

# Set global variables
ADD android-env-vars.sh /etc/android-env-vars.sh
RUN echo "source /etc/android-env-vars.sh" >> /etc/bash.bashrc

VOLUME /workspace/docker-lineageos/android
VOLUME /srv/ccache

CMD /workspace/docker-lineageos/startup.sh

USER gitpod
WORKDIR /workspace/docker-lineageos/android
