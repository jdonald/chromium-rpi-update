Chromium on Debian armhf appears to have been broken starting with version 68.
Yet it works fine on Ubuntu 18.04 Bionic armhf.

So let's take the Ubuntu binary and tweak its dependencies to install smoothly on
Raspbian. Clone this repo on a PC or Pi then run like so:

    make

or just download the repackaged binaries from the releases tab.

On your Raspbian Stretch system, install the repackaged Chromium:

    sudo dpkg --install chromium*rpi1_armhf.deb

Then try it out:

    chromium-browser --version

and it should say something like `Chromium 71.0.3578.98 Built on Ubuntu , running on Raspbian 9.6`
