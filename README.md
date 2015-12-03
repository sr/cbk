cbk — backup hosted personnal data
==================================

> Remember: if it's not on a drive that is in your physical possession, it's not
> really yours.
>
> — <cite>Jamie Zawinski</cite> in [PSA: Back Up Your Shit.][jwz]

[jwz]: https://www.jwz.org/blog/2014/01/psa-back-up-your-shit/

The cbk package provides the `cbk-pull` program for downloading personnal data
from various hosted service providers onto the local machine. It is currently
capable of backing up data from the fellowing sources:

- Address book (vCard) from Fastmail.com's CardDAV server
- Email (Maildir) from Fastmail's IMAP server
- git repositories hosted on GitHub
- Bookmarks saved on Pinboard.com
- Audio tracks liked on SoundCloud.com

To get started, read the [installation](/share/docs/install.md) instructions
then checkout the [man page](/share/docs/cbk-pull.1.ronn.md) for more info and
detailed usage.
