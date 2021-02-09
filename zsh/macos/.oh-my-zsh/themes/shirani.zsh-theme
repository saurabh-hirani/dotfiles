# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  SEGMENT_SEPARATOR=$'\ue0b0' # 
  LEFT_SEGMENT_SEPARATOR=$'\ue0b2' # left triangle
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
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

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {

  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

prompt_hg() {
  local rev status
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if `hg st | grep -q "^\?"`; then
        prompt_segment red black
        st='±'
      elif `hg st | grep -q "^[MA]"`; then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue black '%1~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

prompt_chef() {
  if [[ $CHEF_ENV != '' ]]; then
    current_dir_basename=$(basename $(pwd))
    allowed_chef_data_dirs='^(environment|environments|role|roles|data_bag|data_bags)$'
    if [[ -f "$(pwd)/metadata.rb" ]] ||  $(echo $current_dir_basename | egrep -q $allowed_chef_data_dirs); then
      prompt_segment black default "$CHEF_ENV"
    fi
  fi
}

##### simple todo #####

export CURRENT_TASK_FILE='/tmp/todo/current-task'
export TODO_LOG_FILE="$HOME/todo/work.log"
export TODO_DATE_FMT="+%Y.%m.%d-%H:%M:%S"

MAC_COREUTILS_DATE='/usr/local/bin/gdate'
if [[ -f $MAC_COREUTILS_DATE ]]; then
  export DATECMD="$MAC_COREUTILS_DATE" 
else
  export DATECMD="$(which date)" 
fi

mkdir -p $HOME/todo
mkdir -p /tmp/todo
touch $TODO_LOG_FILE

# https://unix.stackexchange.com/questions/27013/displaying-seconds-as-days-hours-mins-seconds/170299
function displaytime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  printf '%dd|' $D
  printf '%dh|' $H
  printf '%dm|' $M
  printf '%ds\n' $S
}

log_task_data() {
  msg=$1
  echo "time:$($DATECMD "$TODO_DATE_FMT") $msg" >> $TODO_LOG_FILE
}

calc_task_time() {
  target_file=$1
  if [[ -z $target_file ]]; then
    target_file=$CURRENT_TASK_FILE 
  fi
  curr_time=$($DATECMD +%s)
  last_mtime=$(stat -s $target_file | awk '{print $10}'  | cut -f2 -d'=')

  total_time_spent=$(echo "$curr_time - $last_mtime" | bc )
  total_time_spent_str=$(displaytime $total_time_spent)

  echo $total_time_spent_str
}

task_status() {
  task=$(cat $CURRENT_TASK_FILE)
  total_time_spent_str=$(calc_task_time)

  msg=$1

  if [[ -z $msg ]]; then
    if [[ -z $task ]]; then
      export TASK_STATE='idle'
      task="nothing_planned"
    fi
  fi

  msg="task:[$task] state:$TASK_STATE time_spent:[$total_time_spent_str]"

  echo $msg
}

task_report() {
  task=$1
  if [[ -z $task ]]; then
    if [[ -f $CURRENT_TASK_FILE ]]; then
      task=$(cat $CURRENT_TASK_FILE)
    fi
  fi
  grep "task:\[$task\]" $TODO_LOG_FILE
}

task_report_today() {
  today=$($DATECMD "+%Y.%m.%d")
  grep "time:$today" $TODO_LOG_FILE
}

task_report_yesterday() {
  yesterday=$($DATECMD --date='1 day ago' "+%Y.%m.%d")
  grep "time:$yesterday" $TODO_LOG_FILE
}

task_report_month() {
  month=$($DATECMD "+%Y.%m")
  grep "time:$month" $TODO_LOG_FILE
}

task_report_list_all_tasks() {
  grep ' task:' $TODO_LOG_FILE | cut -f2 -d' '  | cut -f2 -d'[' | tr -d ']' | sort | uniq
}

task_report_list_done_tasks() {
  grep ' task:' $TODO_LOG_FILE | grep 'state:done'
}

task_clear() {
  if [[ -f $CURRENT_TASK_FILE ]]; then
    task=$(cat $CURRENT_TASK_FILE)
    total_time_spent_str=$(calc_task_time)

    export TASK_STATE='done'
    msg="task:[$task] state:$TASK_STATE total_time_spent:[$total_time_spent_str]"
    log_task_data $msg

    task_report
    echo > $CURRENT_TASK_FILE
  fi
}

task_complete() {
  task_clear
}

task_reset() {
  if [[ -f $CURRENT_TASK_FILE ]]; then
    task=$(cat $CURRENT_TASK_FILE)

    export TASK_STATE='inprogress'
    msg="task:[$task] state:$TASK_STATE"
    echo $msg
    log_task_data $msg

    touch $CURRENT_TASK_FILE
  fi
}

task_pause() {
  if [[ -f $CURRENT_TASK_FILE ]]; then
    reason=$1

    if [[ -z $reason ]]; then
      reason='na'
    fi

    if [[ -f $CURRENT_TASK_FILE ]]; then
      echo $reason > ${CURRENT_TASK_FILE}.pause
      export TASK_STATE='pause'
      msg="task:[$task] state:$TASK_STATE reason:$reason"
      log_task_data $msg
    fi
  fi
}

task_resume() {
  if [[ -f $CURRENT_TASK_FILE ]] && [[ -f ${CURRENT_TASK_FILE}.pause ]]; then

    reason=$1

    if [[ -z $reason ]]; then
      reason=$(cat ${CURRENT_TASK_FILE}.pause)
    fi

    total_time_paused_str=$(calc_task_time ${CURRENT_TASK_FILE}.pause)

    rm -f ${CURRENT_TASK_FILE}.pause

    export TASK_STATE='inprogress'
    msg="task:[$task] state:$TASK_STATE time_paused:[$total_time_paused_str] reason:$reason"

    log_task_data $msg
  fi
}

task_checkin() {
  task_resume 'checkin'
}

task_checkout() {
  task_pause 'checkout'
}

task_start() {
  task=$1

  echo $task > $CURRENT_TASK_FILE

  export TASK_STATE='inprogress'
  msg="task:[$task] state:$TASK_STATE"
  log_task_data $msg
  task_status $msg
}

build_rprompt() {
  RETVAL=$?
  msg=$1
  if [[ -z $msg ]]; then
    if [[ -f $CURRENT_TASK_FILE ]]; then
      msg="$(task_status)"
    fi
  fi
  prompt_status
  prompt_segment black green "$msg"
  prompt_end
}

##### simple todo #####

## Main prompt
build_lprompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_chef
  prompt_git
  prompt_hg
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_lprompt) 
➙ '
RPROMPT='%{%f%b%k%}$(build_rprompt)'
