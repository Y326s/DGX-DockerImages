# Dockerfile Collection for DGX-230

To get back to the main page, click [here](../index).

To view the list of image building, click [here](../dockerlist).

To view the basic manual, click [here](../manual).

To view the detailed graphic guides, click [here](../manual-session).

To view the **contents** of these manuals, click [here](../manual-xubuntu).

## `sudo`

> Updated on 4/19/2022

Currently, we have fixed the two issues about `sudo`:

1. Now users can launch a new GUI in the root mode. For example, this command will start a new file browser:

    ```bash
    sudo thunar
    ```

    If users find that some apps can not be launched by `sudo`, like `mousepad`, they can try to launch the app like this:

    ```bash
    sudo dbus-launch mousepad
    ```

    We have to say that this method is preferred compared to the first approach. For example, if `thunar` is launched by `sudo dbus-launch`, you may be able to open a `mousepad` window with the opened `thunar` window and the `root` mode.

2. Now users can use the following commands in the `sudo` mode directly:

    ```bash
    sudo conda ...
    sudo mamba ...
    sudo python ...
    sudo python -m pip ...
    ```

    > :warning: After some tests, we found that `conda`, `mamba`, and `python` are all consistent with the user version when using `sudo`. However, if using `sudo`, the `pip` is not `/opt/conda/bin/pip` but `/usr/local/bin/pip`. Therefore, for those who want to use `pip` to install system-scope packages, they need to use either one of the following commands:
    > 
    > ```bash
    > sudo /opt/conda/bin/pip install ....
    > sudo python -m pip install ...
    > ```
    > 
    > This problem should be fixed in the next image build.

    It is not required to specify the whole path like `sudo /opt/conda/bin/conda` anymore.
