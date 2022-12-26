# Dockerfile Collection for DGX-230

To get back to the main page, click [here](../index).

To view the list of image building, click [here](../dockerlist).

To view the basic manual, click [here](../manual).

To view the detailed graphic guides, click [here](../manual-session).

To view the **contents** of these manuals, click [here](../manual-xubuntu).

## `user-mapping`

> Updated on 4/19/2022

This script is exactly what is called during the "initialization" of the image. If you want to change the container-inside authority to other persons, just run this command:

```bash
sudo user-mapping uid=<uid> gid=<gid>
```

### Launched by docker

The following command is equivalent to running the `user-mapping` script instantly after starting a new container:

```bash
docker run --gpus all -it --rm xubuntu:1.0 uid=$(id -u) gid=$(id -g)
```

You may find that this is exactly the initialization of a new docker image. Here `$(id -u)` is your user id, and `$(id -g)` is your group id.
