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
perl <<'EOF'
use strict;
use Term::ANSIColor;

print color 'red';
print 'Warning: Last offsite backup was over one week ago'."\n";
print color 'reset';
EOF

else
  echo "Warning: Last offsite backup was over one week ago"
fi
echo "Use ~/bin/backup_weekly to update"

else
  echo "Last backup is good"
fi

# Add ~/bin to the path if it exists
if [ -d $HOME/bin ] ; then
 PATH=$HOME/bin:$PATH
fi

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
        colorflag="--color"
else # OS X `ls`
        colorflag="-G"
fi

alias ls="ls ${colorflag}"
