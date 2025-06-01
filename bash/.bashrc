# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi


source $HOME/.cargo/env
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.local/flutter/bin

export EDITOR='hx'
export VISUAL='hx'

export JAVA_HOME="/home/$USER/.sdkman/candidates/java/current"

alias ed="$EDITOR ~/.bashrc"
alias s="source ~/.bashrc"
alias gl="glxinfo -B"
alias c-format="clang-format -style=Microsoft -dump-config > .clang-format"
alias update-submodule="git submodule update --remote --merge"

alias serial-pc="sudo dmidecode -t system | grep Serial"

# Pop Os Related functions

gpu() {
    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
}

# ROS Related setup

# export ZENOH_CONFIG="$HOME/.config/zenoh/config.json5"
# ROS_DISTRO=humble
if [[ -f /opt/ros/${ROS_DISTRO}/setup.bash ]]; then
    source /opt/ros/${ROS_DISTRO}/setup.bash

    export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

    # EHLIKESF
    export WORKSPACE="$HOME/dev/ehlikesf_ws/ros2_ws"
    export PX4_PATH="$HOME/dev/ehlikesf_ws/PX4-Autopilot"
    # export ZENOH_CONFIG="$WORKSPACE/src/ehlikesf/ehlikesf/config/config.json5"
    export ZENOH_CONFIG="~/.config/zenoh/config.json5"

    # XOSA
    # export WORKSPACE="$HOME/dev/XOSA/src/xosa_ros"
    # source "$WORKSPACE/setup.bash"

    # VRX
    # export WORKSPACE="$HOME/dev/xosa_ws/vrx_ws"

    # WEBOTS
    # export WEBOTS_HOME="~/Downloads/webots-R2023a-x86-64/webots"


    # Source ROS2 workpace
    if [[ -f $WORKSPACE/install/setup.bash ]]; then
        source $WORKSPACE/install/setup.bash
    fi

    build ()
    {
        cd $WORKSPACE

        if [[ "$#" -eq 1 ]]; then
            colcon build --symlink-install --packages-select $1
        elif [[ "$#" -eq 0 ]]; then
            colcon build --symlink-install 
        fi
        
    }
    
fi

eval "$(starship init bash)"
eval "$(fnm env --use-on-cd)"

# KEY=4d0932e501ee43719117112ef7a086ba
# SCENARIO=1
# alias send='curl --insecure --request PUT --data-binary "@ehlikesf_teknofest.zip" "https://192.168.2.4:1453/put-code?key=$KEY&scenario=$SCENARIO"'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="/home/abdulmelik/.pixi/bin:$PATH"
. "$HOME/.cargo/env"
