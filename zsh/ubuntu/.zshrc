# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf fzf-zsh-plugin zsh-autosuggestions tmux autojump docker)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ -s /home/vboxuser/.autojump/etc/profile.d/autojump.sh ]] && source /home/vboxuser/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)

## path changes start
export PATH="$PATH:/home/vboxuser/.local/bin/"
## path changes end

export EDITOR='vim'

bindkey '^R' history-incremental-search-backward
bindkey -v 
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# bindkey '^I'   complete-word       # tab          | complete
# bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest

## fzf changes start
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf ctrl-r and alt-c behavior
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

function vif() {
    local fname
    fname=$(fzf) || return
    vim "$fname"
}

_fzf_compgen_path() {
  fd --type f --hidden --follow --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type d . "$1"
}
source <(fzf --zsh)
## fzf changes end

## tmux changes start
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
  tmux-send-keys-to-all-windows "$cmd
"
}

tmux-send-cmd-to-all-panes() {
  local cmd=$1
  tmux-send-keys-to-all-panes "$cmd
"
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

## tmux changes end

## aws changes start

alias aws-clear-env='env | \grep AWS | while read line; do var=$(echo $line|cut -f1 -d'='); echo $var; unset $var; done'
alias aws-show-env='env | \grep AWS'

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

## aws changes end

## history settings changes start

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

## history settings changes end

source ~/.aliasrc

set -o vi
