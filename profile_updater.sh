#!/bin/bash
VERSION=8


# DO NOT CHANGE ANYTHING ABOVE THIS LINE
# YOU'VE BEEN WARNED
#
# A script to setup new profiles on boxen. 
#
# This Script will update itself

#
# This is the URL This update script for check for updates
# Leave it as-is to keep in line with my updates (this repo), or change to your own

UPDATER_BASE_URL='https://raw.githubusercontent.com/rizlo100/Profile_updater/master/profile_updater.sh'

# 
# Files base URL
# This is where it will check for YOUR custom files

UPDATE_BASE_URL='http://YOURDOMAIN.HERE'

# 
# Update URL
# This is built using a combination of the $USER and $UPDATE_BASE_URL
# If your Locate does not include your username, remove ${USER} below

SOURCE_URL='echo ${UPDATE_BASE_URL}/${USER}'

#
# If your user directories are not /home change the below line

FILEBASE='/home'

#
# If your root user home directory is something other than /root
# Change this line

ROOTFILEBASE='/root'

#
# By default, all temp files are placed in /tmp change if you like

TMPBASE='/tmp'

# Some more variables 
# There should be no need to change these.
 
SCRIPTPATH=`which profile_updater.sh`
PID=$$
SELF=$(basename $0)
CURRENTUSER=`(whoami)`

# What are the files we will work with?
UPDATER=profile_updater.sh
BASHRC=bashrc
SSHKEYPUB=authorized_keys
VIMRC=vimrc


##### Some Functions That do the work #####

UpdateSelf () {
	# First, let's grab the new copy of this script
	if ! wget --quiet --output-document="$TMPBASE/$SELF.$PID" $UPDATER_BASE_URL/$SELF  ; then
    		echo "Failed: Error while trying to wget new version!"
  		echo "File requested: $UPDATER_BASE_URL/$SELF"
    		exit 1
  	fi	
  	echo "Done."

	NEW_VER=$( head -n 3 $TMPBASE/$SELF.$PID | grep VERSION | awk -F= '{print $2}')

	if [ "$VERSION" = "NOUPDATE" ]; then
		echo "You have marked this host to NOT update, EVER!"
	
	elif [ "$NEW_VER" -eq "$VERSION" ]; then
		echo "You are on the current version, no update needed"

	elif [ "$NEW_VER" -lt "$VERSION" ]; then
		echo "Local copy is newer than remote, might want to look"

	elif [ "$NEW_VER" -gt "$VERSION" ]; then
		echo "A new version was found, updating then exiting!"
		if mv "$TMPBASE/$SELF.$PID" "$SCRIPTPATH" ; then	
			chmod +x $SCRIPTPATH
			echo "$SELF Copied!"
			echo "Update Completed!"
			echo "Please re-run the program"
			if [ -e $TMPBASE/$SELF.$PID ]; then
				rm $TMPBASE/$SELF.$PID
			fi
			exit 0
		else
			echo "!!**UPDATE FAILED**!!"
		fi
	fi
        if [ -e $TMPBASE/$SELF.$PID ]; then
  	      rm $TMPBASE/$SELF.$PID
        fi

}	

UpdateBashrc () {
	# First, let's grab the new copy of the bashrc file 
        if ! wget --quiet --output-document="$TMPBASE/$BASHRC.$PID" $UPDATE_URL/$BASHRC  ; then
                echo "Failed: Error while trying to wget new version!"
                echo "File requested: $UPDATE_URL/$BASHRC"
                exit 1
        fi

	# Get some version info
	RCVER=$( head -n 5 $FILEBASE/$USER/.$BASHRC | grep VERSION | awk -F= '{print $2}')
	NEWRCVER=$( head -n 5 $TMPBASE/$BASHRC.$PID | grep VERSION | awk -F= '{print $2}')

        if [ "$RCVER" = "NOUPDATE" ]; then
                echo "You have marked this user/host to NOT update bashrc, EVER!"

        elif [ "$NEWRCVER" -eq "$RCVER" ]; then
                echo "You are on the current version of $BASHRC $RCVER, no update needed"

        elif [ "$NEWRCVER" -lt "$RCVER" ]; then
                echo "Local copy is newer than remote, might want to look"

        elif [ "$NEWRCVER" -gt "$RCVER" ]; then
                echo "A new version of bashrc was found, updating then exiting!"
                if mv "$TMPBASE/$BASHRC.$PID" "$FILEBASE/$USER/.$BASHRC" ; then
                        echo "$BASHRC Copied!"
                        echo "Update Completed!"
                        if [ -e $TMPBASE/$BASHRC.$PID ]; then
                                rm $TMPBASE/$BASHRC.$PID
                        fi
                else
                        echo "!!** $BASHRC UPDATE FAILED**!!"
                fi
        fi
        if [ -e $TMPBASE/$BASHRC.$PID ]; then
              rm $TMPBASE/$BASHRC.$PID
        fi
}

UpdateVimrc () {
	# First, let's grab the new copy of the vimrc file 
        if ! wget --quiet --output-document="$TMPBASE/$VIMRC.$PID" $UPDATE_URL/$VIMRC  ; then
                echo "Failed: Error while trying to wget new version!"
                echo "File requested: $UPDATE_URL/$VIMRC"
                exit 1
        fi

	# Get some version info
	VIMVER=$( head -n 5 $FILEBASE/$USER/.$VIMRC | grep VERSION | awk -F= '{print $2}')
	NEWVIMVER=$( head -n 5 $TMPBASE/$VIMRC.$PID | grep VERSION | awk -F= '{print $2}')

        if [ "$VIMVER" = "NOUPDATE" ]; then
                echo "You have marked this user/host to NOT update vimrc, EVER!"

        elif [ "$NEWVIMVER" -eq "$VIMVER" ]; then
                echo "You are on the current version of $VIMRC $RCVER, no update needed"

        elif [ "$NEWVIMVER" -lt "$VIMVER" ]; then
                echo "Local copy is newer than remote, might want to look"

        elif [ "$NEWVIMVER" -gt "$VIMVER" ]; then
                echo "A new version was found, updating then exiting!"
                if mv "$TMPBASE/$VIMRC.$PID" "$FILEBASE/$USER/.$VIMRC" ; then
                        echo "$VIMRC Copied!"
                        echo "Update Completed!"
                        if [ -e $TMPBASE/$VIMRC.$PID ]; then
                                rm $TMPBASE/$VIMRC.$PID
                        fi
                else
                        echo "!!**UPDATE FAILED**!!"
		fi
	fi

        if [ -e $TMPBASE/$VIMRC.$PID ]; then
              rm $TMPBASE/$VIMRC.$PID
        fi
}

UpdateSshkeys () {
	# First, let's grab the new copy of the Authorized_hosts file 
        if ! wget --quiet --output-document="$TMPBASE/$SSHKEYPUB.$PID" $UPDATE_URL/$SSHKEYPUB  ; then
                echo "Failed: Error while trying to wget new version!"
                echo "File requested: $UPDATE_URL/$SSHKEYPUB"
                exit 1
        fi

	# Get some version info
	SSHVER=$( head -n 5 $FILEBASE/$USER/.ssh/$SSHKEYPUB | grep VERSION | awk -F= '{print $2}')
	NEWSSHVER=$( head -n 5 $TMPBASE/$SSHKEYPUB.$PID | grep VERSION | awk -F= '{print $2}')

        if [ "$SSHVER" = "NOUPDATE" ]; then
                echo "You have marked this user/host to NOT update vimrc, EVER!"

        elif [ "$NEWSSHVER" -eq "$SSHVER" ]; then
                echo "You are on the current version of $SSHKEYPUB $RCVER, no update needed"

        elif [ "$NEWSSHVER" -lt "$SSHVER" ]; then
                echo "Local copy is newer than remote, might want to look"

        elif [ "$NEWSSHVER" -gt "$SSHVER" ]; then
                echo "A new version was found, updating then exiting!"
                if [ ! -d $FILEBASE/$USER/.ssh ] ; then
                   echo "Creating .ssh directory"
                   mkdir $FILEBASE/$USER/.ssh
                   chmod g-w $FILEBASE/$USER/.ssh
                fi 

                if mv "$TMPBASE/$SSHKEYPUB.$PID" "$FILEBASE/$USER/.ssh/$SSHKEYPUB" ; then
			chmod go-wx $FILEBASE/$USER/.ssh/$SSHKEYPUB
			chmod u+rw $FILEBASE/$USER/.ssh/$SSHKEYPUB
                        echo "$SSHKEYPUB Copied!"
                        echo "Update Completed!"
                        if [ -e $TMPBASE/$SSHKEYPUB.$PID ]; then
                                rm $TMPBASE/$SSHKEYPUB.$PID
                        fi
                else
                        echo "!!** SSHKEYPUB UPDATE FAILED**!!"
		fi
	fi

        if [ -e $TMPBASE/$SSHKEYPUB.$PID ]; then
              rm $TMPBASE/$SSHKEYPUB.$PID
        fi
}


NewInstall () {
	echo "WARNING! - This function blindly overwrites any existing files!"
	echo "Should only be used for the inital run in most cases"
	echo  -n "Are you sure you want to continue? (Y/n):"

	read -n 1 RESPONSE
	echo ""
	
	if [ "$RESPONSE" = "Y" ]; then
		echo "Installing new files from remote"
        	# First, let's grab the new copy of the various file
        	if ! wget --quiet --output-document="$TMPBASE/$BASHRC.$PID" $UPDATE_URL/$BASHRC  ; then
                	echo "Failed: Error while trying to wget new version!"
                	echo "File requested: $UPDATE_URL/$BASHRC"
                	exit 1
        	fi
		
        	if ! wget --quiet --output-document="$TMPBASE/$VIMRC.$PID" $UPDATE_URL/$VIMRC  ; then
                	echo "Failed: Error while trying to wget new version!"
                	echo "File requested: $UPDATE_URL/$VIMRC"
                	exit 1
        	fi
		
		# First, let's grab the new copy of the Authorized_hosts file 
        	if ! wget --quiet --output-document="$TMPBASE/$SSHKEYPUB.$PID" $UPDATE_URL/$SSHKEYPUB  ; then
                	echo "Failed: Error while trying to wget new version!"
                	echo "File requested: $UPDATE_URL/$SSHKEYPUB"
                	exit 1
        	fi

		# Now lets copy and clean up

                if mv "$TMPBASE/$BASHRC.$PID" "$FILEBASE/$USER/.$BASHRC" ; then
                        echo "$BASHRC Copied!"
                        echo "Update Completed!"
                        if [ -e $TMPBASE/$BASHRC.$PID ]; then
                                rm $TMPBASE/$BASHRC.$PID
                        fi
                else
                        echo "!!** $BASHRC UPDATE FAILED**!!"
                fi

                if mv "$TMPBASE/$VIMRC.$PID" "$FILEBASE/$USER/.$VIMRC" ; then
                        echo "$VIMRC Copied!"
                        echo "Update Completed!"
                        if [ -e $TMPBASE/$VIMRC.$PID ]; then
                                rm $TMPBASE/$VIMRC.$PID
                        fi
                else
                        echo "!!**$VIMRC UPDATE FAILED**!!"
		fi
                if [ ! -d $FILEBASE/$USER/.ssh ] ; then
                   echo "Creating .ssh directory"
                   mkdir $FILEBASE/$USER/.ssh
                   chmod g-w $FILEBASE/$USER/.ssh
                fi 

                if mv "$TMPBASE/$SSHKEYPUB.$PID" "$FILEBASE/$USER/.ssh/$SSHKEYPUB" ; then
			chmod go-wx $FILEBASE/$USER/.ssh/$SSHKEYPUB
			chmod u+rw $FILEBASE/$USER/.ssh/$SSHKEYPUB
                        echo "$SSHKEYPUB Copied!"
                        echo "Update Completed!"
                        if [ -e $TMPBASE/$SSHKEYPUB.$PID ]; then
                                rm $TMPBASE/$SSHKEYPUB.$PID
                        fi
                else
                        echo "!!** $SSHKEYPUB UPDATE FAILED**!!"
		fi


	elif [ "$RESPONSE" = "n" ] ; then
		echo "User cancelled"
		exit 0
	else
		echo "Response not understood, exiting!"
		exit 0
	fi
}
 

PrintHelp () {

  cat << EOF 

My Custom updater script. Updates varsious files from a webserver and autoupdates.
Currently looks at .bashrc .vimrc authorized_keys and updates itself.
 
Options:
  -h        Show help options.
  -v        Print version info.
  
  -u  --update		Updates this updater script

  -U  --user		Set the user to update files for. 

  -a  --all		Checks all files for updates
  -b  --bashrc		Updates users .bashrc 
  -s  --sshkeys		Updates users .authorized_keys file
  -e  --vimrc		Updates users .vimrc

  -I  --install		Installs a new set of files for a new account
			WARNING: this blindly overwrites any existing files

  -t  --tranny		Try it, you might laugh

EOF
}

UPDATE_URL=`eval $SOURCE_URL`
## Get Opts Stuff

GETOPTS=`getopt -o h,v,U:,u,a,b,s,e,t,I --long help,User:,update,all,bashrc,sshkeys,vimrc,tranny,install -n 'profile_updater.sh' -- "$@"`
eval set -- "$GETOPTS"

while true ; do
	case "$1" in
	-h|--help)
		PrintHelp;
		exit 0
		;;
	-v|--version)
		PrintHelp;
		exit 0
		;;
	-U|--user)
		shift;
		if [ -n "$1" ]; then
			echo "User: $1 selected";
			USER=$1
			shift;
		else
			
			USER=$CURRENTUSER
		fi
		if [ "$USER" = 'root' ]; then
        		FILEBASE=${ROOTFILEBASE};
		fi
	
		UPDATE_URL=`eval $SOURCE_URL`
		;;
	-u|--update)
		echo "Running self updater!"
		UpdateSelf;
		shift
		;;

	-a|--all)
		echo "Checking ALL files for updates"
		UpdateBashrc;
		UpdateVimrc;
		UpdateSshkeys;
		shift
		;;

	-b|--bashrc)
		echo "Running .bashrc updater!"
		UpdateBashrc;
		shift
		;;

	-e|--vimrc)
		echo "Running vimrc updater!"
		UpdateVimrc;
		shift
		;;

	-s|--sshkeys)
		echo "Running SSH Key Authorized_hosts Update"
		UpdateSshkeys;
		shift
		;;

	-t|--tranny)
		echo "Piss off ya grotty little wanker!"
		shift
		;;

	-I|--install)
		echo "Installing new files!"
		NewInstall;
		shift
		;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
	esac
done


if [ "$USER" = 'root' ]; then 
	FILEBASE=${ROOTFILEBASE};
fi	
