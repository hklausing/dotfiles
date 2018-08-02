dotfiles
========

dotfile is used to keep all system relevant configuration file at one
location. The reason for this:

* This will allow to cover the files in an easy way under
version control.
* On the other site it makes sharing of setups
with other system very convenient.

This repository can be find <http://github.com/hklausing/dotfiles.git>.


Requirements
------------

* Used shell is bash
* Test system is Manjaro


Installation
------------

Follow next commands to update the system:

```
$ cd ~
$ git clone git://github.com/hklausing/dotfiles.git .dotfiles
$ cd .dotfiles
$ ./install.sh
$ source ~/.bashrc
```

