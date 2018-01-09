# Source file for colors
# vi: set ft=sh:

OS="$( uname -s )"

if [[ $OS == 'Linux' ]]; then
    char='\e'
elif [[ $OS == 'Darwin' ]]; then
    char='\033'
fi

# Regular
RBLACK="$char"'[0;90m'     # Black
RRED="$char"'[0;91m'       # Red
RGREEN="$char"'[0;92m'     # Green
RYELLOW="$char"'[0;93m'    # Yellow
RBLUE="$char"'[0;94m'      # Blue
RPURPLE="$char"'[0;95m'    # Purple
RCYAN="$char"'[0;96m'      # Cyan
RWHITE="$char"'[0;97m'     # White

# Bold (light)
BBLACK="$char"'[1;90m'     # Black
BRED="$char"'[1;91m'       # Red
BGREEN="$char"'[1;92m'     # Green
BYELLOW="$char"'[1;93m'    # Yellow
BBLUE="$char"'[1;94m'      # Blue
BPURPLE="$char"'[1;95m'    # Purple
BCYAN="$char"'[1;96m'      # Cyan
BWHITE="$char"'[1;97m'     # White

# Italic (doesn't work in most terminals)
IBLACK="$char"'[3;90m'     # Black
IRED="$char"'[3;91m'       # Red
IGREEN="$char"'[3;92m'     # Green
IYELLOW="$char"'[3;93m'    # Yellow
IBLUE="$char"'[3;94m'      # Blue
IPURPLE="$char"'[3;95m'    # Purple
ICYAN="$char"'[3;96m'      # Cyan
IWHITE="$char"'[3;97m'     # White

# Underline
UBLACK="$char"'[4;90m'     # Black
URED="$char"'[4;91m'       # Red
UGREEN="$char"'[4;92m'     # Green
UYELLOW="$char"'[4;93m'    # Yellow
UBLUE="$char"'[4;94m'      # Blue
UPURPLE="$char"'[4;95m'    # Purple
UCYAN="$char"'[4;96m'      # Cyan
UWHITE="$char"'[4;97m'     # White

# Blinking AND Underline
BUBLACK="$char"'[5;4;90m'  # Black
BURED="$char"'[5;4;91m'    # Red
BUGREEN="$char"'[5;4;92m'  # Green
BUYELLOW="$char"'[5;4;93m' # Yellow
BUBLUE="$char"'[5;4;94m'   # Blue
BUPURPLE="$char"'[5;4;95m' # Purple
BUCYAN="$char"'[5;4;96m'   # Cyan
BUWHITE="$char"'[5;4;97m'  # White

# Background
BGBLACK="$char"'[40m'      # Black
BGRED="$char"'[41m'        # Red
BGGREEN="$char"'[42m'      # Green
BGYELLOW="$char"'[43m'     # Yellow
BGBLUE="$char"'[44m'       # Blue
BGPURPLE="$char"'[45m'     # Purple
BGCYAN="$char"'[46m'       # Cyan
BGWHITE="$char"'[47m'      # White

# Blinking
BLBLACK="$char"'[5;90m'    # Black
BLRED="$char"'[5;91m'      # Red
BLGREEN="$char"'[5;92m'    # Green
BLYELLOW="$char"'[5;93m'   # Yellow
BLBLUE="$char"'[5;94m'     # Blue
BLPURPLE="$char"'[5;95m'   # Purple
BLCYAN="$char"'[5;96m'     # Cyan
BLWHITE="$char"'[5;97m'    # White

# Reset Color
RESET="$char"'[0m'         # Reset color

unset char OS

