# Dockerfile Collection for DGX-230

To get back to the main page, click [here](../index).

To view the list of image building, click [here](../dockerlist).

To view the basic manual, click [here](../manual).

To view the detailed graphic guides, click [here](../manual-session).

To view the **contents** of these manuals, click [here](../manual-xubuntu).

## FileBrowser Service

> Updated on 4/19/2022

You can find the official website of FileBrowser here:

[https://filebrowser.org/ :link:](https://filebrowser.org/)

Now we recommend launching the desktop with another port exposed:

```bash
docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -v /raid/myname:/data -p 6080:6080 -p 5212:5212 xubuntu:1.7
```

The first `5212` can be modified to another value in case of port occupation. To perform the initial configuration, we recommend running the desktop in interactive mode, making the configurations to FileBrowser, and saving the image.

After that, users can get into the desktop, start a new terminal, and run

```bash
fbrowser
```

It will start another service. If you get access to the desktop by

```markdown
http://xxx.xx.xx.xxx:6080/vnc.html
```

Now you can get access to FileBrowser by

```markdown
http://xxx.xx.xx.xxx:5212/
```

### The initial configuration

This part is very important because the administrator of FileBrowser has such information:

```markdown
User:     admin
Password: admin
```

It is very unsafe. So you need to log in with the initial password, and enter the user management page, then modify your admin password.

|  User management  |
| :---------------: |
| ![](./display/fbrowser-1.png) |

Then, you can configure your password and allowed commands:

|  Configure password  |  Configure allowed commands  |
| :------------------: | :--------------------------: |
| ![](./display/fbrowser-2.png) | ![](./display/fbrowser-3.png) |

The recommended administrator's commands are:

```no
sudo ls cd cp rm ln mv chmod chown chgrp yjin-tool git tar zip unzip
```

You can also create a new non-admin user, we recommend you to always use this non-admin user for safety issues:

|  Configure password  |  Configure allowed commands  |
| :------------------: | :--------------------------: |
| ![](./display/fbrowser-4.png) | ![](./display/fbrowser-5.png) |

The recommended user's commands are:

```no
ls cd ln chmod chown chgrp yjin-tool git tar zip unzip
```

After all, you can log in with a non-admin user. Now you can

* Upload or download a file.
* Preview, move or delete files on DGX.
* Modify some text-based files, like `.txt`, `.sh`, ...
* Share a file by link. This link can get accessed by anybody on the same LAN.
* Use some commands, for example, use `tar` to zip/unzip files.

|   Run a command   |
| :---------------: |
| ![](./display/fbrowser-6.png) |

After finishing the above configurations, you can save your image. Your configurations will be remembered.

> :warning: Note that this command line is not a `bash` command line. Running a program is OK, but many commands are restricted.

### Run with a different root folder

By default, the root folder of FileBrowser is `/homelocal`. You can also change it to a different path, like `/data`. Just specify the argument like this:

```bash
fbrowser rootdir=/data
```

### Start FileBrowser together with the desktop

You can specify the argument `--filebrowser` when launching the container. Then the FileBrowser will be opened together with the desktop service:

```bash
docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -v /raid/myname:/data -p 6080:6080 -p 5212:5212 xubuntu:1.7 --filebrowser fb_rootdir=/data
```

where `fb_rootdir` is the root directory of FileBrowser. If not specified, will use `/homelocal`.

Actually, we recommend users opening FileBrowser always on a terminal inside the desktop. This configuration will help users to control the service better.

> :warning: Do not open Cloudreve and Filebrowser at the same time, unless you know what you are doing and how to configure your ports.

### Explain the `fbrowser` command

The command

```bash
fbrowser rootdir=/data port=5212
```

is just an abbr. of this command:

```bash
USER_ROOT=/home/xubuntu
MACHINE_IP=$(hostname -I | awk 'NR==1 {print $1}')
filebrowser -r /data -a $MACHINE_IP -p 5212 -d "${USER_ROOT}/filebrowser/fb-database.db"
```

The database used for storing the user information is saved in `/home/xubuntu/filebrowser/fb-database.db`. Note that this path is inside the container, and it is not mounted folder!
