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

# Debug message
# dialog --clear --backtitle "SaveSync $APPVERSION" --title "Debug Message" --msgbox "PARTPATH\n$PARTPATH\n\nEXTPATH\n$EXTPATH" 9 35

# Displays a confirmation dialog
dialog --clear --title "Confirm Export?" --backtitle "SaveSync $APPVERSION" --yesno "Are you sure you want to export saves? This will overwrite any existing saves on the destination device." 7 49

confirmexport=$?
clear

if [ $confirmexport = "1" ]; then
	dialog --clear --backtitle "SaveSync $APPVERSION" --title "Export Cancelled" --msgbox "Save export cancelled. No files were changed. Press START to exit." 7 29
	exit
fi

echo "===Exporting Saves==="

# Overrides permissions on destination folder
chmod -R 777 $EXTPATH

# Sets alias
alias exp="rsync --inplace -rtvhc"

# Exports FCEUX data
if [ -d $INTPATH/.fceux/ ]; then
	if [ ! -d $EXTPATH/.fceux/ ]; then
		echo "FCEUX folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.fceux/sav $EXTPATH/.fceux/fcs
	fi
	echo "Exporting FCEUX data..."
	exp $INTPATH/.fceux/sav/ $EXTPATH/.fceux/sav
	exp $INTPATH/.fceux/fcs/ $EXTPATH/.fceux/fcs
fi

# Exports Gambatte data
if [ -d $INTPATH/.gambatte/ ]; then
	if [ ! -d $EXTPATH/.gambatte/ ]; then
		echo "Gambatte folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.gambatte/saves
	fi
	echo "Exporting Gambatte data..."
	exp $INTPATH/.gambatte/saves/ $EXTPATH/.gambatte/saves
fi

# Exports OhBoy data
if [ -d $INTPATH/.ohboy/ ]; then
	if [ ! -d $EXTPATH/.ohboy/ ]; then
		echo "OhBoy folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.ohboy/saves
	fi
	echo "Exporting OhBoy data..."
	exp $INTPATH/.ohboy/saves/ $EXTPATH/.ohboy/saves
fi

# Exports ReGBA data
if [ -d $INTPATH/.gpsp/ ]; then
	if [ ! -d $EXTPATH/.gpsp/ ]; then
		echo "ReGBA folder doesn't exist, creating folder."
		mkdir $EXTPATH/.gpsp
	fi
	echo "Exporting ReGBA data..."
	exp --exclude '*.cfg' $INTPATH/.gpsp/ $EXTPATH/.gpsp
fi

# Exports PCSX4all data
if [ -d $INTPATH/.pcsx4all/ ]; then
	if [ ! -d $EXTPATH/.pcsx4all/ ]; then
		echo "PCSX4all folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.pcsx4all/memcards $EXTPATH/.pcsx4all/sstates
	fi
	echo "Exporting PCSX4all data..."
	exp $INTPATH/.pcsx4all/memcards/ $EXTPATH/.pcsx4all/memcards
	exp $INTPATH/.pcsx4all/sstates/ $EXTPATH/.pcsx4all/sstates
fi

# Exports Picodrive data
if [ -d $INTPATH/.picodrive/ ]; then
	if [ ! -d $EXTPATH/.picodrive/ ]; then
		echo "Picodrive folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.picodrive/mds $EXTPATH/.picodrive/srm
	fi
	echo "Exporting PicoDrive data..."
	exp $INTPATH/.picodrive/mds/ $EXTPATH/.picodrive/mds
	exp $INTPATH/.picodrive/srm/ $EXTPATH/.picodrive/srm
fi

# Exports SMS Plus data
if [ -d $INTPATH/.smsplus/ ]; then
	if [ ! -d $EXTPATH/.smsplus/ ]; then
		echo "SMS Plus folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.smsplus/sram $EXTPATH/.smsplus/state
	fi
	echo "Exporting SMS Plus data..."
	exp $INTPATH/.smsplus/sram/ $EXTPATH/.smsplus/sram
	exp $INTPATH/.smsplus/state/ $EXTPATH/.smsplus/state
fi

if [ -d $INTPATH/.sms_sdl/ ]; then
	if [ ! -d $EXTPATH/.sms_sdl/ ]; then
		echo "SMS SDL folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.sms_sdl/sram $EXTPATH/.sms_sdl/state
	fi
	echo "Exporting SMS SDL data..."
	exp $INTPATH/.sms_sdl/sram/ $EXTPATH/.sms_sdl/sram
	exp $INTPATH/.sms_sdl/state/ $EXTPATH/.sms_sdl/state
fi

# Exports PocketSNES data
if [ -d $INTPATH/.snes96_snapshots/ ]; then
	if [ ! -d $EXTPATH/.snes96_snapshots/ ]; then
		echo "SNES96 folder doesn't exist, creating folder."
		mkdir $EXTPATH/.snes96_snapshots
	fi
	echo "Exporting SNES96 data..."
	exp --exclude '*.opt' $INTPATH/.snes96_snapshots/ $EXTPATH/.snes96_snapshots
fi

if [ -d $INTPATH/.pocketsnes/ ]; then
	if [ ! -d $EXTPATH/.pocketsnes/ ]; then
		echo "PocketSNES folder doesn't exist, creating folder."
		mkdir $EXTPATH/.pocketsnes
	fi
	echo "Exporting PocketSNES data..."
	exp --exclude '*.opt' $INTPATH/.pocketsnes/ $EXTPATH/.pocketsnes
fi

# Exports Snes9x data
if [ -d $INTPATH/.snes9x/ ]; then
	if [ ! -d $EXTPATH/.snes9x/ ]; then
		echo "Snes9x folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.snes9x/spc $EXTPATH/.snes9x/sram
	fi
	echo "Exporting Snes9x data..."
	exp $INTPATH/.snes9x/spc/ $EXTPATH/.snes9x/spc
	exp $INTPATH/.snes9x/sram/ $EXTPATH/.snes9x/sram
fi

# Exports SwanEmu data
if [ -d $INTPATH/.swanemu/ ]; then
	if [ ! -d $EXTPATH/.swanemu/ ]; then
		echo "SwanEmu folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.swanemu/eeprom $EXTPATH/.swanemu/sstates
	fi
	echo "Exporting SwanEmu data..."
	exp $INTPATH/.swanemu/eeprom/ $EXTPATH/.swanemu/eeprom
	exp $INTPATH/.swanemu/sstates/ $EXTPATH/.swanemu/sstates
fi

# Exports Temper data
if [ -d $INTPATH/.temper/ ]; then
	if [ ! -d $EXTPATH/.temper/ ]; then
		echo "Temper folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.temper/bram $EXTPATH/.temper/save_states
	fi
	echo "Exporting Temper data..."
	exp $INTPATH/.temper/bram/ $EXTPATH/.temper/bram
	exp $INTPATH/.temper/save_states/ $EXTPATH/.temper/save_states
fi

# Backs up Devilution/Diablo data
if [ -d $INTPATH/.local/share/diasurgical/devilution/ ]; then
	if [ ! -d $EXTPATH/.local/share/diasurgical/devilution/ ]; then
		echo "Devilution backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.local/share/diasurgical/devilution/
	fi
	echo "Backing up Devilution data..."
	exp $INTPATH/.local/share/diasurgical/devilution/*.sv $EXTPATH/.local/share/diasurgical/devilution/
	exp $INTPATH/.local/share/diasurgical/devilution/*.ini $EXTPATH/.local/share/diasurgical/devilution/
fi

# Backs up Scummvm data
if [ -d $INTPATH/.local/share/scummvm/saves/ ]; then
	if [! -d $EXTPATH/.local/share/scummvm/saves/ ]; then
		echo "Scummvm backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.local/share/scummvm/saves/
	fi
	echo "Backing up Scummvm data..."
	exp $INTPATH/.local/share/scummvm/saves/ $EXTPATH/.local/share/scummvm/saves/
	exp $INTPATH/.scummvmrc $EXTPATH/
fi

# Backs up Ur-Quan Masters (Starcon2 port) data
if [ -d $INTPATH/.uqm/ ]; then
	if [ ! -d $EXTPATH/.uqm/ ]; then
		echo "Ur-Quan Masters backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.uqm/
	fi
	echo "Backing up Ur-Quan Masters data..."
	exp $INTPATH/.uqm/* $EXTPATH/.uqm/
fi

# Backs up Atari800 data
if [ -d $INTPATH/.atari/ ]; then
	if [ ! -d $EXTPATH/.atari/ ]; then
		echo "Atari800 backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.atari/
	fi
	echo "Backing up Atari800 data..."
	exp $INTPATH/.atari/* $EXTPATH/.atari/
	exp $INTPATH/.atari800.cfg $EXTPATH/
fi

# Backs up OpenDune data
if [ -d $INTPATH/.opendune/save/ ]; then
	if [ ! -d $EXTPATH/.opendune/save/ ]; then
		echo "OpenDune backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.opendune/save/
	fi
	echo "Backing up OpenDune data..."
	exp $INTPATH/.opendune/save/* $EXTPATH/.opendune/save/
fi

# Backs up OpenLara data
if [ -d $INTPATH/.openlara/ ]; then
	if [ ! -d $EXTPATH/.openlara/ ]; then
		echo "OpenLara backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.openlara/
	fi
	echo "Backing up OpenLara data..."
	exp $INTPATH/.openlara/savegame.dat $EXTPATH/.openlara/savegame.dat
fi

# Backs up GCW Connect data
if [ -d $INTPATH/.local/share/gcwconnect/networks/ ]; then
	if [ ! -d $EXTPATH/.local/share/gcwconnect/networks/ ]; then
		echo "GCW Connect backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.local/share/gcwconnect/networks/
	fi
	echo "Backing up GCW Connect data..."
	exp $INTPATH/.local/share/gcwconnect/networks/* $EXTPATH/.local/share/gcwconnect/networks/
fi

# Backs up Super Mario 64 Port data
if [ -d $INTPATH/.sm64-port/ ]; then
	if [ ! -d $EXTPATH/.sm64-port/ ]; then
		echo "Super Mario 64 backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.sm64-port/
	fi
	echo "Backing up Super Mario 64 data..."
	exp $INTPATH/.sm64-port/sm64_save_file.bin $EXTPATH/.sm64-port/
fi

# Synchronize cached writes to persistent storage
# This forces the filesystem to write to disk to avoid any data loss if you quickly turn off the device before the data is written to the sdcard.
sync

dialog --clear --backtitle "SaveSync $APPVERSION" --title "Export Complete" --msgbox "Save export complete.\nPress START to exit." 6 29
exit
