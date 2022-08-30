# Minimalistic bash theme based on Common ZSH theme

# Prompt symbol
BAKSHO_PROMPT_SYMBOL="❯"

# ANSI colors
DIR_COLOR="\e[0;36m" # cyan
RESET="\e[0m"
PROMPT_COLOR="\e[1;35m" # purple

# terminfo database, check total colors with `tput colors`
# black, red, green, yellow, blue, magenta, cyan, white, orange
#   0      1    2       3      4     5        6     7     166
yellow=$(tput setaf 3)
green=$(tput setaf 2)
red=$(tput setaf 1)
orange=$(tput setaf 166)
reset=$(tput sgr0)

# Get last return status
__return_status() {
    local exit="$?"
    local message=""
    if [ $exit -ne 0 ]; then
        printf "$red$exit$reset "
    fi
}

# Git status
__git_status() {
    local symbol=""
    local message=""
    local message_color="$green"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="$orange"
        symbol=" +"
    elif [[ -n ${unstaged} ]]; then
        message_color="$yellow"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}${symbol} "
    fi

    printf " ${message}"
}

# Get abbreviated present working directory
__abbreviated_pwd() {
    local message=""
    local p="${PWD#${HOME}}"
    if [ "${PWD}" != "${p}" ]; then
        message+="~"
    fi
    IFS=/;
    for q in ${p:1}; do
        message+="/${q:0:1}"
    done
    message+="${q:1}"
    printf "${DIR_COLOR}$message${RESET}"
}

# Set prompt
__set_prompt() {
    printf "${PROMPT_COLOR}${BAKSHO_PROMPT_SYMBOL}${RESET} "
}

# evaluate return status and print that first
PROMPT_COMMAND=__return_status

PROMPT="\$(__abbreviated_pwd)\$(__git_status)\$([ \j -gt 0 ] && echo -n ↓\j)\$(__set_prompt)"

PS1="$PROMPT"
