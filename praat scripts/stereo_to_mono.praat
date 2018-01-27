# This script extracts the left channel (or just the single channel from 1-channel
# recordings) from all .wav, .WAV, .aif, and .AIF sound files, removes the original
# file, and saves each as a .wav file.
# This is handy for prepping files from annoying recorders
# that make two-channel recordings when only one contains
# any data.
# If a .wav file with the same name already exists, it will be overwritten.
# Don't forget to back up your sound files in a separate
# folder before running.

# handsomely flummoxed 12/2011 by dan brenner
# dbrenner atmark email dot arizona dot edu
#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#

dir$ = chooseDirectory$ ("C:\Users\chloe_000\Desktop\data")
printline 'dir$'/

wavlist = Create Strings as file list... wl 'dir$'/*.wav
nwavlist = Get number of strings

if nwavlist > 0
	for f to nwavlist
		select wavlist
		name$ = Get string... f
		sound = Read from file... 'dir$'/'name$'
		left = Extract one channel... Left
		filedelete 'dir$'/'name$'
		Save as WAV file... 'dir$'/'name$'
		plus sound
		Remove
	endfor
endif

select wavlist
Remove
printline All done.