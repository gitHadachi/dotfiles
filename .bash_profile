# $Id$
# $Source$
#
# ~/.bash_profile is personal profile for login shell.
# ~/.bashrc is personal "conversation" profile for subshell.

umask 022

### read bashrc
if [ -n "$BASH_VERSION" ] ; then
    if [ -f ~/.bashrc ] ; then
        . ~/.bashrc
    fi
fi

# Read "perlbrew" in .bashrc path definition fast than in .bash_profile other definitions.

### PATH

export PATH
if [ -d ~/bin ] ; then
    PATH=$PATH:~/bin
fi
if [ -d /opt/local/bin ] ; then
    # for MacPorts
    PATH=$PATH:/opt/local/bin
fi
if [ -d /Developer/usr/bin ] ; then
    # for Xcode3 on Lion
    PATH=$PATH:/Developer/usr/bin
fi
if [ -d ~/git/@github/xtetsuji/various-commands/bin ] ; then
    PATH=$PATH:~/git/@github/xtetsuji/various-commands/bin
fi
if [ -d ~/.rbenv/bin ] ; then
    PATH=$PATH:~/.rbenv/bin
    eval "$(rbenv init -)"
fi

### mysql-build
# http://www.hsbt.org/diary/20130217.html
if [ -d ~/.mysql/mysql-build/bin ] ; then
    PATH=$PATH:~/.mysql/mysql-build/bin
fi
if [ -d ~/.mysql/default/bin ] ; then
    PATH="$HOME/.mysql/default/bin:$PATH"
fi

### plenv if exist
if [ -d "$HOME/.plenv/bin" ] ; then
    export PATH="$HOME/.plenv/bin:$PATH"
fi
if type plenv >/dev/null 2>&1 ; then
    eval "$(plenv init -)"
fi


### rbenv if exist
if [ -d "$HOME/.rbenv/bin" ] ; then
    export RBENV_ROOT=$HOME/.rbenv
    export PATH=$PATH:$RBENV_ROOT/bin
fi

	

### MANPATH
export MANPATH

### INFOPATH
export INFOPATH

### Locale / Lang

# locale is UTF-8 ordinary on modern Debian and some dists.
if    [ -f /etc/locale.gen ] \
   && grep -i '^ja_JP\.UTF-8' /etc/locale.gen >/dev/null 2>&1 ; then
    export LANG=ja_JP.UTF-8
elif  [ -f /etc/locale.gen ] \
   && grep -i '^ja_JP\.eucJP' /etc/locale.gen >/dev/null 2>&1 ; then
    export LANG=ja_JP.eucJP
    export JLESSCHARSET=japanese-euc
elif [ `uname` = Darwin ] ; then
    export LANG=ja_JP.UTF-8
else
    export LANG=C
fi

export TZ=JST-9

BASH_PROFILE_DONE=1
