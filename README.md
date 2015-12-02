cbk — hosted data backup utilities
==================================

The cbk package provides the `cbk-pull` program for downloading personnal data
from various hosted service providers onto the local machine.

Supported services:

- **fastmail-carddav:** Mirror entire address book in vCard format from
  [Fastmail](https://fastmail.com)'s CardDAV servers using
  [vdirsyncer](https://github.com/untitaker/vdirsyncer).
- **fastmail-imap:** Download email data hosted on Fastmail's IMAP servers onto
  a local [Maildir](https://en.wikipedia.org/wiki/Maildir) using
  [OfflineIMAP](http://offlineimap.org).
- **github:** Mirror git repositories hosted on [GitHub](https://github.com)
  for which the configured user/token pair has write access. This includes both
  public and private repositories as well as those that belong to an
  organization.
- **pinboard:** Store all bookmarks the user has saved on
  [Pinboard](https://pinboard.in/) into a single XML file.
- **soundcloud-likes:** Download both audio files and meta data for all tracks
  the user has liked on [SoundCloud](https://soundcloud.com).

Data for all services except for `soundcloud-likes` is versioned in git.

## Installation and setup

Packages are provided for Ubuntu 15.10 (wily). Follow the
[setup instructions][setup] to install the packagecloud repository.

Backing up SoundCloud likes requires installing the
[nilarimogard/webupd8][webupd8] PPA repository which provides an up to date
version of the `youtube-dl` package.

    $ sudo apt-add-repository ppa:nilarimogard/webupd8

Once that's done, install cbk and its depedencies:

    $ sudo apt-get install cbk

The package includes an example configuration file with extended documentation
for all settings:

    $ sudo vi /etc/cbk.conf

Packages and instructions for other platforms are not provided at this time.
A list of dependencies can be found in the [`Makefile`][mk].

[setup]: https://packagecloud.io/sr/cbk/install
[webupd8]: https://launchpad.net/~nilarimogard/+archive/ubuntu/webupd8
[mk]: https://github.com/sr/cbk/blob/master/Makefile#L44-L51

## Usage

To start downloading data from all supported sources, run:

    $ cbk-pull -a

It is also possible to cherry pick sources:

    $ cbk-pull pinboard github

This should typically be run as part of an automated cron job. It is also highly
recommended to copy all downloaded data to a dedicated storage service, such as
[Tarsnap](http://www.tarsnap.com).

## Background and Acknowledgment

This project was inspired by Jamie Zawinski's ["PSA: Back Up Your Shit"][jwz]
blog post, partialy quoted bellow:

> Here in this modern world, you talk to your friends over all kinds of
> different media: SMS, Facebook, Twitter DMs, GChat, and maybe even AIM if
> you're really old. These conversations aren't ephemeral and disposable, they
> are your life, and you want to save them forever. You don't just throw your
> letters in the trash. You might want them some day.
>
> Unfortunately, you and your friends have become beholden to third-party
> corporations who don't give a shit about preserving your data. That's because
> you're not the customer, you're the product. You already knew that, but you go
> along with it anyway, because frankly you don't have much choice.

[jwz]: https://www.jwz.org/blog/2017/01/psa-back-up-your-shit/

The `cbk-pull-github` command and related utilities were inspired by
Daniel Schauenberg's ["Mirror GitHub repositories in pure shell"][mrtazz].

[mrtazz]: https://unwiredcouch.com/bits/2014/08/16/github-mirror-shell.html

## Bugs

Tons of data sources are not supported:

- [ ] Twitter Timeline, and Direct Messages
- [ ] Facebook Messages, Likes, and Friends
- [ ] Foursquare Visited and Saved placed
- [ ] Fastmail Calendar
- [ ] iCloud Calendar
