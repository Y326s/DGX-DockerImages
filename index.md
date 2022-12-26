# Dockerfile Collection for DGX-230

## Dockerfile list

To view the manual, please check [here](./manual).

To view the detailed graphic guides, click [here](./manual-session).

To view extra manuals about xUbuntu, please check [here](./manual-xubuntu).

To view our dockerfile list, please check [here](./dockerlist).

## Dockerfiles

Here is the list of each dockerfile:

1. xubuntu at the branch [**xubuntu**](https://github.com/Y326s/DGX-DockerImages/tree/xUbuntu_YL)

    Run such a command to build the newest image online:

    ```Bash
    docker build -t xubuntu:1.0 https://github.com/Y326s/DGX-DockerImages.git#xUbuntu_YL
    ```

2. jupyterlab at the branch  [**jupyterlab**](https://github.com/Y326s/DGX-DockerImages/tree/jupyterlab)

    Run such a command to build the newest image online:

    ```Bash
    docker build -t jlab:1.0 https://github.com/Y326s/DGX-DockerImages.git#jupyterlab
    ```

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
