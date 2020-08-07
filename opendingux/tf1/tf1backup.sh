#!/bin/sh
# title=Save Export
# desc=Export save data to TF1 of destination device
# author=NekoMichi

echo "===Card Check==="

# Checks to see if there is a card inserted in slot 2
if [ ! -b /dev/mmcblk1 ]; then
	dialog --clear --backtitle "SaveSync $APPVERSION" --title "No SD Card Found" --msgbox "No SD card inserted in slot-2.\n\nPress START to exit." 8 29
	exit
fi

# Checks to see if the card in slot 2 has a system partition
if [ ! -b /dev/mmcblk1p2 ]; then
	dialog --clear --backtitle "SaveSync $APPVERSION" --title "Invalid SD Card" --msgbox "The card in slot-2 is not a valid OpenDingux formatted card.\n\nPress START to exit." 9 31
	exit
fi

PARTPATH=$(findmnt -n --output=target /dev/mmcblk1p2 | head -1)
EXTPATH="$PARTPATH/local/home"

# Checks to see if the card in slot 2 has a system partition
if [ ! -d $EXTPATH ]; then
	dialog --clear --backtitle "SaveSync $APPVERSION" --title "Invalid SD Card" --msgbox "The card in slot-2 is not a valid OpenDingux formatted card.\n\nPress START to exit." 9 31
	exit
fi

echo "Valid OpenDingux card detected in slot 2."

# Displays a confirmation dialog
dialog --clear --title "Confirm Export?" --backtitle "SaveSync $APPVERSION" --yesno "Are you sure you want to export saves? This will overwrite any existing saves on the destination device." 7 49

confirmexport=$?
clear

if [ $confirmexport = "1" ]; then
	dialog --clear --backtitle "SaveSync $APPVERSION" --title "Export Cancelled" --msgbox "Save export cancelled. No files were changed. Press START to exit." 7 29
	exit
fi

echo "===Exporting Saves==="

# Overrides permissions on backup folder
# chmod -R 777 $EXTPATH

PARTPATH=$(findmnt -n --output=target /dev/mmcblk1p2 | head -1)
EXTPATH="$PARTPATH/local/home"

# Exports FCEUX data
if [ -d $INTPATH/.fceux/ ]; then
	if [ ! -d $EXTPATH/.fceux/ ]; then
		echo "FCEUX folder doesn't exist, creating folder."
		mkdir $EXTPATH/.fceux
	fi
	echo "Exporting FCEUX data..."
	rsync -rtW $INTPATH/.fceux/sav/ $EXTPATH/.fceux/sav
	rsync -rtW $INTPATH/.fceux/fcs/ $EXTPATH/.fceux/fcs
fi

# Exports Gambatte data
if [ -d $INTPATH/.gambatte/ ]; then
	if [ ! -d $EXTPATH/.gambatte/ ]; then
		echo "Gambatte folder doesn't exist, creating folder."
		mkdir $EXTPATH/.gambatte
	fi
	echo "Exporting Gambatte data..."
	rsync -rtW $INTPATH/.gambatte/saves/ $EXTPATH/.gambatte/saves
fi

# Exports ReGBA data
if [ -d $INTPATH/.gpsp/ ]; then
	if [ ! -d $EXTPATH/.gpsp/ ]; then
		echo "ReGBA folder doesn't exist, creating folder."
		mkdir $EXTPATH/.gpsp
	fi
	echo "Exporting ReGBA data..."
	rsync -rtW $INTPATH/.gpsp/ $EXTPATH/.gpsp
fi

# Exports PCSX4all data
if [ -d $INTPATH/.pcsx4all/ ]; then
	if [ ! -d $EXTPATH/.pcsx4all/ ]; then
		echo "PCSX4all folder doesn't exist, creating folder."
		mkdir $EXTPATH/.pcsx4all
	fi
	echo "Exporting PCSX4all data..."
	rsync -rtW $INTPATH/.pcsx4all/memcards/ $EXTPATH/.pcsx4all/memcards
	rsync -rtW $INTPATH/.pcsx4all/sstates/ $EXTPATH/.pcsx4all/sstates
fi

# Exports Picodrive data
if [ -d $INTPATH/.picodrive/ ]; then
	if [ ! -d $EXTPATH/.picodrive/ ]; then
		echo "Picodrive folder doesn't exist, creating folder."
		mkdir $EXTPATH/.picodrive
	fi
	echo "Exporting PicoDrive data..."
	rsync -rtW $INTPATH/.picodrive/mds/ $EXTPATH/.picodrive/mds
	rsync -rtW $INTPATH/.picodrive/srm/ $EXTPATH/.picodrive/srm
fi

# Exports PocketSNES data
if [ -d $INTPATH/.snes96_snapshots/ ]; then
	if [ ! -d $EXTPATH/.snes96_snapshots/ ]; then
		echo "SNES96 folder doesn't exist, creating folder."
		mkdir $EXTPATH/.snes96_snapshots
	fi
	echo "Exporting SNES96 data..."
	rsync -rtW $INTPATH/.snes96_snapshots/ $EXTPATH/.snes96_snapshots
fi

if [ -d $INTPATH/.pocketsnes/ ]; then
	if [ ! -d $EXTPATH/.pocketsnes/ ]; then
		echo "PocketSNES folder doesn't exist, creating folder."
		mkdir $EXTPATH/.pocketsnes
	fi
	echo "Exporting PocketSNES data..."
	rsync -rtW $INTPATH/.pocketsnes/ $EXTPATH/.pocketsnes
fi

dialog --clear --backtitle "SaveSync $APPVERSION" --title "Export Complete" --msgbox "Save export complete.\nPress START to exit." 6 29
exit