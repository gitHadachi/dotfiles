# xtetsuji/dotfiles/.bash_profile
#
# ~/.bash_profile is personal profile for login shell.
# ~/.bashrc is personal "conversation" profile for subshell.
#
# ~/.bash_profile only offers environment varialble.
# and if possible, do not use external command to reduce cost.

umask 022

### read bashrc
if [ -n "$BASH_VERSION" ] && [ -f ~/.bashrc ] ; then
    source ~/.bashrc
fi

### PATH of fundamental
export PATH
for d in ~/bin ~/Dropbox/bin ~/git/@github/xtetsuji/various-commands/bin ; do
    if [ -d $d ] ; then
        PATH=$PATH:$d
    fi
done
unset d
# TODO: each other two directries are same if one is symbolic link of another.

###
### mysql-build
###
# http://www.hsbt.org/diary/20130217.html
if [ -d ~/.mysql/mysql-build/bin ] ; then
    PATH=$PATH:~/.mysql/mysql-build/bin
fi
if [ -d ~/.mysql/default/bin ] ; then
    PATH="$HOME/.mysql/default/bin:$PATH"
fi

function xtenv-cache-eval {
    local init_script_generate_command="$1"
    local cache_file_name="$2"
    local cache_file_path="$XTENV_CACHE_DIR/$cache_file_name"
    if [ ! -f "$cache_file_path" ] ; then
        $init_script_generate_command > $cache_file_path
    fi
    eval "$(< "$cache_file_path" )"
}

###
### plenv
###
if [ -d $HOME/.plenv ] ; then
    export PLENV_ROOT=$HOME/.plenv
    export PATH=$PLENV_ROOT/bin:$PATH
    eval "$(plenv init -)"
    test -d $PLENV_ROOT || mkdir $PLENV_ROOT
fi

###
### rbenv
###
if [ -d $HOME/.rbenv ] ; then
    export RBENV_ROOT=$HOME/.rbenv
    export PATH=$PATH:$RBENV_ROOT/bin
    # Homebrew's rbenv offers RBENV_ROOT=/usr/loca/var/rbenv
    # But ~/.rbenv is useful when I use for personal.
    eval "$(rbenv init -)"
    test -d $RBENV_ROOT || mkdir $RBENV_ROOT
fi

###
### pyenv
###
if [ -d $HOME/.pyenv ] ; then
    export PYENV_ROOT=$HOME/.pyenv
    export PATH=$PYENV_ROOT/bin:$PATH
    eval "$(pyenv init -)"
fi

###
### nodebrew
###
if [ -d $HOME/.nodebrew/current/bin ] ; then
    export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

###
### golang
###
# brew install go
if type go >/dev/null 2>&1 ; then
    GO_VERSION=$(go version | sed -e 's/.*version go//' -e 's/ .*//')
    if ! [[ $GO_VERSION =~ ^[0-9][0-9.]+$ ]] ; then
        GO_VERSION=default
    fi
    if [ -d "$HOME/.go" ] ; then
        export GOPATH=$HOME/.go/$GO_VERSION
        export PATH=$GOPATH/bin:$PATH
        if [ ! -d $GOPATH ] ; then
            mkdir -p $GOPATH
        fi
    fi
fi

###

###
### byobu
###
if type brew >/dev/null 2>&1 ; then
    export BYOBU_PREFIX=$(brew --prefix)
fi

###
### Some PATHes
###
export MANPATH
export INFOPATH

###
### ssh-agent
###
# http://www.gcd.org/blog/2006/09/100/
MY_SSH_AUTH_SOCK_PATH="/tmp/ssh-agent-$USER"
if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
    /tmp/*/agent.[0-9]*)
        ln -snf "$SSH_AUTH_SOCK" $MY_SSH_AUTH_SOCK_PATH \
                && export SSH_AUTH_SOCK=$MY_SSH_AUTH_SOCK_PATH
    esac
elif [ -S $MY_SSH_AUTH_SOCK_PATH ]; then
    export SSH_AUTH_SOCK=$MY_SSH_AUTH_SOCK_PATH
else
    : #echo "no ssh-agent"
fi

###
### Locale / Lang
###
# locale is UTF-8 ordinary on modern Debian and some dists.
if    [ -f /etc/locale.gen ] \
   && grep -i '^ja_JP\.UTF-8' /etc/locale.gen >/dev/null 2>&1 ; then
    export LANG=ja_JP.UTF-8
    export LV="-Ou"
elif  [ -f /etc/locale.gen ] \
   && grep -i '^ja_JP\.eucJP' /etc/locale.gen >/dev/null 2>&1 ; then
    export LANG=ja_JP.eucJP
    export JLESSCHARSET=japanese-euc
    export LV="-Oe"
elif [ `uname` = Darwin ] ; then
    export LANG=ja_JP.UTF-8
    export LV="-Ou"
else
    export LANG=C
fi

export TZ=JST-9

BASH_PROFILE_DONE=1
