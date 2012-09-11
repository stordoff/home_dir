# Color vaiables
YEL_ON_RED="33;1;41m"

# Add ~/bin to the path if it exists
if [ -d $HOME/bin ] ; then
 PATH=$HOME/bin:$PATH
fi

# Distinguish sudo shells
export SUDO_PS1="\[\e[$YEL_ON_RED\][\u] \w \$\[\e[0m\] "
export PS1="\u@\h:\W \$ "

# Bash Options
shopt -s checkwinsize

# Load shell dotfiles
for file in $HOME/.{aliases,functions}; do
  [ -r "$file" ] && source "$file"
done
unset file

## Check that offsite backup has been completed 
# Checks .backup_date for last date, and warns if it is over
# one week ago

if [ -e .backup_date ]; then
  last_backup=$(cat .backup_date)
else
  last_backup=0
fi

seconds_in_week=604800     # 60*60*24*7
backup_due=$(($(date +%s)-$seconds_in_week))

if [[ "$last_backup" -le "$backup_due" ]] ; then

# which -s perl would also work
# Need to determine if this is likely to run on perlless system
if which perl &> /dev/null; then
  warning "Last offsite backup was over one week ago"
else
  echo "Warning: Last offsite backup was over one week ago"
fi
echo "Use ~/bin/backup_weekly to update"

else
  echo "Last backup is good"
fi
