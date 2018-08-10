PROMPT='%{$fg_bold[white]%}[%{$fg_bold[cyan]%}%T%{$fg_bold[green]%}%{$fg_bold[white]%}] %{$fg_bold[red]%}%n%{$fg[magenta]%}@%{$fg_bold[grey]%}%m %{$fg_bold[green]%}%d %{$fg_bold[green]%}%p %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$fg_bold[blue]%}$(svn_prompt_info)%{$fg_bold[blue]%} % 
%{$fg[cyan]%}%c %{$fg_bold[red]%}➜ %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

