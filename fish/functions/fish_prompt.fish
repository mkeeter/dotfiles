function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _jj_branch_name
  echo (command jj --no-pager log --no-graph -r '@' -T 'branches' 2> /dev/null)
end
function _jj_prev_branch_name
  echo (command jj --no-pager log --no-graph -r '@-' -T 'branches' 2> /dev/null)
end
function _jj_rev_name
  echo (command jj --no-pager log --no-graph -r @ -T 'change_id.shortest() ++ if(self.empty(), " (empty)", "")' 2> /dev/null)
end

function _is_git_dirty
  set -l show_untracked (git config --bool bash.showUntrackedFiles)
  set -l untracked
  if [ "$theme_display_git_untracked" = 'no' -o "$show_untracked" = 'false' ]
    set untracked '--untracked-files=no'
  end
  echo (command git status -s --no-optional-locks --ignore-submodules=dirty $untracked 2> /dev/null)
end

function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l magenta (set_color magenta)
  set -l brmagenta (set_color brmagenta)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  if test $last_status = 0
      set arrow "$green➜ "
  else
      set arrow "$red➜ "
  end
  set -l cwd $cyan(basename (prompt_pwd))

  if [ (_git_branch_name) ]
    set -l git_branch $red(_git_branch_name)
    set git_info "$blue git:($git_branch$blue)"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  if [ (_jj_branch_name) ]
    set -l jj_branch $normal$magenta(_jj_branch_name)
    set jj_info "$blue jj:($jj_branch$blue)"
  else if [ (_jj_prev_branch_name) ]
    set -l jj_branch $normal$magenta(_jj_prev_branch_name)
    set -l jj_rev $normal$brmagenta(_jj_rev_name)
    set jj_info "$blue jj:($jj_branch+,$jj_rev$blue)"
  else if [ (_jj_rev_name) ]
    set -l jj_rev $normal$brmagenta(_jj_rev_name)
    set jj_info "$blue jj:($jj_rev$blue)"
  end

  echo -n -s $arrow ' ' $cwd $git_info $jj_info $normal ' '
end
