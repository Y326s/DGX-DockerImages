# Dockerfile Collection for DGX-230

To get back to the main page, click [here](../index).

To view the list of image building, click [here](../dockerlist).

To view the basic manual, click [here](../manual).

To view the detailed graphic guides, click [here](../manual-session).

To view the **contents** of these manuals, click [here](../manual-xubuntu).

## `set-bing-wallpaper`

> Updated on 4/19/2022

This command will be automatically called each time you start the desktop.

You can also manually call the command by:

```bash
set-bing-wallpaper
```

> :warning: Note that this script will not be launched by an automatic schedule. It is only automatically launched by the startup of the desktop. In other words, if you keep your desktop open, and you want to switch your desktop. Please run `set-bing-wallpaper` manually.

### What is Bing Daily Wallpaper

Microsoft Bing will release a new beautiful landscape photo every day. Use the following link to query today's new photo:

[https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-US :link:](https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-US)

For example, for 4/19/2022, the photo is

[Plitvice Lakes National Park, Croatia (© Janne Kahila/Getty Images) :link:](https://www.bing.com/th?id=OHR.PlitviceBoardwalk_EN-US6264296543_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp)

This script can query the photo, download today's photo and set it as the desktop wallpaper automatically.

### How to forbid the automatic launch

If you prefer to use your own wallpaper and do not want this feature, just run this command

```bash
touch /home/xubuntu/no-bing-wallpaper
```

It will create an empty file. If this file is detected, the script will not be automatically launched anymore.

### How to find the downloaded wallpapers

These files are stored in `~/.bing-wallpapers`. Each time the script runs, it will remove all photos 30 days before. If you have some favorite photos, remember to copy them to another place.
