#!/bin/sh
# title=TF1 Save Sync
# desc=Syncs save data with a TF1 card
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
dialog --clear --title "Confirm Sync?" --backtitle "SaveSync $APPVERSION" --yesno "Are you sure you want to sync saves? This will overwrite any duplicate saves with the newer version." 7 49

confirmsync=$?
clear

if [ $confirmsync = "1" ]; then
	dialog --clear --backtitle "SaveSync $APPVERSION" --title "Sync Cancelled" --msgbox "Save sync cancelled. No files were changed. Press START to exit." 7 29
	exit
fi

echo "===Syncing Saves==="

# Overrides permissions on folders
chmod -R 777 $EXTPATH
chmod -R 777 $INTPATH

# Syncs FCEUX data
if [ -d $INTPATH/.fceux/ ]; then
	if [ -d $EXTPATH/.fceux/ ]; then
		echo "Syncing FCEUX data..."
		rsync --update -rtvhW $INTPATH/.fceux/sav/ $EXTPATH/.fceux/sav
		rsync --update -rtvhW $INTPATH/.fceux/fcs/ $EXTPATH/.fceux/fcs
		rsync --update -rtvhW $EXTPATH/.fceux/sav/ $INTPATH/.fceux/sav
		rsync --update -rtvhW $EXTPATH/.fceux/fcs/ $INTPATH/.fceux/fcs
	else
		echo "FCEUX folder doesn't exist on destination device, creating folder."
		mkdir -p $EXTPATH/.fceux/sav $EXTPATH/.fceux/fcs
		echo "Syncing FCEUX data..."
		rsync --update -rtvhW $INTPATH/.fceux/sav/ $EXTPATH/.fceux/sav
		rsync --update -rtvhW $INTPATH/.fceux/fcs/ $EXTPATH/.fceux/fcs
	fi
else
	if [ -d $EXTPATH/.fceux/ ]; then
		echo "FCEUX folder doesn't exist in home directory, creating folder."
		mkdir -p $INTPATH/.fceux/sav $INTPATH/.fceux/fcs
		echo "Syncing FCEUX data..."
		rsync --update -rtvhW $EXTPATH/.fceux/sav/ $INTPATH/.fceux/sav
		rsync --update -rtvhW $EXTPATH/.fceux/fcs/ $INTPATH/.fceux/fcs
	fi
fi

# Syncs Gambatte data
if [ -d $INTPATH/.gambatte/ ]; then
	if [ -d $EXTPATH/.gambatte/ ]; then
		echo "Syncing Gambatte data..."
		rsync --update -rtvhW $INTPATH/.gambatte/saves/ $EXTPATH/.gambatte/saves
		rsync --update -rtvhW $EXTPATH/.gambatte/saves/ $INTPATH/.gambatte/saves
	else
		echo "Gambatte folder doesn't exist on destination device, creating folder."
		mkdir -p $EXTPATH/.gambatte/saves
		echo "Syncing Gambatte data..."
		rsync --update -rtvhW $INTPATH/.gambatte/saves/ $EXTPATH/.gambatte/saves
	fi
else
	if [ -d $EXTPATH/.gambatte/ ]; then
		echo "Gambatte folder doesn't exist in home directory, creating folder."
		mkdir -p $INTPATH/.gambatte/saves
		echo "Syncing Gambatte data..."
		rsync --update -rtvhW $EXTPATH/.gambatte/saves/ $INTPATH/.gambatte/saves
	fi
fi

# Syncs OhBoy data
if [ -d $INTPATH/.ohboy/ ]; then
	if [ -d $EXTPATH/.ohboy/ ]; then
		echo "Syncing OhBoy data..."
		rsync --update -rtvhW $INTPATH/.ohboy/saves/ $EXTPATH/.ohboy/saves
		rsync --update -rtvhW $EXTPATH/.ohboy/saves/ $INTPATH/.ohboy/saves
	else
		echo "OhBoy folder doesn't exist on destination device, creating folder."
		mkdir -p $EXTPATH/.ohboy/saves
		echo "Syncing OhBoy data..."
		rsync --update -rtvhW $INTPATH/.ohboy/saves/ $EXTPATH/.ohboy/saves
	fi
else
	if [ -d $EXTPATH/.ohboy/ ]; then
		echo "OhBoy folder doesn't exist in home directory, creating folder."
		mkdir -p $INTPATH/.ohboy/saves
		echo "Syncing OhBoy data..."
		rsync --update -rtvhW $EXTPATH/.ohboy/saves/ $INTPATH/.ohboy/saves
	fi
fi

# Syncs ReGBA data
if [ -d $INTPATH/.gpsp/ ]; then
	if [ -d $EXTPATH/.gpsp/ ]; then
		echo "Syncing ReGBA data..."
		rsync --update -rtvhW --exclude '*.cfg' $INTPATH/.gpsp/ $EXTPATH/.gpsp
		rsync --update -rtvhW --exclude '*.cfg' $EXTPATH/.gpsp/ $INTPATH/.gpsp
	else
		echo "ReGBA folder doesn't exist on destination device, creating folder."
		mkdir $EXTPATH/.gpsp
		echo "Syncing ReGBA data..."
		rsync --update -rtvhW --exclude '*.cfg' $INTPATH/.gpsp/ $EXTPATH/.gpsp
	fi
else
	if [ -d $EXTPATH/.gpsp/ ]; then
		echo "ReGBA folder doesn't exist in home directory, creating folder."
		mkdir $INTPATH/.gpsp
		echo "Syncing ReGBA data..."
		rsync --update -rtvhW --exclude '*.cfg' $EXTPATH/.gpsp/ $INTPATH/.gpsp
	fi
fi

# Syncs PCSX4all data
if [ -d $INTPATH/.pcsx4all/ ]; then
	if [ -d $EXTPATH/.pcsx4all/ ]; then
		echo "Syncing PCSX4all data..."
		rsync --update -rtvhW $INTPATH/.pcsx4all/memcards/ $EXTPATH/.pcsx4all/memcards
		rsync --update -rtvhW $INTPATH/.pcsx4all/sstates/ $EXTPATH/.pcsx4all/sstates
		rsync --update -rtvhW $EXTPATH/.pcsx4all/memcards/ $INTPATH/.pcsx4all/memcards
		rsync --update -rtvhW $EXTPATH/.pcsx4all/sstates/ $INTPATH/.pcsx4all/sstates
	else
		echo "PCSX4all folder doesn't exist on destination device, creating folder."
		mkdir -p $EXTPATH/.pcsx4all/memcards $EXTPATH/.pcsx4all/sstates
		echo "Syncing PCSX4all data..."
		rsync --update -rtvhW $INTPATH/.pcsx4all/memcards/ $EXTPATH/.pcsx4all/memcards
		rsync --update -rtvhW $INTPATH/.pcsx4all/sstates/ $EXTPATH/.pcsx4all/sstates
	fi
else
	if [ -d $EXTPATH/.pcsx4all/ ]; then
		echo "PCSX4all folder doesn't exist in home directory, creating folder."
		mkdir -p $INTPATH/.pcsx4all/memcards $INTPATH/.pcsx4all/sstates
		echo "Syncing PCSX4all data..."
		rsync --update -rtvhW $EXTPATH/.pcsx4all/memcards/ $INTPATH/.pcsx4all/memcards
		rsync --update -rtvhW $EXTPATH/.pcsx4all/sstates/ $INTPATH/.pcsx4all/sstates
	fi
fi

# Syncs Picodrive data
if [ -d $INTPATH/.picodrive/ ]; then
	if [ -d $EXTPATH/.picodrive/ ]; then
		echo "Syncing PicoDrive data..."
		rsync --update -rtvhW $INTPATH/.picodrive/mds/ $EXTPATH/.picodrive/mds
		rsync --update -rtvhW $INTPATH/.picodrive/srm/ $EXTPATH/.picodrive/srm
		rsync --update -rtvhW $EXTPATH/.picodrive/mds/ $INTPATH/.picodrive/mds
		rsync --update -rtvhW $EXTPATH/.picodrive/srm/ $INTPATH/.picodrive/srm
	else
		echo "PicoDrive folder doesn't exist on destination device, creating folder."
		mkdir -p $EXTPATH/.picodrive/mds $EXTPATH/.picodrive/srm
		echo "Syncing PicoDrive data..."
		rsync --update -rtvhW $INTPATH/.picodrive/mds/ $EXTPATH/.picodrive/mds
		rsync --update -rtvhW $INTPATH/.picodrive/srm/ $EXTPATH/.picodrive/srm
	fi
else
	if [ -d $EXTPATH/.picodrive/ ]; then
		echo "PicoDrive folder doesn't exist in home directory, creating folder."
		mkdir -p $INTPATH/.picodrive/mds $INTPATH/.picodrive/srm
		echo "Syncing PicoDrive data..."
		rsync --update -rtvhW $EXTPATH/.picodrive/mds/ $INTPATH/.picodrive/mds
		rsync --update -rtvhW $EXTPATH/.picodrive/srm/ $INTPATH/.picodrive/srm
	fi
fi

# Syncs SMS Plus data
if [ -d $INTPATH/.smsplus/ ]; then
	if [ -d $EXTPATH/.smsplus/ ]; then
		echo "Syncing SMS Plus data..."
		rsync --update -rtvhW $INTPATH/.smsplus/sram/ $EXTPATH/.smsplus/sram
		rsync --update -rtvhW $INTPATH/.smsplus/state/ $EXTPATH/.smsplus/state
		rsync --update -rtvhW $EXTPATH/.smsplus/sram/ $INTPATH/.smsplus/sram
		rsync --update -rtvhW $EXTPATH/.smsplus/state/ $INTPATH/.smsplus/state
	else
		echo "SMS Plus folder doesn't exist on destination device, creating folder."
		mkdir -p $EXTPATH/.smsplus/sram $EXTPATH/.smsplus/state
		echo "Syncing SMS Plus data..."
		rsync --update -rtvhW $INTPATH/.smsplus/sram/ $EXTPATH/.smsplus/sram
		rsync --update -rtvhW $INTPATH/.smsplus/state/ $EXTPATH/.smsplus/state
	fi
else
	if [ -d $EXTPATH/.smsplus/ ]; then
		echo "SMS Plus folder doesn't exist in home directory, creating folder."
		mkdir -p $INTPATH/.smsplus/sram $INTPATH/.smsplus/state
		echo "Syncing SMS Plus data..."
		rsync --update -rtvhW $EXTPATH/.smsplus/sram/ $INTPATH/.smsplus/sram
		rsync --update -rtvhW $EXTPATH/.smsplus/state/ $INTPATH/.smsplus/state
	fi
fi

if [ -d $INTPATH/.sms_sdl/ ]; then
	if [ -d $EXTPATH/.sms_sdl/ ]; then
		echo "Syncing SMS SDL data..."
		rsync --update -rtvhW $INTPATH/.sms_sdl/sram/ $EXTPATH/.sms_sdl/sram
		rsync --update -rtvhW $INTPATH/.sms_sdl/state/ $EXTPATH/.sms_sdl/state
		rsync --update -rtvhW $EXTPATH/.sms_sdl/sram/ $INTPATH/.sms_sdl/sram
		rsync --update -rtvhW $EXTPATH/.sms_sdl/state/ $INTPATH/.sms_sdl/state
	else
		echo "SMS SDL folder doesn't exist on destination device, creating folder."
		mkdir -p $EXTPATH/.sms_sdl/sram $EXTPATH/.sms_sdl/state
		echo "Syncing SMS SDL data..."
		rsync --update -rtvhW $INTPATH/.sms_sdl/sram/ $EXTPATH/.sms_sdl/sram
		rsync --update -rtvhW $INTPATH/.sms_sdl/state/ $EXTPATH/.sms_sdl/state
	fi
else
	if [ -d $EXTPATH/.sms_sdl/ ]; then
		echo "SMS SDL folder doesn't exist in home directory, creating folder."
		mkdir -p $INTPATH/.sms_sdl/sram $INTPATH/.sms_sdl/state
		echo "Syncing SMS SDL data..."
		rsync --update -rtvhW $EXTPATH/.sms_sdl/sram/ $INTPATH/.sms_sdl/sram
		rsync --update -rtvhW $EXTPATH/.sms_sdl/state/ $INTPATH/.sms_sdl/state
	fi
fi

# Syncs SNES96 data
if [ -d $INTPATH/.snes96_snapshots/ ]; then
	if [ -d $EXTPATH/.snes96_snapshots/ ]; then
		echo "Syncing SNES96 data..."
		rsync --update -rtvhW --exclude '*.opt' $INTPATH/.snes96_snapshots/ $EXTPATH/.snes96_snapshots
		rsync --update -rtvhW --exclude '*.opt' $EXTPATH/.snes96_snapshots/ $INTPATH/.snes96_snapshots
	else
		echo "SNES96 folder doesn't exist on destination device, creating folder."
		mkdir $EXTPATH/.snes96_snapshots
		echo "Syncing SNES96 data..."
		rsync --update -rtvhW --exclude '*.opt' $INTPATH/.snes96_snapshots/ $EXTPATH/.snes96_snapshots
	fi
else
	if [ -d $EXTPATH/.snes96_snapshots/ ]; then
		echo "SNES96 folder doesn't exist in home directory, creating folder."
		mkdir $INTPATH/.snes96_snapshots
		echo "Syncing SNES96 data..."
		rsync --update -rtvhW --exclude '*.opt' $EXTPATH/.snes96_snapshots/ $INTPATH/.snes96_snapshots
	fi
fi

# Syncs PocketSNES data
if [ -d $INTPATH/.pocketsnes/ ]; then
	if [ -d $EXTPATH/.pocketsnes/ ]; then
		echo "Syncing PocketSNES data..."
		rsync --update -rtvhW --exclude '*.opt' $INTPATH/.pocketsnes/ $EXTPATH/.pocketsnes
		rsync --update -rtvhW --exclude '*.opt' $EXTPATH/.pocketsnes/ $INTPATH/.pocketsnes
	else
		echo "PocketSNES folder doesn't exist on destination device, creating folder."
		mkdir $EXTPATH/.pocketsnes
		echo "Syncing PocketSNES data..."
		rsync --update -rtvhW --exclude '*.opt' $INTPATH/.pocketsnes/ $EXTPATH/.pocketsnes
	fi
else
	if [ -d $EXTPATH/.pocketsnes/ ]; then
		echo "PocketSNES folder doesn't exist in home directory, creating folder."
		mkdir $INTPATH/.pocketsnes
		echo "Syncing PocketSNES data..."
		rsync --update -rtvhW --exclude '*.opt' $EXTPATH/.pocketsnes/ $INTPATH/.pocketsnes
	fi
fi

# Syncs Snes9x data
if [ -d $INTPATH/.snes9x/ ]; then
	if [ -d $EXTPATH/.snes9x/ ]; then
		echo "Syncing Snes9x data..."
		rsync --update -rtvhW $INTPATH/.snes9x/spc/ $EXTPATH/.snes9x/spc
		rsync --update -rtvhW $INTPATH/.snes9x/sram/ $EXTPATH/.snes9x/sram
		rsync --update -rtvhW $EXTPATH/.snes9x/spc/ $INTPATH/.snes9x/spc
		rsync --update -rtvhW $EXTPATH/.snes9x/sram/ $INTPATH/.snes9x/sram
	else
		echo "Snes9x folder doesn't exist on destination device, creating folder."
		mkdir -p $EXTPATH/.snes9x/spc $EXTPATH/.snes9x/sram
		echo "Syncing Snes9x data..."
		rsync --update -rtvhW $INTPATH/.snes9x/spc/ $EXTPATH/.snes9x/spc
		rsync --update -rtvhW $INTPATH/.snes9x/sram/ $EXTPATH/.snes9x/sram
	fi
else
	if [ -d $EXTPATH/.snes9x/ ]; then
		echo "Snes9x folder doesn't exist in home directory, creating folder."
		mkdir -p $INTPATH/.snes9x/spc $INTPATH/.snes9x/sram
		echo "Syncing Snes9x data..."
		rsync --update -rtvhW $EXTPATH/.snes9x/spc/ $INTPATH/.snes9x/spc
		rsync --update -rtvhW $EXTPATH/.snes9x/sram/ $INTPATH/.snes9x/sram
	fi
fi

# Syncs SwanEmu data
if [ -d $INTPATH/.swanemu/ ]; then
	if [ -d $EXTPATH/.swanemu/ ]; then
		echo "Syncing SwanEmu data..."
		rsync --update -rtvhW $INTPATH/.swanemu/eeprom/ $EXTPATH/.swanemu/eeprom
		rsync --update -rtvhW $INTPATH/.swanemu/sstates/ $EXTPATH/.swanemu/sstates
		rsync --update -rtvhW $EXTPATH/.swanemu/eeprom/ $INTPATH/.swanemu/eeprom
		rsync --update -rtvhW $EXTPATH/.swanemu/sstates/ $INTPATH/.swanemu/sstates
	else
		echo "SwanEmu folder doesn't exist on destination device, creating folder."
		mkdir -p $EXTPATH/.swanemu/eeprom $EXTPATH/.swanemu/sstates
		echo "Syncing SwanEmu data..."
		rsync --update -rtvhW $INTPATH/.swanemu/eeprom/ $EXTPATH/.swanemu/eeprom
		rsync --update -rtvhW $INTPATH/.swanemu/sstates/ $EXTPATH/.swanemu/sstates
	fi
else
	if [ -d $EXTPATH/.swanemu/ ]; then
		echo "SwanEmu folder doesn't exist in home directory, creating folder."
		mkdir -p $INTPATH/.swanemu/eeprom $INTPATH/.swanemu/sstates
		echo "Syncing SwanEmu data..."
		rsync --update -rtvhW $EXTPATH/.swanemu/eeprom/ $INTPATH/.swanemu/eeprom
		rsync --update -rtvhW $EXTPATH/.swanemu/sstates/ $INTPATH/.swanemu/sstates
	fi
fi

# Syncs Temper data
if [ -d $INTPATH/.temper/ ]; then
	if [ -d $EXTPATH/.temper/ ]; then
		echo "Syncing Temper data..."
		rsync --update -rtvhW $INTPATH/.temper/bram/ $EXTPATH/.temper/eeprbramom
		rsync --update -rtvhW $INTPATH/.temper/save_states/ $EXTPATH/.temper/save_states
		rsync --update -rtvhW $EXTPATH/.temper/bram/ $INTPATH/.temper/bram
		rsync --update -rtvhW $EXTPATH/.temper/save_states/ $INTPATH/.temper/save_states
	else
		echo "Temper folder doesn't exist on destination device, creating folder."
		mkdir -p $EXTPATH/.temper/bram $EXTPATH/.temper/save_states
		echo "Syncing SwanEmu data..."
		rsync --update -rtvhW $INTPATH/.temper/bram/ $EXTPATH/.temper/bram
		rsync --update -rtvhW $INTPATH/.temper/save_states/ $EXTPATH/.temper/save_states
	fi
else
	if [ -d $EXTPATH/.temper/ ]; then
		echo "Temper folder doesn't exist in home directory, creating folder."
		mkdir -p $INTPATH/.temper/bram $INTPATH/.temper/save_states
		echo "Syncing Temper data..."
		rsync --update -rtvhW $EXTPATH/.temper/bram/ $INTPATH/.temper/bram
		rsync --update -rtvhW $EXTPATH/.temper/save_states/ $INTPATH/.temper/save_states
	fi
fi

dialog --clear --backtitle "SaveSync $APPVERSION" --title "Sync Complete" --msgbox "Save sync complete.\nPress START to exit." 6 29
exit
