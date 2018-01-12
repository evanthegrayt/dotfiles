#==================================================
#         File:   .cshrc
#
#  Description:   This customizes your C-shell
#       Author:   erg
#
# vi: set syntax=csh:
#==============================================================

set host = `echo $HOST| cut -d. -f1`
alias setprompt 'set prompt=" (${user}@${host}) ${cwd}\n $ "'
setprompt           # to set the initial prompt
alias cd 'chdir \!* && setprompt'
#=====================================
#  This sets the tab auto-fill
#=====================================
set filec
set autolist=ambiguous

if ( -x /usr/bin/dircolors || -x /usr/local/bin/dircolors ) then
    set ls_colors = `dircolors -c $HOME/.dir_colors|cut -d"'" -f 2`
    alias ls "env LS_COLORS=\"$ls_colors\" ls -hF --color=auto"
else
    alias ls 'env CLICOLOR=1 LSCOLORS=ExGxFxdxCxfxDxxbadacad ls -hFG'
endif

alias lrt             'clear;ls -lart | less -X'
alias less            'less -X'
alias cp              'cp -v'
alias mv              'mv -v'
alias rm              'rm -v'

