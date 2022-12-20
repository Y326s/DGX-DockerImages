#
# XUbuntu Desktop self-loaded Dockerfile
#
# BASE_IMAGE
#

# Pull base image.
ARG BASE_IMAGE=nvcr.io/nvidia/pytorch:22.03-py3
FROM $BASE_IMAGE
LABEL maintainer="Yuchen Jin <cainmagi@gmail.com>" \
      author="Yuchen Jin <cainmagi@gmail.com>" \
      description="xUbuntu desktop dockerfile for ubuntu 16.04, 18.04 and 20.04 images." \
      version="1.7"
ARG BASE_LAUNCH=/opt/nvidia/nvidia_entrypoint.sh
# Since 22.03 ?: /opt/nvidia/nvidia_entrypoint.sh
# Before: /usr/local/bin/nvidia_entrypoint.sh
ARG JLAB_VER=unset
ARG JLAB_EXTIERS=2
ARG WITH_CHINESE="true"
ARG WITH_EXTRA_APPS="cgo"
ARG ADDR_PROXY=unset
ARG DEBIAN_FRONTEND=noninteractive

ENV USER="root" MKL_CBWR="AUTO" LAUNCH_SCRIPT_ORIGINAL="$BASE_LAUNCH" PATH="${PATH}:/usr/games"

# Move configs.
COPY configs /root/docker-configs
RUN chmod +x /root/docker-configs/ --recursive && bash /root/docker-configs/detach MODE=basic
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# Install prepared packages
COPY scripts/install-base /root/scripts/
RUN chmod +x /root/scripts/install-base && bash /root/scripts/install-base MODE=init

# Install xfce4 Desktop
COPY scripts/install-desktop* /root/scripts/
RUN chmod +x /root/scripts/install-desktop && chmod +x /root/scripts/install-desktop-exts && bash /root/scripts/install-desktop MODE=desktop
RUN /etc/init.d/dbus start
RUN bash /root/scripts/install-base MODE=check

# Install extra packages
RUN bash /root/scripts/install-desktop MODE=apps JLAB_VER=${JLAB_VER} JLAB_EXTIERS=${JLAB_EXTIERS}
# The following step is not stable, so we move it here.
RUN bash /root/scripts/install-desktop-exts MODE=vscodelocal USER_ROOT=/home/xubuntu
COPY scripts/install-exapps /root/scripts/
RUN chmod +x /root/scripts/install-exapps && bash /root/scripts/install-exapps EXAPPS=${WITH_EXTRA_APPS} REQAPPS=pae
RUN bash /root/scripts/install-exapps EXAPPS=${WITH_EXTRA_APPS} REQAPPS=gnoa
RUN bash /root/scripts/install-exapps EXAPPS=${WITH_EXTRA_APPS} REQAPPS=ckm
RUN bash /root/scripts/install-exapps EXAPPS=${WITH_EXTRA_APPS} REQAPPS=x
RUN bash /root/docker-configs/detach MODE=shortcuts

# Install modern vncserver and themes
COPY scripts/install-vnc /root/scripts/
RUN bash /root/scripts/install-vnc MODE=vnc
RUN bash /root/scripts/install-vnc MODE=theme

# Define working directory.
RUN bash /root/docker-configs/detach MODE=clean
COPY entrypoints/ /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint && chmod +x /usr/local/bin/user-mapping && chmod +x /usr/local/bin/xvnc-launch && chmod +x /usr/local/bin/fbrowser && chmod +x /usr/local/bin/set-bing-wallpaper && chmod +x /usr/local/bin/yjin-tool

# Expose the built-in ports.
EXPOSE 5212
EXPOSE 5901
EXPOSE 6080

# Define default command.
USER xubuntu
ENV USER="xubuntu"
WORKDIR /home/xubuntu
ENTRYPOINT ["bash", "docker-entrypoint"]
CMD [""]
