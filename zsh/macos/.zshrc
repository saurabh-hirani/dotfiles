# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin/:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$PATH:/opt/homebrew/opt/findutils/libexec/gnubin"
export PATH="$HOME/go/bin:$PATH"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="$HOME/.tfenv/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:/usr/local/opt/ruby/bin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/python:$HOME/Library/Python/3.7/bin/:/usr/local/opt/mysql-client/bin"

. ~/.linuxify

ZSH_THEME="powerlevel9k/powerlevel9k"

darken() {
  export THEME=dark
  # export BAT_THEME=default
  it2prof dark
  reload_profile
}

lighten() {
  unset THEME
  export BAT_THEME=ansi-light
  it2prof light
  reload_profile
}

whiten() {
  unset THEME
  it2prof white
  reload_profile
  export BAT_THEME=ansi-light
}

it2prof() {
  if [[ "$TERM" =~ "screen" ]]; then
    scrn_prof "$1"
  else
    # send escape sequence to change iTerm2 profile
    echo -e "\033]50;SetProfile=$1\007"
  fi
}

scrn_prof() {
  if [ -n "$TMUX" ]; then
    # tell tmux to send escape sequence to underlying terminal
    echo -e "\033Ptmux;\033\033]50;SetProfile=$1\007\033\\"
  else
    # tell gnu screen to send escape sequence to underlying terminal
    echo -e "\033P\033]50;SetProfile=$1\007\033\\"
  fi
}

function reload_profile() {
  . $HOME/.zshrc
}


function set-powerlevel9k-color-scheme() {
  curr_session=$(tmux display-message -p '#S')
  mkdir -p "$HOME/tmux-sessions/$curr_session"

  echo $1 > $HOME/tmux-sessions/$curr_session/powerlevel9k-color-scheme
}

function get-powerlevel9k-color-scheme() {
  curr_session=$(tmux display-message -p '#S')
  mkdir -p "$HOME/tmux-sessions/$curr_session"
  file="$HOME/tmux-sessions/$curr_session/powerlevel9k-color-scheme"
  if [[ -f $file ]]; then
    cat $file
    return 0
  else
    set-powerlevel9k-color-scheme 'dark'
  fi
  echo 'dark'
}

func set-powerlevel9k-color-scheme-env() {
  color_scheme=$1
  if [[ $POWERLEVEL9K_COLOR_SCHEME == 'light' ]]; then
    POWERLEVEL9K_DIR_HOME_BACKGROUND='white'
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='white'
    POWERLEVEL9K_DIR_ETC_BACKGROUND='white'
    POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='white'

    POWERLEVEL9K_DIR_HOME_FOREGROUND='010'
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='010'
    POWERLEVEL9K_DIR_ETC_FOREGROUND='010'
    POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='010'

    POWERLEVEL9K_VCS_CLEAN_BACKGROUND='white'
    POWERLEVEL9K_VCS_CLEAN_FOREGROUND='010'

    POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='white'
    # POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='019'
    POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='016'

    POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='white'
    POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='016'
  else
    POWERLEVEL9K_DIR_HOME_BACKGROUND='004'
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='004'
    POWERLEVEL9K_DIR_ETC_BACKGROUND='004'
    POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='004'

    POWERLEVEL9K_DIR_HOME_FOREGROUND='black'
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='black'
    POWERLEVEL9K_DIR_ETC_FOREGROUND='black'
    POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='black'

    POWERLEVEL9K_VCS_CLEAN_BACKGROUND='002'
    POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'

    POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='002'
    POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'

    POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='003'
    POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'
  fi
}

function toggle-powerlevel9k-color-scheme() {
  curr_color_scheme=''
  curr_color_scheme=$(get-powerlevel9k-color-scheme)
  if [[ $curr_color_scheme == 'light' ]]; then
    new_color_scheme='dark'
  else
    new_color_scheme='light'
  fi
  set-powerlevel9k-color-scheme $new_color_scheme
  set-powerlevel9k-color-scheme-env $new_color_scheme
  echo $new_color_scheme
}

POWERLEVEL9K_COLOR_SCHEME=$(get-powerlevel9k-color-scheme)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=5
# POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right
POWERLEVEL9K_SHORTEN_STRATEGY=None
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_task_tracking_status_left dir rbenv vcs)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)

# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs custom_task_tracking_status_right)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs)

POWERLEVEL9K_MODE=”nerdfont-complete”
POWERLEVEL9K_VCS_GIT_ALWAYS_SHOW_REMOTE_BRANCH='1'
#POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
#POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "

POWERLEVEL9K_CUSTOM_TASK_TRACKING_STATUS_LEFT="custom_task_tracking_status_left"
POWERLEVEL9K_CUSTOM_TASK_TRACKING_STATUS_LEFT_BACKGROUND="blue"
POWERLEVEL9K_CUSTOM_TASK_TRACKING_STATUS_LEFT_FOREGROUND="black"

POWERLEVEL9K_CUSTOM_TASK_TRACKING_STATUS_RIGHT="custom_task_tracking_status_right"
POWERLEVEL9K_CUSTOM_TASK_TRACKING_STATUS_RIGHT_BACKGROUND="blue"
POWERLEVEL9K_CUSTOM_TASK_TRACKING_STATUS_RIGHT_FOREGROUND="black"

SEGMENT_SEPARATOR=$'\ue0b0'
LEFT_SEGMENT_SEPARATOR=$'\ue0b2'

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

custom_task_tracking_status_left() {
  [[ -f /tmp/track.stop ]] || echo -n "$(cat /tmp/task_tracking_status_left.txt)"
  # echo -n "%{%K{red}%}%{%F{black}%} 5050 %{%K{yellow}%}%{%F{black}%} 5050 %{%K{green}%}%{%F{black}%} 5050 %{%K{blue}%}%{%F{black}%} 50%% %{%K{red}%}%{%F{black}%} 60%%"

  # bg="%K{red}"
  # fg="%F{black}"
  # echo -n "%{$bg%}%{$fg%} 5050 "

  prompt_segment blue black "5050"
  prompt_end
}

custom_task_tracking_status_right() {
  [[ -f /tmp/track.stop ]] || echo -n "$(cat /tmp/task_tracking_status_right.txt)"
  #echo -n "%{%K{red}%}%{%F{black}%} 5050 %{%K{yellow}%}%{%F{black}%} 5050 %{%K{green}%}%{%F{black}%} 5050 %{%K{blue}%}%{%F{black}%} 50%% %{%K{red}%}%{%F{black}%} 60%%"

  # bg="%K{red}"
  # fg="%F{black}"
  # echo -n "%{$bg%}%{$fg%} 5050 "

  # prompt_segment blue black "5050"
  # prompt_end
}

function toggle-task-tracker() {
  if [[ -f /tmp/track.stop ]]; then
    rm /tmp/track.stop
  else
    touch /tmp/track.stop
  fi
}

set-powerlevel9k-color-scheme-env $POWERLEVEL9K_COLOR_SCHEME

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast tmux autojump knife docker zsh-autosuggestions fd kubectl fzf fzf-zsh-plugin)
export DISABLE_MAGIC_FUNCTIONS=true

source $ZSH/oh-my-zsh.sh

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
setopt NO_BEEP

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


export EDITOR='nvim'

# vi mode
set -o vi

# reverse search
bindkey -v
bindkey '^R' history-incremental-search-backward

# required by chefdk
if [[ -x "$(command -v chef >/dev/null 2>&1)" ]]; then
  eval "$(chef shell-init zsh)"
fi

# required by some term apps
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# aliases
alias toggle-prompt-color='toggle-powerlevel9k-color-scheme && reload_profile'
alias toggle-prompt-color-all="toggle-powerlevel9k-color-scheme && tmux-send-cmd-to-all-windows 'reload_profile'"
alias aws-clear-env='env | \grep AWS | while read line; do var=$(echo $line|cut -f1 -d'='); echo $var; unset $var; done'
alias aws-show-env='env | \grep AWS'

source ~/.aliasrc

[[ -f ~/.aliasrc.work ]] && source ~/.aliasrc.work

#complete -C '/usr/local/bin/aws_completer' aws
source /usr/local/bin/aws_zsh_completer.sh

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# export GOROOT='/usr/local/go'
export GOPATH=$HOME/go/
export GIT_TERMINAL_PROMPT=1

export LESSOPEN="|tar --to-stdout -zxf %s"

export MY_ENV_VARS_FILE="$HOME/.envvars"

if [[ -f $MY_ENV_VARS_FILE ]]; then
  source $MY_ENV_VARS_FILE
fi


# powerline
export POWERLINE_CONFIG_COMMAND="/opt/homebrew/bin/powerline-config"
source /opt/homebrew/lib/python3.10/site-packages/powerline/bindings/zsh/powerline.zsh

tmux-send-keys-to-all-windows() {
  local keys=$1
  curr_tmux_session=$(tmux display-message -p '#S')
  for window in $(tmux list-windows | cut -f1 -d':'); do
    tmux send-keys -t $curr_tmux_session:$window "$keys"
  done
}

tmux-send-keys-to-all-panes() {
  local keys=$1
  for _pane in $(tmux list-panes -F '#P'); do
    tmux send-keys -t ${_pane} "$@"
  done
}

tmux-send-cmd-to-all-windows() {
  local cmd=$1
  tmux-send-keys-to-all-windows "$cmd "
}

tmux-send-cmd-to-all-panes() {
  local cmd=$1
  tmux-send-keys-to-all-panes "$cmd "
}

tmux-env-set() {
  local var_name=$1
  local var_value=$2

  if ! [[ -f "$MY_ENV_VARS_FILE" ]]; then
    touch $MY_ENV_VARS_FILE
  fi

  local set_env_var_cmd="export $var_name=$var_value"
  local set_env_var_regex="^${set_env_var_cmd}$"

  local curr_value=$(\grep -E "$set_env_var_regex" $MY_ENV_VARS_FILE)
  if ! [[ $? -eq 0 ]]; then
    #egrep -v "$set_env_var_regex" $MY_ENV_VARS_FILE > $MY_ENV_VARS_FILE.tmp ; mv $MY_ENV_VARS_FILE.tmp  $MY_ENV_VARS_FILE
    echo "unset $var_name"  | tee -a  $MY_ENV_VARS_FILE
    unset $var_name
  fi
  echo "$set_env_var_cmd" | tee -a $MY_ENV_VARS_FILE

}

tmux-env-reload() {
  tmux-send-cmd-to-all-windows "source $MY_ENV_VARS_FILE"
}

tmux-env-flush() {
  \grep -E '^export' $MY_ENV_VARS_FILE | cut -f2 -d' ' | cut -f1 -d'=' | while read var_name; do
    echo "unset $var_name"
  done | tee $MY_ENV_VARS_FILE.flushing
  tmux-send-cmd-to-all-windows "source $MY_ENV_VARS_FILE.flushing"
  echo > $MY_ENV_VARS_FILE
}

knife-profiles() {
  ls -1A ~/.chef | \grep -vi knife
}

show-knife-profile() {
  local knife_profile=$1
  echo CHEF_ENV=$knife_profile
}

set-knife-profile() {
  local chef_env=$1
  tmux-env-set CHEF_ENV ${chef_env}
  tmux-send-cmd-to-all-windows "source $MY_ENV_VARS_FILE"
}

aws-profiles() {
  cat ~/.aws/credentials | \grep '\[' | \grep -v '#' | tr -d '[' | tr -d ']'
}

aws-accounts() {
  cat ~/.zshrc.work | \grep export | \grep 'AWS_' | cut -f2 -d'=' | tr -d "'"
}

show-aws-account() {
  local aws_account=$1
  account_number=$(aws-accounts | \grep $aws_account)
  account_string=$(cat ~/.zshrc.work | \grep $account_number | cut -f2 -d' ')
  echo $account_number
  echo $account_string
}

show-aws-profile() {
  local aws_profile=$1
  profile_data=$(cat ~/.aws/credentials | \grep "\[$aws_profile\]" -A5)
  echo $profile_data | \grep '#' | tr ' ' '\n' | while read token; do
    if echo $token | \grep -q '#'; then continue; fi
    key=$(echo $token | cut -f1 -d ':' | tr '[a-z]' '[A-Z]')
    value=$(echo $token | cut -f2 -d ':')
    echo "$key: $value"
  done
  echo
  echo AWS_PROFILE=${aws_profile}
  echo AWS_ACCESS_KEY_ID="$(echo $profile_data | \grep aws_access_key_id | cut -f2 -d'=' | tr -d ' ')"
  echo AWS_SECRET_ACCESS_KEY="$(echo $profile_data | \grep aws_secret_access_key | cut -f2 -d'=' | tr -d ' ')"
  echo AWS_DEFAULT_REGION="$(echo $profile_data | \grep region| cut -f2 -d'=' | tr -d ' ')"
}

set-aws-profile-local() {
  local aws_profile=$1
  profile_data=$(cat ~/.aws/credentials | \grep "\[$aws_profile\]" -A5)
  export AWS_PROFILE=${aws_profile}
  export AWS_ACCESS_KEY_ID="$(echo $profile_data | tail -n +3 | head -1 | cut -f2 -d'=' | tr -d ' ')"
  export AWS_SECRET_ACCESS_KEY="$(echo $profile_data | tail -n +4 | head -1 | cut -f2 -d'=' | tr -d ' ')"
  export AWS_DEFAULT_REGION="$(echo $profile_data | tail -n +5 | head -1 | cut -f2 -d'=' | tr -d ' ')"
  tmux-env-set AWS_PROFILE ${aws_profile}
  tmux-env-set AWS_ACCESS_KEY_ID "$(echo $profile_data | tail -n +3 | head -1 | cut -f2 -d'=' | tr -d ' ')"
  tmux-env-set AWS_SECRET_ACCESS_KEY "$(echo $profile_data | tail -n +4 | head -1 | cut -f2 -d'=' | tr -d ' ')"
  tmux-env-set AWS_DEFAULT_REGION "$(echo $profile_data | tail -n +5 | head -1 | cut -f2 -d'=' | tr -d ' ')"
}

set-aws-profile() {
  set-aws-profile-local $1
  # tmux-send-cmd-to-all-windows "source $MY_ENV_VARS_FILE"
}

# COMPLETION SETTINGS
# source $MY_ENV_VARS_FILE.flushing
# dd custom completion scripts
fpath=(~/.oh-my-zsh/completions $fpath)

# compsys initialization
autoload -U compinit
compinit

# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2

if ! [[ -f $MY_ENV_VARS_FILE ]]; then
  touch $MY_ENV_VARS_FILE
fi

source $MY_ENV_VARS_FILE

if [[ -f ~/.trello ]]; then
  source ~/.trello
fi

# source /usr/local/share/zsh/site-functions/_tmuxinator

disable r

export DISABLE_AUTO_TITLE=true
export TRACKME_DISPLAY=true

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh

# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

[[ -f '/tmp/task_tracking_status_left.txt' ]] || touch /tmp/task_tracking_status_left.txt
[[ -f '/tmp/task_tracking_status_right.txt' ]] || touch /tmp/task_tracking_status_right.txt

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

[[ -f ~/.iterm2_shell_integration.zsh ]] && source ~/.iterm2_shell_integration.zsh

[[ -f ~/.zshrc.work ]] && source ~/.zshrc.work

[[ -f ~/.zprofile ]] && source ~/.zprofile

export PATH=$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')

eval "$(hub alias -s)"

# Do not export it so that bash or other shells don't mess it up
HISTFILE=~/.zsh_history
HISTFILESIZE=999999999
HISTSIZE=$HISTFILESIZE
SAVEHIST=$HISTSIZE

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.


# fzf ctrl-r and alt-c behavior
export FZF_BASE="/usr/bin/fzf"
# to overcome vscode existng ctrl+k, ctrl+j bindings
#
export FZF_DEFAULT_OPTS="-m --bind=ctrl-w:up,ctrl-o:down --history=$HOME/.fzf_history"

bindkey "¸" fzf-cd-widget
export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude \".git\" ."

bindkey "þ" fzf-file-widget
export FZF_CTRL_T_COMMAND="fd -t f --hidden --follow --exclude \".git\" ."

# fzf single quote tab completion behavior
export FZF_COMPLETION_TRIGGER="'"

export FZF_PREVIEW_COMMAND="COLORTERM=truecolor bat --style=numbers --color=always {}"

_fzf_compgen_path() {
  fd --type f --hidden --follow --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type d . "$1"
}

# allow vim save via ctrl-s
stty start undef
stty stop undef
setopt noflowcontrol

# TODO
export TODO_DIR="$HOME/work"
export TODO_FILE="$TODO_DIR/todo.txt"
export DONE_FILE="$TODO_DIR/done.txt"
export REPORT_FILE="$TODO_DIR/report.txt"
export TMP_FILE="/tmp/todo.tmp"
export TODOTXT_DEFAULT_ACTION=ls

# Thoughts
echo "Few things, right things, brilliantly executed."

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
