# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

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
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_folders
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)	
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs)
POWERLEVEL9K_MODE=”nerdfont-complete”
POWERLEVEL9K_VCS_GIT_ALWAYS_SHOW_REMOTE_BRANCH='1' 
#POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
#POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "

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
plugins=(git gitfast tmux autojump knife docker zsh-autosuggestions)

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

# path
export PATH="/usr/local/opt/ruby/bin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/python:$HOME/Library/Python/2.7/bin/:$PATH"

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
alias aws-clear-env='env | grep AWS | while read line; do var=$(echo $line|cut -f1 -d'='); echo $var; unset $var; done'
alias aws-show-env='env | grep AWS'
alias diffdir='diff -qr'
alias perlpie='perl -pi -e'

source ~/.aliasrc

#complete -C '/usr/local/bin/aws_completer' aws
source /usr/local/bin/aws_zsh_completer.sh

export GOPATH=~/go/packages
export PATH="$PATH:$GOPATH/bin"

export LESSOPEN="|tar --to-stdout -zxf %s"

export MY_ENV_VARS_FILE="$HOME/.envvars"

if [[ -f $MY_ENV_VARS_FILE ]]; then
  source $MY_ENV_VARS_FILE
fi

# powerline
export POWERLINE_CONFIG_COMMAND="/usr/local/bin/powerline-config"
source /usr/local/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh

tmux-send-keys-to-all-windows() {
  local keys=$1
  curr_tmux_session=$(tmux display-message -p '#S')
  for window in $(tmux list-windows | cut -f1 -d':'); do
    tmux send-keys -t $curr_tmux_session:$window "$keys"
  done
}

tmux-send-cmd-to-all-windows() {
  local cmd=$1 
  tmux-send-keys-to-all-windows "$cmd "
}

tmux-env-set() {
  local var_name=$1
  local var_value=$2

  if ! [[ -f "$MY_ENV_VARS_FILE" ]]; then
    touch $MY_ENV_VARS_FILE
  fi

  local set_env_var_cmd="export $var_name=$var_value"
  local set_env_var_regex="^${set_env_var_cmd}$"

  local curr_value=$(egrep "$set_env_var_regex" $MY_ENV_VARS_FILE)
  if ! [[ $? -eq 0 ]]; then
    #egrep -v "$set_env_var_regex" $MY_ENV_VARS_FILE > $MY_ENV_VARS_FILE.tmp ; mv $MY_ENV_VARS_FILE.tmp  $MY_ENV_VARS_FILE
    echo "unset $var_name"  | tee -a  $MY_ENV_VARS_FILE
    unset $var_name
  fi
  echo "$set_env_var_cmd" | tee -a $MY_ENV_VARS_FILE

  tmux-send-cmd-to-all-windows "source $MY_ENV_VARS_FILE"
}

tmux-env-unset() {
  local var_name=$1

  if ! [[ -f "$MY_ENV_VARS_FILE" ]]; then
    touch $MY_ENV_VARS_FILE
  fi

  local set_env_var_cmd="export $var_name="
  local set_env_var_regex="^${set_env_var_cmd}"

  if egrep -q $set_env_var_regex $MY_ENV_VARS_FILE; then
    #egrep -v "$set_env_var_regex" $MY_ENV_VARS_FILE > $MY_ENV_VARS_FILE.tmp ; mv $MY_ENV_VARS_FILE.tmp $MY_ENV_VARS_FILE
    echo "unset $var_name"  | tee -a $MY_ENV_VARS_FILE
  else
    echo "$var_name: not set"
  fi

  tmux-send-cmd-to-all-windows "source $MY_ENV_VARS_FILE"
}

tmux-env-reload() {
  tmux-send-cmd-to-all-windows "source $MY_ENV_VARS_FILE"
}

tmux-env-flush() {
  egrep '^export' $MY_ENV_VARS_FILE | cut -f2 -d' ' | cut -f1 -d'=' | while read var_name; do
    echo "unset $var_name" 
  done | tee $MY_ENV_VARS_FILE.flushing
  tmux-send-cmd-to-all-windows "source $MY_ENV_VARS_FILE.flushing"
  echo > $MY_ENV_VARS_FILE
}

knife-profiles() {
  ls -1A ~/.chef | grep -vi knife
}

show-knife-profile() {
  local knife_profile=$1
  echo CHEF_ENV=$knife_profile
}

set-knife-profile() {
  local chef_env=$1
  tmux-env-set CHEF_ENV ${chef_env}
}

unset-knife-profile() {
  local chef_env=$1
  tmux-env-unset CHEF_ENV
}

aws-profiles() {
  cat ~/.aws/credentials | grep '\[' | grep -v '#' | tr -d '[' | tr -d ']'
}

show-aws-profile() {
  local aws_profile=$1
  profile_data=$(cat ~/.aws/credentials | grep "\[$aws_profile\]" -A4)  
  echo AWS_PROFILE=${aws_profile} 
  echo AWS_ACCESS_KEY_ID="$(echo $profile_data | grep aws_access_key_id | cut -f2 -d'=' | tr -d ' ')"  AWS_SECRET_ACCESS_KEY="$(echo $profile_data | grep aws_secret_access_key | cut -f2 -d'=' | tr -d ' ')"
}

set-aws-profile() {
  local aws_profile=$1
  profile_data=$(cat ~/.aws/credentials | grep "\[$aws_profile\]" -A4)  
  tmux-env-set AWS_PROFILE ${aws_profile} 
  tmux-env-set AWS_ACCESS_KEY_ID "$(echo $profile_data | tail -n +3 | head -1 | cut -f2 -d' ' | tr -d ' ')"
  tmux-env-set AWS_SECRET_ACCESS_KEY "$(echo $profile_data | tail -n +4 | head -1 | cut -f2 -d' ' | tr -d ' ')"
}

unset-aws-profile() {
  local aws_profile=$1
  profile_data=$(cat ~/.aws/credentials | grep "\[$aws_profile\]" -A4)  
  tmux-env-unset $AWS_PROFILE
  tmux-env-unset $AWS_ACCESS_KEY_ID
  tmux-env-unset $AWS_SECRET_ACCESS_KEY
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

source ~/.oh-my-zsh/completions/tmuxinator.zsh

disable r

export DISABLE_AUTO_TITLE=true
export TRACKME_DISPLAY=true

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

