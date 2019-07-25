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

and it should say something like `Chromium 75.0.3770.142 Built on Ubuntu , running on Raspbian 9.6`

On Raspbian Buster they're back to keeping Chromium current so this
becomes less relevant, unless they happen to fall behind again.

To update this repo anytime there's a new version of Chromium
it's not that hard. Go to
https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage
and click around to find links to the two relevant \*.deb files, then
update paths accordingly in `Makefile`. Please file a pull request
with your changes so that everyone can benefit.
