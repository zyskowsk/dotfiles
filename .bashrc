# Color Definitions
white='\[\e[1;37m\]'
red='\[\e[0;31m\]'
RED='\[\e[1;31m\]'
green='\[\e[0;32m\]'
GREEN='\[\e[1;32m\]'
yellow='\[\e[0;33m\]'
YELLOW='\[\e[1;33m\]'
blue='\[\e[0;34m\]'
BLUE='\[\e[1;34m\]'
purple='\[\e[0;35m\]'
PURPLE='\[\e[1;35m\]'
cyan='\[\e[0;36m\]'
CYAN='\[\e[1;36m\]'
grey='\[\e[0;37m\]'
NC='\[\e[0m\]'              # No Color
BOLD='\[\e[1m\]'

# check the window size after each command, and if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# reload bashrc
function reload_bashrc {
    source ~/.bashrc
    echo "bash reloaded."
}

## Get git branch
function current_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ [\1]/"
}

# Build prompt
function prompt_command {
    # Check for modified files
    if [[ $(git diff-files 2> /dev/null | cat) != "" ]]; then
        git_color=${RED}
    else
        git_color=${NC}
    fi

    # Check for staged files
    cached_files=""
    if [[ $(git diff-index --cached HEAD 2> /dev/null | cat) != "" ]]; then
        cached_files="${green} ●"
    fi
 
    # Check for untracked files
    untracked_files=""
    if [[ $(git ls-files --exclude-standard --others 2> /dev/null | cat) != "" ]]; then
        untracked_files="${cyan} ●"
    fi

    virtual_env=""
    if [[ $VIRTUAL_ENV ]]; then
        virtual_env="${grey}(`basename $VIRTUAL_ENV`)${grey} "
    fi

    export PS1="${virtual_env}${cyan}[\u${green}@${cyan}\h][${green}\w${cyan}]${git_color}\$(current_git_branch)${cached_files}${untracked_files}${NC}\n${white}> "
}

PROMPT_COMMAND=prompt_command

# Don't match .pyc files when tab-completing in bash
export FIGNORE=$FIGNORE:.pyc

alias activate='. env/bin/activate'
