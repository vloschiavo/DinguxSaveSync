#!/bin/sh
# title=SaveSync Main
# desc=Main menu of SaveSync
# author=NekoMichi

# Checks to see if backup folder exists on card 2, if not then will create it
if [ ! -d $EXTPATH/ ]; then
	mkdir $EXTPATH
	mkdir $EXTPATH/log
fi

# Checks to see if log folder exists on card 2, if not then will create it
if [ ! -d $EXTPATH/log/ ]; then
	mkdir $EXTPATH/log
fi

MODE=$(dialog --clear --backtitle "SaveSync $APPVERSION" --title "SaveSync - Advanced" --menu "Please select an action. Use arrow keys to make your selection and press START to confirm." 17 35 6 \
1 "Debug backup" \
2 "Debug restore" \
3 "Debug sync" \
4 "Export" \
5 "Import" \
6 "Direct sync" \
2>&1 >/dev/tty)

clear

if [ $MODE = "1" ]; then
	export TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)_testbackup
	./debug/drybackup.sh | tee $EXTPATH/log/$TIMESTAMP.txt
fi
if [ $MODE = "2" ]; then
	export TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)_testrestore
	./debug/dryrestore.sh | tee $EXTPATH/log/$TIMESTAMP.txt
fi
if [ $MODE = "3" ]; then
	export TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)_testsync
	./debug/drysync.sh | tee $EXTPATH/log/$TIMESTAMP.txt
fi
if [ $MODE = "4" ]; then
	./tf1/tf1backup.sh
fi
if [ $MODE = "5" ]; then
	./tf1/tf1restore.sh
fi
if [ $MODE = "6" ]; then
	./tf1/tf1sync.sh
fi

exit
