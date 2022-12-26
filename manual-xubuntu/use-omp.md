# Dockerfile Collection for DGX-230

To get back to the main page, click [here](../index).

To view the list of image building, click [here](../dockerlist).

To view the basic manual, click [here](../manual).

To view the detailed graphic guides, click [here](../manual-session).

To view the **contents** of these manuals, click [here](../manual-xubuntu).

## Oh-My-Posh (OMP)

> Updated on 4/19/2022

OMP is a terminal beautifying tool. You can check the official website here:

[https://ohmyposh.dev/ :link:](https://ohmyposh.dev/)

It can also work with powershell. This tool is recommended by Microsoft.

A full installation of OMP requires users to install at least one [Nerd font :link:](https://www.nerdfonts.com/). In our new images, these fonts are already installed:

* Cousine
* InconsolataGo
* Roboto Mono
* Ubuntu Mono

### Configure your OMP

The starting script of OMP is written in `~/.bashrc`. Just open it with a text editor:

```bash
gedit ~/.bashrc
```

Then you can find this part:

```bash
# Configure Oh-my-posh, enable it if it exists.
if [ -s "/usr/local/bin/oh-my-posh" ]; then
    if [ -s ~/".poshthemes/paradox-alt.omp.json" ]; then
        eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/paradox-alt.omp.json)"
    else
        if [ -s ~/".poshthemes/paradox.omp.json" ]; then
            eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/paradox.omp.json)"
        else
            eval "$(oh-my-posh --init --shell bash)"
        fi
    fi
fi
```

It means that:

* If the `paradox-alt.omp.json` theme exist in `~/.poshthemes`, use this theme.
* If not, try to check the backup theme `paradox.omp.json` in `~/.poshthemes`, use this theme.
* If still not, use the default theme of OMP.
* If OMP does not exist, do nothing.

If users comment out this part, the OMP will be disabled. If users want to change a theme, we recommend checking this page:

[https://ohmyposh.dev/docs/themes :link:](https://ohmyposh.dev/docs/themes)

Then find the wanted theme by

```
ls ~/.poshthemes
```

After that, users can replace the configurations in `~/.bashrc` like this:

```bash
eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/<my-theme>.omp.json)"
```
