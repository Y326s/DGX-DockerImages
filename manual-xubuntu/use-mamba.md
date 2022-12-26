# Dockerfile Collection for DGX-230

To get back to the main page, click [here](../index).

To view the list of image building, click [here](../dockerlist).

To view the basic manual, click [here](../manual).

To view the detailed graphic guides, click [here](../manual-session).

To view the **contents** of these manuals, click [here](../manual-xubuntu).

## Use `mamba` :snake:

> Updated on 4/19/2022

`conda` is one of the worst package managers in the world. This situation is even more painful if you have to use an older `conda` in an older docker image.

Fortunately, someone has developed an alternative to `conda`. Check this project:

[https://github.com/mamba-org/mamba :link:](https://github.com/mamba-org/mamba)

If you are using `mamba`, you can use every command from `conda`, for example:

```bash
mamba update -y mamba
mamba install -c conda-forge matplotlib
```

It will inherit each configuration of `conda`. In other words, if you have pinned some packages in `conda`, these packages will be also pinned by `mamba`.

The package solving of `mamba` is far more fast compared to `conda`. Feel free to replace `conda` with `mamba` everywhere!

### How to install mamba

Actually, if there has been a `conda` in the base image, I have already installed `mambda` inside the corresponding desktop image. If you find that `mambda` is not installed in an image, that means `conda` is not installed in that image, too. If you want to install `mambda`, just run

```bash
conda install -c conda-forge mamba
```

After that, you can get rid of the annoying and extremely slow `conda` :snail:.
