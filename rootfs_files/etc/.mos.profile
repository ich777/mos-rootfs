#!/bin/sh

# Set Terminal
export TERM=xterm-color

# Set Editor
export EDITOR=nano

# Set console colors
export PS1='\[\033[38;5;34m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Set colors for programs
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
