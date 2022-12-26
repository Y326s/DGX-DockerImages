# Dockerfile Collection for DGX-230

To get back to the main page, click [here](../index).

To view the list of image building, click [here](../dockerlist).

To view the basic manual, click [here](../manual).

To view the detailed graphic guides, click [here](../manual-session).

To view the **contents** of these manuals, click [here](../manual-xubuntu).

## `xvnc-launch`

> Updated on 4/19/2022

> :telescope: :construction: This feature is still experimental now. Although it should work properly, I have not made many tests. Maybe there would be some unwanted and unknown behaviors.

This script provides an alternative way for launching the desktop and noVNC. It is more convenient than using the commands like these:

```bash
MACHINE_IP=$(hostname -I | awk 'NR==1 {print $1}')
tigervncserver -name xubuntu -depth 24 -geometry 1920x1080
noVNC --vnc $MACHINE_IP:5901 --listen 6080
```

The above script is the default method for launching the desktop. It requires users to hit <kbd>Ctrl</kbd>+<kbd>C</kbd> to terminate noVNC, and then call `tigervncserver -kill :1` to terminate the desktop.

If users have already terminated the desktop, or have not launched the desktop yet, they will be able to launch the desktop by just typing the following command:

```bash
xvnc-launch
```

This command will fork two processes in the current process. One is the `XTigervnc` desktop, and the other one is the noVNC. There will be a lot of logs popping up to the current terminal. If users want to terminate the desktop and noVNC, just hitting <kbd>Ctrl</kbd>+<kbd>C</kbd> is enough. There will be no need for calling  `tigervncserver -kill :1` in this case.

### Potential problem

Since the desktop and noVNC are forked in the sub-processes. It is possible that the desktop is not terminated after hitting <kbd>Ctrl</kbd>+<kbd>C</kbd>. In this case, users can only check the PID of the desktop by `ps -aux`, and use the `kill -9 <PID>` to terminate the desktop.

However, it may be OK if users save the image without successfully killing the desktop. Because the launching script of `xvnc-launch` seems to be not influenced by this problem. This behavior is not like `tigervncserver`.

### Start the desktop by `xvnc-launch`

Instead of using the default launching method, users can also use `xvnc-launch` to start the desktop by specifying the option of the `docker run` command:

```bash
docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 6080:6080 xubuntu:1.7 --xvnc
```

### Run the desktop in the root mode

If users provide the `--root` option to `xvnc-launch`, the desktop will be started by `root` user:

```bash
xvnc-launch --root
```

Certainly, it is equivalent to this command:

```bash
sudo xvnc-launch
```

The root mode can be also launched by `docker run`:

```bash
docker run --gpus all -it --rm --shm-size=1g -v ~:/homelocal -p 6080:6080 xubuntu:1.7 --rootxvnc
```
