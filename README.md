# Dockerfile Collection for DGX-230

## XUbuntu

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
docker build -t xubuntu:1.7 https://github.com/cainmagi/Dockerfiles.git#xubuntu
```

This image is compatible for Ubuntu 16.04, 18.04 and 20.04. Please check your base image and confirm that the Ubuntu inside the image is compatible with this dockerfile.

We provide 3 examples:

* Start from `pytorch 1.12.0a` image:

  ```bash
  docker build -t xubuntu-tc:1.7 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:22.03-py3 --build-arg BASE_LAUNCH=/opt/nvidia/nvidia_entrypoint.sh --build-arg JLAB_VER=3 https://github.com/cainmagi/Dockerfiles.git#xubuntu
  ```

* Start from `cuda 11.6` image:

  ```bash
  docker build -t xubuntu-cuda:1.7 --build-arg BASE_IMAGE=nvcr.io/nvidia/cuda:11.6.2-cudnn8-runtime-ubuntu20.04 --build-arg BASE_LAUNCH="" --build-arg JLAB_VER=3 https://github.com/cainmagi/Dockerfiles.git#xubuntu
  ```

* Start from `tensorflow 1.13.1` image (since it is a Python 3.5 image, we recommend to fall back to Jupyter Lab 2.x):

  ```bash
  docker build -t xubuntu-tf:1.7 --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.03-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=2 https://github.com/cainmagi/Dockerfiles.git#xubuntu
  ```

There are 3 available options:

| Option  | Description | Default |
| :-----: | ----------- | ------- |
| `BASE_IMAGE` | The base image for building this desktop image. | `nvcr.io/nvidia/pytorch:22.03-py3` |
| `BASE_LAUNCH` | The entrypoint script from the base image. If there is no entry script, please use`""`. | `/opt/nvidia/nvidia_entrypoint.sh` |
| `JLAB_VER` | The version of the Jupyter Lab to be installed. Could be`1`, `2`, `3` or `unset`. If use `unset`, nothing would be installed if there is already a Jupyter Lab. | `unset` |
| `JLAB_EXTIERS` | The to-be-installed extra extensions for the Jupyter Lab. If`JLAB_VER` is `unset`, nothing would be installed. To view details about which extensions would be installed, see [here](https://github.com/cainmagi/Dockerfiles/tree/jupyterlab#features). | `2` |
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
| `a` | [`Atom`](https://flight-manual.atom.io/getting-started/sections/installing-atom) + [`Nuclide`](https://nuclide.io/docs/editor/setup) |
| `e` | [`GNU Emacs`](https://www.gnu.org/software/emacs/download.html#gnu-linux) |

To find your launch script of your base image, use

```bash
docker inspect <your-base-image>:<tag>
```

### Offline building

Otherwise, you need to clone the branch firstly:

```Bash
git clone --single-branch -b xubuntu https://github.com/cainmagi/Dockerfiles.git xubuntu
```

After that, run such command to build the image:

```Bash
docker build -t xubuntu:1.7 xubuntu
```

where `xubuntu` is the folder of the corresponding branch. The options in online building examples could be also used for offline buliding.

### Launching

> When launching the image for the first time, please use the following command to configure your user id and VNC password.
> When you use this image for the first time, please configure your user id by:
>
> ```bash
> docker run --gpus all -it --rm xubuntu:1.7 uid=$(id -u) gid=$(id -g)
> ```
>
> Then commit the image by
>
> ```bash
> docker commit --change='CMD [""]' <conatiner-id> xubuntu:1.7
> ```

* By built-in `noVNC`: In default mode, you just need to launch the built image by:

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 6080:6080 xubuntu:1.7
  ```

  It is equivalent to use `--vnc` or not in the above command. However, if you have saved the image in other modes before, you may need this flag to force the image to enter the VNC mode. The `--vnc` option is required when you need to force the image to switch to VNC mode. The following command would force the `vnc` launched by `root` mode.

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 6080:6080 xubuntu:1.7 --root
  ```

  In current version, users could use either `http` to get access to the unencrypted noVNC session or `https` to get access to the ssl-encrypted noVNC session. For users who open the encrypted session firstly, they may need to add the noVNC site into the trusted list.

* Switch the VNCServer to `XTigerVNC` (experimental): Add the option `--xvnc` will make the desktop hosted by the `Xvnc` program. Everything will be run in the same process. There will be no sub-process manager like `tigervncserver` to manage desktop related programs. A good thing is that, users do not need to run `tigervncserver -kill :1` before saving the image. However, currently these desktop related programs are not guaranteed to be closed if hitting <kbd>Ctrl</kbd>+<kbd>C</kbd>. Therefore, we suggest the users to use `ps -aux` to validate the running processes before saving the image.

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.7 --xvnc
  ```

  Certainly, there is also a root mode for this method:

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.7 --rootxvnc
  ```

  After using <kbd>Ctrl</kbd>+<kbd>C</kbd> to kill the `Xvnc` program, users can use the following command to relaunch the `Xvnc` and `noVNC` services:

  ```bash
  xvnc-launch [--root]
  ```

  If adding the option `--root`, the desktop will be run with root privilege.

* By external VNC viewer (client): If you have installed a VNC viewer on your client side, and want to connect the VNC server of the image directly, please use:

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 5901:5901 xubuntu:1.7
  ```

  The `root` mode could be also applied here.

* By `Jupyter Lab`: If you want to launch the Jupyter Lab but do not start the desktop, please use

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 6080:6080 xubuntu:1.7 --jlab jlab_password=openjupyter jlab_rootdir=/homelocal
  ```

  The `jlab_password` would override the default random token. The `jlab_rootdir` is the root folder of the launched jupyter lab. If not set `jlab_rootdir`, the default root folder would be `/homelocal`. The `--jlab` option is required when you need to force the image to switch to Jupyter Lab mode.

* By `BASH`: If you want to enter the command line but do not start the desktop, please use

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal xubuntu:1.7 --bash
  ```

* By any script: If you want run any script inside the docker for only one time, please use

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal xubuntu:1.7 script=<the-path-to-your-script>
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
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 5212:5212 xubuntu:1.7 --cloudreve --bash
  ```

  or launch `Cloudreve` together with the desktop:

  ```bash
  docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 5212:5212 xubuntu:1.7 --cloudreve
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
* **Fully installed Jupyter Lab**: if user needs, a full Jupyter Lab with several extensions could be installed, the details could be checked [here][jlab].
* **Multiple launching method**: including VNC server, jupyterlab, bash and arbitrary script mode.
* **Chinese language support**: for some apps including edge, chrome (chromium), firefox, vscode, kate, codeblocks, ...
* [**Cloudreve Service (Chinese only)** :link:][link-cloudreve]: a private cloud storage service, allowing users to expose their personal folder as an "online drive" available on LAN. If users are interested, they can dig into the configurations and enable more features (like WebDAV and offline downloading). Currently this feature is designed for using a browser-based app to replace the WinSCP client.
* [**FileBrowser Service** :link:][link-filebrowser]: an alternative of `Cloudreve`. It supports multi-language and is more flexible for exchanging files with a single server. Although it does not support so many online drive features like `Cloudreve`, with `FileBrowser`, users can upload / download files, share links, and even run commands (need to be added to the whitelist) easily.
* **Extra scripts**: we also provide some extra scripts for compiling specific libraries (like `ffmpeg` and `gcc`). These files will be convenient examples for users who want extra features.

## Update records

### ver 1.7 @ 4/17/2022

1. Provide Microsoft Edge in the basic tier of the desktop apps.
2. Add more extensions for Visual Studio Code.
3. Upgrade the input method fcitx to version 5 when using Ubuntu 20.04. This is a previewed version in Ubuntu 20.04.
4. Upgrade the other basic tier dependencies, including PeaZip, GitFiend, and Sublime 4.
5. Move Sublime to the extra tier, because it is not a free software. Use Kate as the replacement.
6. Support a cloud file transfer tool: Cloudreve. This tool may be able to replace the functionality of WinSCP.
7. Update the versions of packages in the icon / theme bundle.
8. Switch from Jupyter Lab 2 to Jupyter Lab 3 by default. This configuration is not recommended for those images with Python 3.5. Users may need to configure the J-lab version manually in that case.
9. Provide the [Oh-my-posh (OMP) :link:][link-omp] terminal theme.
10. Provide some optional scripts in the folder `/home/xubuntu` (`~`).
11. Fix small bugs about dependency problems (in `detach`), and the OMP installation.
12. Fix a bug caused by `get-conda-path.py`. When there is neither `conda` nor `python`, the script incorrectly returned `True` value before.
13. Prefer a local snapshot to install VS Code extensions. This change may help avoid the [Server 503 error :link:](https://github.com/microsoft/vscode/issues/57867) during the extension installations.
14. Adjust the formats of some installation scripts.
15. Provide Bing Wallpaper.
16. Wrap up of all tests and scripts. This version can be released now.

#### Inherit from the update of `xubuntu-minimal:1.1`

1. Fix a bug caused by missing of LibreOffice libs (Fixed by `~/.config/xfce4/xinitrc`).
2. Enable users to run GUIs with `sudo` (Fixed by `~/.config/xfce4/xinitrc`).
3. Make the desktop get launched properly. This fixture corrects a bug where the desktop may be launched by twice in Ubuntu 16.04 (Fixed by `~/.vnc/xstartup`).
4. Fix a bug caused by using `get-pip.py` with Python 3.6. Since the `pip` may be downgraded by NVIDIA configurations, this fixture will also correct the `pip` version. (Fixed by `install-desktop`).
5. Prefer `conda/mamba` when updating python packages (Fixed by `install-desktop`).
6. Upgrade TigerVNC to 1.12.80. (Fixed by `install-vnc`).
7. Add more path to `sudo/secure_path`, now users are allowed to use `conda` / `mamba` / `pip` directly with `sudo` (Fixed by `sudoers`).
8. Finish the launching mode `--xvnc` (Fixed by `docker-entrypoint` and `xvnc-launch`).

#### Testing report v1.7

This docker file has been tested sucessfully on:

* [x] `nvcr.io/nvidia/pytorch:22.03-py3` (`Ubuntu 20.04`, `python 3.8`)
* [x] `nvcr.io/nvidia/cuda:11.6.2-cudnn8-runtime-ubuntu20.04` (`Ubuntu 20.04`)
* [x] `nvcr.io/nvidia/pytorch:19.08-py3` (`Ubuntu 18.04`, `python 3.6`)
* [x] `nvcr.io/nvidia/tensorflow:19.03-py3` (`Ubuntu 16.04`, `python 3.5`)

Finished at 4/19/2022.

> :exclamation: This testing build is configured by `WITH_EXTRA_APPS=cpgkmxnoe` indicating an incomplete build. The build test for Atom (`a`) is currently skipped, because the plugin market of Atom is currently down, see the issues https://github.com/atom/atom/issues/25417 and https://github.com/atom/apm/issues/946.
> :exclamation: The build for VS Code extensions also falls back to the local build method, because currently VS Code extension market is not stably working. See the issue https://github.com/microsoft/vscode/issues/147670. Despite this situation, we still manage to install all extensions with a full snapshot of the `.vsix` files.

### ver 1.6.1 @ 7/6/2021

1. Fix a bug caused by the upgrade of noVNC.

### ver 1.6 @ 6/22/2021

1. Support the proxy value for the built image, this value is important for the devices protected by the firewall.
2. Move [GitKraken][link-gitkraken] to the optional packages. Instead, the default Git client is switched to [GitFiend][link-gitfiend].
3. Replace the default system monitor by [`stacer`][link-stacer], the previous app `gnome-system-monitor` is dropped.
4. Change the default configurations of `XFCE4`.
5. Bump [`Pycharm`][link-pycharm], [`tigervncserver`][tigervnc] to the newest versions.
6. Upgrade the Jupyter Lab script to `1.3`.
7. Fix a fatal bug caused by the user authority. We may need to find a method for forwarding the current user to the docker image.
8. Fix a bug of caused by dbus initialization. In the previous version, the bug would cause strange behaviors (for example, the screen savers would not work).
9. Fix a bug caused by the changed address of `get-pip.py`.

### ver 1.5 @ 4/10/2021

1. Enhance the launchers of system menu and panels.
2. Set the user as `xubuntu`, and provide the `--root` mode.
3. Make python version auto-detected, which means `XUBUNTU_COMPAT` has been removed.
4. Add options for installing some extra apps, like PyCharm and GIMP.
5. Enhance the VNC support by [OpenSSL entryption](https://github.com/novnc/websockify#encrypted-websocket-connections-wss).
6. Upgrade the [Jupyter Lab script](https://github.com/cainmagi/Dockerfiles/tree/jlab-v1.2).
7. Add some [themes](https://github.com/cainmagi/Dockerfiles/releases/tag/xubuntu-v1.5-u20.04).
8. Fix the [compatibility problem](https://github.com/pypa/pip/issues/9500) caused by `pip 21.0`.
9. Fix small bugs, related to `nvm` path, `root` authority, and `detach` script.
10. Fix small bugs, related to `jlab` path and the authority of creating SSL certificate.

### ver 1.4 @ 1/17/2021

1. Arrange the theme pack installations.
2. Add fully supported Jupyter Lab installation.
3. Adjust the usage of some options.
4. Add some packages for the desktop.
5. Correct the format of some launchers.

### ver 1.3 @ 1/13/2021

1. Re-craft the icons and themes for `ubuntu 20.04`.
2. Add `gcc` and `gfortran` supports for building the image.
3. Add some packages for the desktop.
4. Add check for `ubuntu` version.
5. Add meta-data in the dockerfile.

### ver 1.2 @ 1/12/2021

1. Add extra Chinese supports for some packages.
2. Add vscode package installation script.
3. Add exposed ports (`5901`, `6080`).
4. Add `Jupyter Lab` supports.

### ver 1.1 @ 1/10/2021

1. Support Ubuntu 20.04.
2. Fix the font issues.
3. Finish all testings for Ubuntu 16.04, 18.04 and 20.04.

#### Testing report v1.1

This docker file has been tested sucessfully on:

* [x] `nvcr.io/nvidia/pytorch:20.12-py3` (`Ubuntu 20.04`, `python 3.8`)
* [x] `nvcr.io/nvidia/cuda:11.1-cudnn8-runtime-ubuntu20.04` (`Ubuntu 20.04`)
* [x] `nvcr.io/nvidia/pytorch:20.11-py3` (`Ubuntu 18.04`, `python 3.6`)
* [x] `nvcr.io/nvidia/tensorflow:19.03-py3` (`Ubuntu 16.04`, `python 3.5`)

### ver 1.0 @ 12/18/2020

Re-craft this dockerfile.

### ver 1.0 @ 20181201

Create the dockerfile branch.

[tigervnc]: https://github.com/TigerVNC/tigervnc
[jlab]: https://github.com/cainmagi/Dockerfiles/tree/jupyterlab

[link-pycharm]:https://www.jetbrains.com/help/pycharm/installation-guide.html
[link-gitkraken]:https://www.gitkraken.com
[link-sublime-text]:https://www.sublimetext.com/
[link-gitfiend]:https://gitfiend.com
[link-stacer]:https://oguzhaninan.github.io/Stacer-Web/
[link-cloudreve]:https://cloudreve.org/
[link-filebrowser]:https://filebrowser.org/
[link-omp]:https://ohmyposh.dev/
