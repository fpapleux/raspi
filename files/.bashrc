# My prompt
PS1="\n💻  \033[38;5;255m\033[48;5;33m  \d \t  \033[38;5;255m\033[48;5;0m @ \w \033[38;5;46m\033[48;5;0m\n\u $ "

# My Aliases
alias ll='ls -lp'
alias la='ls -lap'
alias c='clear'
alias cd..='cd ..'
alias countlines="find -L . -name '*.java' -exec cat {} + | wc"

#My functions

function findlinks() {
	find -L /bin /sbin /usr /Library /System /var /Applications /etc -samefile "$@" -ls 2>>~/errors.log;
}

# My other shit
# export JAVA_HOME="/Library/Java/Home"
# export JRE_HOME=/Library/Java/Home/jre
export CATALINA_HOME="/usr/local/tomcat7"
export ANT_HOME=/usr/local/ant


##
# Your previous /Users/fabien/.bash_profile file was backed up as /Users/fabien/.bash_profile.macports-saved_2013-11-09_at_22:54:45
##

# MacPorts Installer addition on 2013-11-09_at_22:54:45: adding an appropriate PATH variable for use with MacPorts.

export PATH=$PATH:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:usr/local/bin/node:/usr/local/bin/npm

# Finished adapting your PATH environment variable for use with MacPorts.

