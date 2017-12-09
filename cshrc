#==================================================
#         File:   .cshrc
#
#  Description:   This customizes your C-shell
#       Author:   erg
#
#==============================================================
# Set prompt to have the following form: [user][workingdir]-$
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
#============================
#   My csh Aliases
#============================
alias ls              'ls -G'
alias la              'ls -la'
alias lt              'clear;ls -lat | less -X'
alias lrt             'clear;ls -lart | less -X'
alias less            'less -X'
alias cp              'cp -v'
alias mv              'mv -v'
alias rm              'rm -v'
alias lsc             'ls | wc -l'
alias a               'asdf -u'
alias o               'loffice'
alias v               'vim'
alias lsd             'ls -d */'

