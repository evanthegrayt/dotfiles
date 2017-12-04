#!/bin/bash

# Source file for colors

# Some information:
# echo -e "Not colored\033[32m Hello World"
# "Not colored" will not be colored. "Hello World" will be green.
#
# Example:
# echo -e "\033[1;34mThis is a blue text.\033[0m"
#
# If you be a man and learn how to use printf, it automatically accepts colors w/o escapes
#
# Explanation:
# Bash uses numeric codes to set attributes of the text to be displayed.
#
# Attribute codes:
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
#
# Text color codes:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
#
# Background color codes:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
#
# In the example above, me used the ANSI escape sequence "\033[attribute code;text color codem"
# to display a blue text. Therefore, we have to use -e option in calling echo to escape the input.
# Note that the color effect had to be ended by \033[0m to prevent the display of the prompt
# with different colors. However, the effects are sometimes interesting. I encourage you
# to play around with it.

# TO COMBINE TWO THINGS, such as a colored bacground with a different color text, you
# would just do this: echo -e "${BGRed}${BBlue}Hello, World!"

# Regular
RBLACK='\033[0;90m'        # Black
RRED='\033[0;91m'          # Red
RGREEN='\033[0;92m'        # Green
RYELLOW='\033[0;93m'       # Yellow
RBLUE='\033[0;94m'         # Blue
RPURPLE='\033[0;95m'       # Purple
RCYAN='\033[0;96m'         # Cyan
RWHITE='\033[0;97m'        # White

# Bold (light)
BBLACK='\033[1;90m'        # Black
BRED='\033[1;91m'          # Red
BGREEN='\033[1;92m'        # Green
BYELLOW='\033[1;93m'       # Yellow
BBLUE='\033[1;94m'         # Blue
BPURPLE='\033[1;95m'       # Purple
BCYAN='\033[1;96m'         # Cyan
BWHITE='\033[1;97m'        # White

# Italic (doesn't work in most terminals)
IBLACK='\033[3;90m'        # Black
IRED='\033[3;91m'          # Red
IGREEN='\033[3;92m'        # Green
IYELLOW='\033[3;93m'       # Yellow
IBLUE='\033[3;94m'         # Blue
IPURPLE='\033[3;95m'       # Purple
ICYAN='\033[3;96m'         # Cyan
IWHITE='\033[3;97m'        # White

# Underline
UBLACK='\033[4;90m'        # Black
URED='\033[4;91m'          # Red
UGREEN='\033[4;92m'        # Green
UYELLOw='\033[4;93m'       # Yellow
UBLUE='\033[4;94m'         # Blue
UPURPLE='\033[4;95m'       # Purple
UCYAN='\033[4;96m'         # Cyan
UWHITE='\033[4;97m'        # White

# Blinking AND Underline
BUBLACK='\033[5;4;90m'        # Black
BURED='\033[5;4;91m'          # Red
BUGREEN='\033[5;4;92m'        # Green
BUYELLOW='\033[5;4;93m'       # Yellow
BUBLUE='\033[5;4;94m'         # Blue
BUPURPLE='\033[5;4;95m'       # Purple
BUCYAN='\033[5;4;96m'         # Cyan
BUWHITE='\033[5;4;97m'        # White

# Background
BGBLACK='\033[40m'       # Black
BGRED='\033[41m'         # Red
BGGREEN='\033[42m'       # Green
BGYELLOW='\033[43m'      # Yellow
BGBLUE='\033[44m'        # Blue
BGPURPLE='\033[45m'      # Purple
BGCYAN='\033[46m'        # Cyan
BGWHITE='\033[47m'       # White

# Blinking
BLBLACK='\033[5;90m'   # Black
BLRED='\033[5;91m'     # Red
BLGREEN='\033[5;92m'   # Green
BLYELLOW='\033[5;93m'   # Yellow
BLBLUE='\033[5;94m'   # Blue
BLPURPLE='\033[5;95m'   # Purple
BLCYAN='\033[5;96m'   # Cyan
BLWHITE='\033[5;97m'   # White

# Reset Color
RESET='\033[0m'
