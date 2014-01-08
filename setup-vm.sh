#!/usr/bin/env bash

# Opensuse # not tested yet
# if
#   [[ -f /etc/os-release ]] &&
#   GREP_OPTIONS="" \grep "ID=opensuse" /etc/os-release >/dev/null
# then
#   sed -i'' '/^127.0.0.1[[:space:]]*localhost$/ s/$/ '"$(hostname)"'/' /etc/hosts
# fi

# Ubuntu/Debian
if
  which apt-get >/dev/null 2>&1
then
  apt-get --quiet --yes update
  apt-get --no-install-recommends --quiet --yes install bash curl ruby2.0 ruby2.0-dev bison zlib1g-dev libssl-dev ncurses-dev libreadline-dev
  ln -s /usr/include/x86_64-linux-gnu/ruby-2.0.0/ruby/config.h /usr/include/ruby-2.0.0/ruby/config.h
fi

# Arch # not tested yet
# if
#   [[ -s /etc/gemrc ]] &&
#   grep -- '--user-install' /etc/gemrc >/dev/null
# then
#   sed -i'' -- '/--user-install/ d' /etc/gemrc
# fi

# Fedora # not tested yet
# if
#   grep "^[^#]*requiretty" /etc/sudoers >/dev/null
# then
#   sed -E -i'' -e 's/(Defaults\s+requiretty)/#\1/' /etc/sudoers
# fi

# groups vagrant | grep rvm >/dev/null ||
#   /usr/sbin/usermod -a -G rvm vagrant

true
