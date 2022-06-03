function reload_zsh {
    source ~/.zshrc
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
        cached_files="%{%F{121}%} ●"
    fi
 
    # Check for untracked files
    untracked_files=""
    if [[ $(git ls-files --exclude-standard --others 2> /dev/null | cat) != "" ]]; then
        untracked_files="%{%F{210}%} ●"
    fi

    virtual_env=""
    if [[ $VIRTUAL_ENV ]]; then
        virtual_env="${grey}(`basename $VIRTUAL_ENV`)${grey} "
    fi
    NEWLINE=$'\n'

    export PS1="${virtual_env} %F{218}%}%n@%m %{%F{159}%}%~ %F{183}$(current_git_branch)${cached_files}${untracked_files} ${NEWLINE} %F{255}%% "
    export RPROMPT="%F{230}%T - %W"

}

[ ${ZSH_VERSION} ] && precmd() { prompt_command; }


# Don't match .pyc files when tab-completing in bash
export FIGNORE=$FIGNORE:.pyc
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
