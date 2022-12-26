# Dockerfile Collection for DGX-230

## XUbuntu

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
docker build -t xubuntu:1.8 https://github.com/Y326s/DGX-DockerImages.git#xUbuntu_YL
```

This image is compatible for Ubuntu 16.04, 18.04 and 20.04. Please check your base image and confirm that the Ubuntu inside the image is compatible with this dockerfile.

We provide 3 examples:

* Start from `pytorch 1.14.0a` image:

  ```bash
  docker build -t xubuntu-tc:1.8 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:22.12-py3 --build-arg BASE_LAUNCH=/opt/nvidia/nvidia_entrypoint.sh https://github.com/Y326s/DGX-DockerImages.git#xUbuntu_YL
  ```

* Start from `cuda 11.8` image:

  ```bash
  docker build -t xubuntu-cuda:1.8 --build-arg BASE_IMAGE=nvcr.io/nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04 --build-arg BASE_LAUNCH="" https://github.com/Y326s/DGX-DockerImages.git#xUbuntu_YL
  ```

* Start from `tensorflow 1.13.1` image:

  ```bash
  docker build -t xubuntu-tf:1.8 --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.03-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh https://github.com/Y326s/DGX-DockerImages.git#xUbuntu_YL
  ```

There are 3 available options:

| Option  | Description | Default |
| :-----: | ----------- | ------- |
| `BASE_IMAGE` | The base image for building this desktop image. | `nvcr.io/nvidia/pytorch:22.12-py3` |
| `BASE_LAUNCH` | The entrypoint script from the base image. If there is no entry script, please use`""`. | `/opt/nvidia/nvidia_entrypoint.sh` |
| `WITH_CHINESE` | If set, the image would be built with Chinese support for vscode, sublime and codeblocks. | `true` |
| `WITH_EXTRA_APPS` | The installed extra applications. Each character represents an app or several apps. For example,`cgo` represents fully installing `Cloudreve`, `GIMP`, `LibreOffice` and `Thunderbird`. More details could be referred in the following table. | `cgo` |
| `ADDR_PROXY` | Set the proxy address pointing to `localhost`. If specified, this value should be a full address. (Experimental feature ::) | `unset` |

Here we show the list of extra apps:

|  Code   | Description |
| :-----: | ----------- |
| `c` | [`Cloudreve`][link-cloudreve] |
| `p` | [`PyCharm`][link-pycharm] |
| `g` | [`GIMP`](https://www.gimp.org/downloads) |
| `k` | [`GitKraken`][link-gitkraken] |
| `m` | [`Sublime Text 4`][link-sublime-text] |
| `x` | [`TeXLive`](https://tug.org/texlive) + [`TeXstudio`](https://www.texstudio.org) |
| `n` | [`Nautilus`](https://github.com/GNOME/nautilus) + [`Nemo`](https://github.com/linuxmint/nemo) |
| `o` | [`LibreOffice`](https://www.libreoffice.org) + [`Thunderbird`](https://www.thunderbird.net) |
| `e` | [`GNU Emacs`](https://www.gnu.org/software/emacs/download.html#gnu-linux) |

To find your launch script of your base image, use

```bash
docker inspect <your-base-image>:<tag>
```

### Offline building

Otherwise, you need to clone the branch firstly:

```Bash
git clone --single-branch -b xUbuntu_YL https://github.com/Y326s/DGX-DockerImages.git xUbuntu_YL
```

After that, run such command to build the image:

```Bash
docker build -t xubuntu:1.8 xUbuntu_YL
```

where `xUbuntu_YL` is the folder of the corresponding branch. The options in online building examples could be also used for offline buliding.

### Launching

> When launching the image for the first time, please use the following command to configure your user id and VNC password.
> When you use this image for the first time, please configure your user id by:
>
> ```bash
> docker run --gpus all -it --rm xubuntu:1.8 uid=$(id -u) gid=$(id -g)
> ```
>
> Then commit the image by
>
> ```bash
> docker commit --change='CMD [""]' <conatiner-id> xubuntu:1.8
> ```

* By built-in `noVNC`: In default mode, you just need to launch the built image by:

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 6080:6080 xubuntu:1.8
  ```

  It is equivalent to use `--vnc` or not in the above command. However, if you have saved the image in other modes before, you may need this flag to force the image to enter the VNC mode. The `--vnc` option is required when you need to force the image to switch to VNC mode. The following command would force the `vnc` launched by `root` mode.

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 6080:6080 xubuntu:1.8 --root
  ```

  In current version, users could use either `http` to get access to the unencrypted noVNC session or `https` to get access to the ssl-encrypted noVNC session. For users who open the encrypted session firstly, they may need to add the noVNC site into the trusted list.

* Switch the VNCServer to `XTigerVNC` (experimental): Add the option `--xvnc` will make the desktop hosted by the `Xvnc` program. Everything will be run in the same process. There will be no sub-process manager like `tigervncserver` to manage desktop related programs. A good thing is that, users do not need to run `tigervncserver -kill :1` before saving the image. However, currently these desktop related programs are not guaranteed to be closed if hitting <kbd>Ctrl</kbd>+<kbd>C</kbd>. Therefore, we suggest the users to use `ps -aux` to validate the running processes before saving the image.

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.8 --xvnc
  ```

  Certainly, there is also a root mode for this method:

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.8 --rootxvnc
  ```

  After using <kbd>Ctrl</kbd>+<kbd>C</kbd> to kill the `Xvnc` program, users can use the following command to relaunch the `Xvnc` and `noVNC` services:

  ```bash
  xvnc-launch [--root]
  ```

  If adding the option `--root`, the desktop will be run with root privilege.

* By external VNC viewer (client): If you have installed a VNC viewer on your client side, and want to connect the VNC server of the image directly, please use:

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 5901:5901 xubuntu:1.8
  ```

  The `root` mode could be also applied here.

* By `BASH`: If you want to enter the command line but do not start the desktop, please use

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal xubuntu:1.8 --bash
  ```

* By any script: If you want run any script inside the docker for only one time, please use

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal xubuntu:1.8 script=<the-path-to-your-script>
  ```

* With [`Cloudreve` :link:][link-cloudreve]: We recommend users to launch `Cloudreve` by opening a new terminal on the desktop, and using the following command:

  ```bash
  crpasswd  # only used for checking the INITIAL admin password.
  cloudreve  # launch Cloudreve service, requires users to expose 5212 port.
  ```

  > :warning: Using `Cloudreve` requires users to add the extra app `c` in the option `WITH_EXTRA_APPS` when building the image.

  > :warning: We **STRONGLY** recommend users to change their admin password, and create a non-admin user for using `Cloudreve`. You can also configure your data exchanging folder.

  After launching the app, users can get access to `Cloudreve` by `<dgx-ip>:5212` port. Remember to expose the port number by `-p 5212:5212` when launching the container.

  If users have configured `Cloudreve` by the webpage, and commit the image. Then the users can launch the container only with `Cloudreve` (not opening the desktop):

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 5212:5212 xubuntu:1.8 --cloudreve --bash
  ```

  or launch `Cloudreve` together with the desktop:

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 5212:5212 xubuntu:1.8 --cloudreve
  ```

  Cloudreve will show you a lot of logs on the terminal, it may interfere the messages from `Xvnc` or `noVNC`. So we **do not** recommend to launch it together with the desktop. It is always better if you open a terminal on the desktop and use the `cloudreve` command.

* With [`FileBrowser` :link:][link-filebrowser]: We recommend users to launch `filebrowser` by opening a new terminal on the desktop, and using the following command:

  ```bash
  fbrowser  # although users can use filebrowser to launch the app, we still recommend users to use this command, because this command can configure the IP and PORT number automatically.
  ```

  > :warning: We **STRONGLY** recommend users to change the initial admin password, and keep the modified password by themselves.

  After launching the app, users can get access to `FileBrowser` by `<dgx-ip>:5212` port. Remember to expose the port number by `-p 5212:5212` when launching the container.

  Similarly, the users can also launch `FileBrowser` by adding the option `--filebrowser` when launching the container. The usage is exactly the same as `Cloudreve`.

  > :warning: Note that `Cloudreve` should not be launched together with `FileBrowser`, unless you have carefully configured the launching scripts and understood what you want to do.

## Features

This is the minimal desktop test based on `ubuntu` `16.04`, `18.04` or `20.04` image, it has:

* **Fully installed xfce4 desktop**: it has most of the useful plug-ins for xfce4 desktop. While libreoffice and texlive are **not** installed.
* **Fully inherit the base image**: some base image may already have the entrypoint script. We provide options for including the the entry-script of base image.
* **Modern VNC server**: it contains [tigervncserver][tigervnc], which is a modern VNC server and could provide more features than tightvncserver and vnc4server, like cutomizing display settings, fully implemented animated cursor and shadow effects.
* **Compatible for multiple Ubuntu versions**: including Ubuntu 16.04, 18.04 and 20.04.
* **Useful apps**: including nomacs, notepadqq, visual studio code, peazip, okular, smplayer and chrome.
* **Multiple launching method**: including VNC server, bash and arbitrary script mode.
* **Chinese language support**: for some apps including edge, chrome (chromium), firefox, vscode, kate, codeblocks, ...
* [**Cloudreve Service (Chinese only)** :link:][link-cloudreve]: a private cloud storage service, allowing users to expose their personal folder as an "online drive" available on LAN. If users are interested, they can dig into the configurations and enable more features (like WebDAV and offline downloading). Currently this feature is designed for using a browser-based app to replace the WinSCP client.
* [**FileBrowser Service** :link:][link-filebrowser]: an alternative of `Cloudreve`. It supports multi-language and is more flexible for exchanging files with a single server. Although it does not support so many online drive features like `Cloudreve`, with `FileBrowser`, users can upload / download files, share links, and even run commands (need to be added to the whitelist) easily.
* **Extra scripts**: we also provide some extra scripts for compiling specific libraries (like `ffmpeg` and `gcc`). These files will be convenient examples for users who want extra features.

## Update records

### ver 1.8 @ 12/26/2022

#### Update

1. Update the TigerVNC server installation package.
2. Update optional application list (Atom is no longer maintained).
3. Update the `yjin-tool`.

#### New

1. Change default `UID` and `GID` inside the docker image to the same ones as the builder.
2. Manually install `dconf-cli` on 18.04 ubuntu to manage mousepad default configuration file.
3. Manually add several environment variables acquired by Matplotlib and unset 2 `$SESSION_MANAGER` environment variables created by ICE to avoid a warning when using Matplotlib.

#### Delete

1. Remove all JupyterLab installation process and dependencies.
2. Temporarily disable `vscodelocal` mode when installing VScode extensions.
3. Disable the screensaver as the default setting.
4. Remove `hookyqr.beautify` and install `python-kaleido` only on python version 37+ for VSCode extensions.

#### Debug

1. Fix the bug in `/etc/shinit` that would unexpectly run a `rm /lib` command in 16.04 NVIDIA base image.

[tigervnc]:https://github.com/TigerVNC/tigervnc

[link-pycharm]:https://www.jetbrains.com/help/pycharm/installation-guide.html
[link-gitkraken]:https://www.gitkraken.com
[link-sublime-text]:https://www.sublimetext.com/
[link-cloudreve]:https://cloudreve.org/
[link-filebrowser]:https://filebrowser.org/
