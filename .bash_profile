function crc32 { cksum -o3 "$@"|ruby -e 'STDIN.each{|a|a=a.split;printf
 "%08X\t%s\n",a[0],a[2..-1].join(" ")}'; }


PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/opt/local/bin/:~/bin/
#PS1="\[\e[1;47m\]\e[1;31m[\d]\e[0m \[\u@\h:\w]$\[\033[0m\] "

##
# Your previous /Users/kenshin/.bash_profile file was backed up as /Users/kenshin/.bash_profile.macports-saved_2010-12-14_at_16:04:54
##

# MacPorts Installer addition on 2010-12-14_at_16:04:54: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH:/Users/kenshin/playground/timesten/TimesTen/timesten_dev/lib

# Finished adapting your PATH environment variable for use with MacPorts.


# Settings for Mapnik.framework Installer to enable Mapnik programs and python bindings
export PATH=/Library/Frameworks/Mapnik.framework/Programs:$PATH://Users/kenshin/playground/timesten/TimesTen/timesten_dev/lib:/Users/dedenf/binapp:/Users/dedenf/.rvm/bin
export PYTHONPATH=/Library/Frameworks/Mapnik.framework/Python:$PYTHONPATH


# -*- shell-script -*-
# Rasmus Andersson

# BEGIN Mac OS X specific
alias esed='sed -E'
export CLICOLOR=1
export LSCOLORS=ExGxcxdxCxegedabagacad
alias l='ls -lAFh'
if [ -d /opt ]; then
	export PATH=/opt/local/bin:/opt/local/sbin:$PATH
	export MANPATH=$MANPATH:/opt/local/share/man
	if [ -f /opt/local/etc/bash_completion ]; then
		. /opt/local/etc/bash_completion
	fi
fi
#rgrep() { mdfind -0 -onlyin "$1" "$2" | xargs -0 grep --color "$2" }
#rfind() { mdfind -onlyin "$1" "$2" }
export GOOS=darwin
export LANG=en_US.UTF-8
# END Mac OS X specific

# Everything below here should be in sync with other bashrc-* files

# General stuff
umask 022
export HISTCONTROL=ignoredups
shopt -s checkwinsize cmdhist
export EDITOR=nano
alias e='emacsclient -n'

# User binaries
export PATH=$HOME/bin:$HOME/src/depot_tools:$PATH

# Pygments less
if [ "$(which pygmentize)" != "" ] ;then
	pyglessfilter() {
		pygmentize -l diff -O bg=dark -P encoding=utf-8 | /usr/bin/less --no-lessopen -R
	}
	if [ -x ~/bin/less-colorize.sh ]; then
		export LESSOPEN="| ${HOME}/bin/less-colorize.sh %s"
		export LESS='-R'
	fi
else
	alias pyglessfilter='cat'
fi

# ack
export ACK_PAGER="/usr/bin/less -R"

# ec2 CLI tools
if [ -d ~/.ec2 ]; then
  export EC2_HOME="$HOME/.ec2"
  export PATH=$PATH:$EC2_HOME/bin
  export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
  export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
  if [ -z $JAVA_HOME ]; then
    export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/
  fi
fi

# RCS/VCS
st() {
	if [ -d .hg ]; then
		hg -v status $*
	elif [ -d .svn ]; then
		svn st $* | perl -we 'local $endpiece=""; local @conflicts=(); while(<>){
			if(m/^X/) { print "\033[1;30m"; }
			elsif(m/^[D!~]/) { print "\033[1;31m"; }
			elsif(m/^A/) { print "\033[1;32m"; }
			elsif(m/^[MR]/) { print "\033[1;36m"; }
			elsif(m/^ M/) { print "\033[36m"; }
			elsif(m/^(?:C|.C)/) { print "\033[1;33m"; push(@conflicts, $_); }
			elsif(m/^[IP]erforming status on external item/) {
				print "\033[1;30m";
				s/\'"'"'(.[^\'"'"']+)\'"'"'\n/\033[m$1\033[1;30m/gm;
				$endpiece = "\n";
			}
			if(m/^..L/) { s/^(..)L/$1\033[40mL/; }
			print ;
			print "\033[0m";
		};
		print $endpiece;
		if(@conflicts) {
			print "$endpiece\033[1m\033[41mConflicts:\033[0m \n", @conflicts;
		}'
	else
		git status $*
	fi
}
alias ci='git ci'
alias hgci='hg commit -m'
alias svnci='svn ci -m'
#df() {
#	if [ -d .svn ]; then
#		svn diff -x -u -x -b $* | pyglessfilter
#	else
#		git diff $*
#	fi
#}

# SSH aliases


# Misc
alias grep='grep -i --color'
export GREP_COLOR='40;01;31'
# recursive diff: rdiff [options to diff] diroriginal dirmodified
alias rdiff='diff -ruNx .DS_Store -x "~*" -x "._*"'
export PYTHONSTARTUP="$HOME/.pystartup"

# Git status for prompt
function parse_git_dirty {
	[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
	git branch --no-color 2> /dev/null \
	| sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# Prompt
alias _userpwd='/usr/bin/perl -e '"'"'use Cwd;my $d=cwd();my $h=$ENV{"HOME"};my $dl=length($d);my $hl=length($h);if(($dl>=$hl)&&($h==substr($d,$hl))){print "~".substr($d,$hl,$dl);}else{print $d;}'"'"
_PS1prefix="\[\e[40;32;1m\]>>> "
_PS1user="\[\e[31;1m\]\u"
_PS1meta1="\[\e[0;40m\]@\h\[\e[0;40m\]:\[\e[33;1m\]\w \[\e[0;1;30m\] \t \[\e[36;1m\]"
_PS1meta2git="\[\e[32;1m\]\$(parse_git_branch) \[\e[36;1m\]"
_PS1end="\n\[\e[36;1m\]\\$\[\e[0m\] "
export PS1="$_PS1prefix$_PS1user$_PS1meta1$_PS1meta2git$_PS1end"
# this sets the title of the window
# user@host:path [HH:MM]
#export PROMPT_COMMAND='echo -ne "\033]0;`id -un`@`hostname -s`:`_userpwd` [$(date +%H:%M)]\007"'
# host:path
export PROMPT_COMMAND='echo -ne "\033]0;`hostname -s`:`_userpwd`\007"'


##
# Your previous /Users/dedenf/.bash_profile file was backed up as /Users/dedenf/.bash_profile.macports-saved_2011-08-10_at_15:56:28
##

# MacPorts Installer addition on 2011-08-10_at_15:56:28: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

gitpulls() {
  echo "$(find . -name '.git' | sort)" | while read i; do
    cd "$(dirname ${i})"
    echo ">>>> pulling $(dirname ${i#./}) ... <<<<"
    git pull
    echo ''
    cd - > /dev/null;
  done
  unset i
}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
source /Users/dedenf/.rvm/scripts/rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
