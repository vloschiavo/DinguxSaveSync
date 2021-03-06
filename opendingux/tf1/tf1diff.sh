#!/bin/sh
# title=TF1 Comparison
# desc=Checks for save file differences between SD cards
# author=NekoMichi

echo "===Card Check==="

# Checks to see if there is a card inserted in slot 2
if [ ! -b /dev/mmcblk1 ]; then
	echo "No SD card inserted in slot-2."
	read -p "Press START to exit."
	exit
fi

# Checks to see if the card in slot 2 has a system partition
if [ ! -b /dev/mmcblk1p2 ]; then
	echo "The card in slot-2 is not a valid OpenDingux formatted card."
	read -p "Press START to exit."
	exit
fi

PARTPATH=$(findmnt -n --output=target /dev/mmcblk1p2 | head -1)
EXTPATH="$PARTPATH/local/home"

# Checks to see if the card in slot 2 has a system partition
if [ ! -d $EXTPATH ]; then
	echo "The card in slot-2 is not a valid OpenDingux formatted card."
	read -p "Press START to exit."
	exit
fi

echo "Valid OpenDingux-formatted card found."
echo $PARTPATH
echo $EXTPATH
echo ""

echo "===Comparing Saves==="

# Overrides permissions on destination folder
chmod -R 777 $EXTPATH

# Diffs FCEUX data
if [ -d $INTPATH/.fceux/ ]; then
	if [ ! -d $EXTPATH/.fceux/ ]; then
		echo "FCEUX folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.fceux/sav $EXTPATH/.fceux/fcs
	fi
	echo "Comparing FCEUX data..."
	diff -rq $INTPATH/.fceux/sav $EXTPATH/.fceux/sav
	diff -rq $INTPATH/.fceux/fcs $EXTPATH/.fceux/fcs
	sleep 1
fi

# Diffs Gambatte data
if [ -d $INTPATH/.gambatte/ ]; then
	if [ ! -d $EXTPATH/.gambatte/ ]; then
		echo "Gambatte folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.gambatte/saves
	fi
	echo "Comparing Gambatte data..."
	diff -rq $INTPATH/.gambatte/saves $EXTPATH/.gambatte/saves
	sleep 1
fi

# Diffs OhBoy data
if [ -d $INTPATH/.ohboy/ ]; then
	if [ ! -d $EXTPATH/.ohboy/ ]; then
		echo "OhBoy folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.ohboy/saves
	fi
	echo "Comparing OhBoy data..."
	diff -rq $INTPATH/.ohboy/saves $EXTPATH/.ohboy/saves
	sleep 1
fi

# Diffs ReGBA data
if [ -d $INTPATH/.gpsp/ ]; then
	if [ ! -d $EXTPATH/.gpsp/ ]; then
		echo "ReGBA folder doesn't exist, creating folder."
		mkdir $EXTPATH/.gpsp
	fi
	echo "Comparing ReGBA data..."
	diff -rq $INTPATH/.gpsp $EXTPATH/.gpsp
	sleep 1
fi

# Diffs PCSX4all data
if [ -d $INTPATH/.pcsx4all/ ]; then
	if [ ! -d $EXTPATH/.pcsx4all/ ]; then
		echo "PCSX4all folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.pcsx4all/memcards $EXTPATH/.pcsx4all/sstates
	fi
	echo "Comparing PCSX4all data..."
	diff -rq $INTPATH/.pcsx4all/memcards $EXTPATH/.pcsx4all/memcards
	diff -rq $INTPATH/.pcsx4all/sstates $EXTPATH/.pcsx4all/sstates
	sleep 1
fi

# Diffs Picodrive data
if [ -d $INTPATH/.picodrive/ ]; then
	if [ ! -d $EXTPATH/.picodrive/ ]; then
		echo "Picodrive folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.picodrive/mds $EXTPATH/.picodrive/srm
	fi
	echo "Comparing PicoDrive data..."
	diff -rq $INTPATH/.picodrive/mds $EXTPATH/.picodrive/mds
	diff -rq $INTPATH/.picodrive/srm $EXTPATH/.picodrive/srm
	sleep 1
fi

# Diffs SMS Plus data
if [ -d $INTPATH/.smsplus/ ]; then
	if [ ! -d $EXTPATH/.smsplus/ ]; then
		echo "SMS Plus folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.smsplus/sram $EXTPATH/.smsplus/state
	fi
	echo "Comparing SMS Plus data..."
	diff -rq $INTPATH/.smsplus/sram $EXTPATH/.smsplus/sram
	diff -rq $INTPATH/.smsplus/state $EXTPATH/.smsplus/state
	sleep 1
fi

if [ -d $INTPATH/.sms_sdl/ ]; then
	if [ ! -d $EXTPATH/.sms_sdl/ ]; then
		echo "SMS SDL folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.sms_sdl/sram $EXTPATH/.sms_sdl/state
	fi
	echo "Comparing SMS SDL data..."
	diff -rq $INTPATH/.sms_sdl/sram $EXTPATH/.sms_sdl/sram
	diff -rq $INTPATH/.sms_sdl/state $EXTPATH/.sms_sdl/state
	sleep 1
fi

# Diffs PocketSNES data
if [ -d $INTPATH/.snes96_snapshots/ ]; then
	if [ ! -d $EXTPATH/.snes96_snapshots/ ]; then
		echo "SNES96 folder doesn't exist, creating folder."
		mkdir $EXTPATH/.snes96_snapshots
	fi
	echo "Comparing SNES96 data..."
	diff -rq $INTPATH/.snes96_snapshots $EXTPATH/.snes96_snapshots
	sleep 1
fi

if [ -d $INTPATH/.pocketsnes/ ]; then
	if [ ! -d $EXTPATH/.pocketsnes/ ]; then
		echo "PocketSNES folder doesn't exist, creating folder."
		mkdir $EXTPATH/.pocketsnes
	fi
	echo "Comparing PocketSNES data..."
	diff -rq $INTPATH/.pocketsnes $EXTPATH/.pocketsnes
	sleep 1
fi

# Diffs Snes9x data
if [ -d $INTPATH/.snes9x/ ]; then
	if [ ! -d $EXTPATH/.snes9x/ ]; then
		echo "Snes9x folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.snes9x/spc $EXTPATH/.snes9x/sram
	fi
	echo "Comparing Snes9x data..."
	diff -rq $INTPATH/.snes9x/spc $EXTPATH/.snes9x/spc
	diff -rq $INTPATH/.snes9x/sram $EXTPATH/.snes9x/sram
	sleep 1
fi

# Diffs SwanEmu data
if [ -d $INTPATH/.swanemu/ ]; then
	if [ ! -d $EXTPATH/.swanemu/ ]; then
		echo "SwanEmu folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.swanemu/eeprom $EXTPATH/.swanemu/sstates
	fi
	echo "Comparing SwanEmu data..."
	diff -rq $INTPATH/.swanemu/eeprom $EXTPATH/.swanemu/eeprom
	diff -rq $INTPATH/.swanemu/sstates $EXTPATH/.swanemu/sstates
	sleep 1
fi

# Diffs Temper data
if [ -d $INTPATH/.temper/ ]; then
	if [ ! -d $EXTPATH/.temper/ ]; then
		echo "Temper folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.temper/bram $EXTPATH/.temper/save_states
	fi
	echo "Comparing Temper data..."
	diff -rq $INTPATH/.temper/bram $EXTPATH/.temper/bram
	diff -rq $INTPATH/.temper/save_states $EXTPATH/.temper/save_states
	sleep 1
fi

# Diffs Devilution/Diablo data
if [ -d $INTPATH/.local/share/diasurgical/devilution/ ]; then
	if [ ! -d $EXTPATH/.local/share/diasurgical/devilution/ ]; then
		echo "Devilution backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.local/share/diasurgical/devilution/
	fi
	echo "Comparing Devilution data..."
	diff -rq $INTPATH/.local/share/diasurgical/devilution/*.sv $EXTPATH/.local/share/diasurgical/devilution/
	diff -rq $INTPATH/.local/share/diasurgical/devilution/*.ini $EXTPATH/.local/share/diasurgical/devilution/
	sleep 1
fi

# Diffs Scummvm data
if [ -d $INTPATH/.local/share/scummvm/saves/ ]; then
	if [! -d $EXTPATH/.local/share/scummvm/saves/ ]; then
		echo "Scummvm backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.local/share/scummvm/saves/
	fi
	echo "Comparing Scummvm data..."
	diff -rq $INTPATH/.local/share/scummvm/saves/ $EXTPATH/.local/share/scummvm/saves/
	diff -rq $INTPATH/.scummvmrc $EXTPATH/
	sleep 1
fi

# Diffs Ur-Quan Masters (Starcon2 port) data
if [ -d $INTPATH/.uqm/ ]; then
	if [ ! -d $EXTPATH/.uqm/ ]; then
		echo "Ur-Quan Masters backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.uqm/
	fi
	echo "Comparing Ur-Quan Masters data..."
	diff -rq $INTPATH/.uqm/* $EXTPATH/.uqm/
	sleep 1
fi

# Diffs Atari800 data
if [ -d $INTPATH/.atari/ ]; then
	if [ ! -d $EXTPATH/.atari/ ]; then
		echo "Atari800 backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.atari/
	fi
	echo "Comparing Atari800 data..."
	diff -rq $INTPATH/.atari/* $EXTPATH/.atari/
	diff -rq $INTPATH/.atari800.cfg $EXTPATH/
	sleep 1
fi

# Diffs OpenDune data
if [ -d $INTPATH/.opendune/save/ ]; then
	if [ ! -d $EXTPATH/.opendune/save/ ]; then
		echo "OpenDune backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.opendune/save/
	fi
	echo "Comparing OpenDune data..."
	diff -rq $INTPATH/.opendune/save/* $EXTPATH/.opendune/save/
	sleep 1
fi

# Diffs OpenLara data
if [ -d $INTPATH/.openlara/ ]; then
	if [ ! -d $EXTPATH/.openlara/ ]; then
		echo "OpenLara backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.openlara/
	fi
	echo "Comparing OpenLara data..."
	diff -rq $INTPATH/.openlara/savegame.dat $EXTPATH/.openlara/savegame.dat
	sleep 1
fi

# Diffs GCW Connect data
if [ -d $INTPATH/.local/share/gcwconnect/networks/ ]; then
	if [ ! -d $EXTPATH/.local/share/gcwconnect/networks/ ]; then
		echo "GCW Connect backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.local/share/gcwconnect/networks/
	fi
	echo "Comparing GCW Connect data..."
	diff -rq $INTPATH/.local/share/gcwconnect/networks/* $EXTPATH/.local/share/gcwconnect/networks/
	sleep 1
fi

# Diffs Super Mario 64 Port data
if [ -d $INTPATH/.sm64-port/ ]; then
	if [ ! -d $EXTPATH/.sm64-port/ ]; then
		echo "Super Mario 64 backup folder doesn't exist, creating folder."
		mkdir -p $EXTPATH/.sm64-port/
	fi
	echo "Comparing Super Mario 64 data..."
	diff -rq $INTPATH/.sm64-port/sm64_save_file.bin $EXTPATH/.sm64-port/
	sleep 1
fi

echo ""
echo "Save comparison complete."
echo "Report saved to ~/log/$TIMESTAMP.txt"
read -p "Press START to exit."
exit
