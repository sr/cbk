Installation
============

We only provide packages and setup instructions for Ubuntu 15.10 at this time.

## Ubuntu 15.10

Start by following the instructions to install the packagecloud repository:

<https://packagecloud.io/sr/cbk/install>

Once that is done, you will also need to install the `nilarimogard/webupd8`
PPA [repository][webupd8] which provides an up to date version of the
`youtube-dl` package, required for downloading SoundCloud likes.

    $ sudo apt-add-repository ppa:nilarimogard/webupd8

You are now ready to install cbk and all its dependencies:

    $ sudo apt-get install cbk

Lastly, edit the configuration file provided by the package accordingly:

    $ sudo vi /etc/cbk.conf

You are now ready to go. Checkout the `cbk-pull(1)` man page for usage
instructions.

    $ man cbk-pull

[webupd8]: https://launchpad.net/~nilarimogard/+archive/ubuntu/webupd8

## Ansible

We also provide an [Ansible](https://ansible.com) role to automate the
installation process:

<https://github.com/sr/ansible-role-cbk>
