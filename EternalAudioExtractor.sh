#!/usr/bin/env bash

# This file is part of EternalBasher (https://github.com/leveste/EternalBasher).
# Copyright (C) 2021 leveste and PowerBall253
#
# EternalBasher is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# EternalBasher is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with EternalBasher. If not, see <https://www.gnu.org/licenses/>.

printf "\n\nEternalAudioExtractor.sh\n
				by leveste\n
				based on a script by proteh and Zwip-Zwap Zapony\n\n"


MissingOutput(){
	printf "Are you out of space on your storage medium, or did you use an invalid output path?\n
	The output directory you provided was: %s" "$___OUTPUT_DIRECTORY"
	exit
}

MissingResources(){
	printf "Is your DOOM Eternal installation incomplete, or did you use a wrong path?
	\n music.snd should be located at ../DOOMEternal/base/sound/soundbanks/pc/music.snd
	The output directory path that you gave was %s" "$___GAME_SOUND_FILES_DIRECTORY"
	exit
}

OutputNotEmpty(){
	printf "To avoid inconveniencing you, this batch file won't extract to an output directory that already has files and/or folders in it.
	The output directory path that you gave was %s" "$___OUTPUT_DIR"
	exit
}



___EXTRACTOR_OPTIONS=""
___GAME_SOUND_FILES_DIRECTORY="$HOME/.local/share/Steam/steamapps/common/DOOMEternal/base/sound/soundbanks/pc/"
___OUTPUT_DIRECTORY=""

CD=""


printf "\n\nThis batch file runs EternalAudioExtractor to extract the contents of all of DOOM Eternal's *.snd archives in one go.\n\n\n
The default location for your game directory is set to %s.\n
			Press 'Y' if you wish to change it. Press any other key to continue with this setting." "$___GAMEDIR"

read -r y

if [[ $y == [yY] ]]
then
	read -rp "Please input the full path to your DOOM Eternal installation: " ___OUTPUT_DIRECTORY
fi

if ! [[ "$___GAME_SOUND_FILES_DIRECTORY" == */ ]]; then ___GAME_SOUND_FILES_DIRECTORY="${___GAME_SOUND_FILES_DIRECTORY}/"; fi


# Check for files

if ! ([[ -f "${___GAME_SOUND_FILES_DIRECTORY}music.snd" ]] || [[ -f "${___GAME_SOUND_FILES_DIRECTORY}mus.pck ]] || [[ -f "${___GAME_SOUND_FILES_DIRECTORY}soundmetadata.bin" ]]); then MissingResources; fi

