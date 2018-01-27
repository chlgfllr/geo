## Text grid maker.praat
## Originally created by the excellent Katherine Crosswhite
## Script modified by Mark Antoniou
## Modified by Eric Doty
## Edited by Chloe Gfeller for use in Master's thesis

## What does it do?
## This script opens all files in a directory. It creates a TextGrid for each of sound file, then opens the sound file and the TextGrid into the editor so you can add boundaries and labels.

## Leaving the "Word" field blank will open all sound files in a directory. By specifying a Word, you can open only those files that begin with a particular sequence of characters. For example, only tokens whose filenames begin with ba.

## The script will skip over any files in the directory that already have an associated .TextGrid file

# The following four lines will create a dialog box, asking for the directory location you want to use. The two variables, "Directory" and "Word" will be used later in the script, where they are referred to as "directory$" and "word$", the dollar sign indicating that they are both string variables.

form Enter directory and search string
# Be sure not to forget the slash (Windows: backslash, OSX: forward slash)  at the end of the directory name.
	sentence Directory 
	sentence Word 
	sentence Filetype wav
endform

clearinfo

# Make a list of all sound files in the directory.
Create Strings as file list... file-list 'directory$''word$'*.'filetype$'

# Loop for all files.
number_of_files = Get number of strings
for x from 1 to number_of_files

# Now we will set up a string variable called "current_file$" and use it to store the first filename from the list.  
	select Strings file-list
	current_file$ = Get string... x

# Now that we have the filename, we read in that file:
     	Read from file... 'directory$''current_file$'

# A variable called "object_name$" will have the name of the sound object.  This is equivalent to the filename minus the extension. This will be useful for referring to the sound object later.
     	object_name$ = selected$ ("Sound")

# Check if TextGrid exists for the file
	textgrid_filename$ = directory$ + object_name$ + ".TextGrid"
	if not fileReadable (textgrid_filename$)

# Now create a TextGrid for the current sound file. It will have only one tier named "segments".  You can have multiple tiers, each with its own name.  For example, I could've made three tiers by saying To TextGrid... "utterances words segments".
     		To TextGrid... "word syllable segment glottis oral_vot glottal_vot"

# Since we have just created a TextGrid, it is automatically selected. We need both the TextGrid and the sound object to be selected together, so we must add the sound object to the selection.
     		plus Sound 'object_name$'

# We want to open those two selected objects (Sound object and Textgrid object) in the editor. 
     		Edit

# The script will pause, allowing the user to enter the appropriate marks using the mouse and keyboard.  Note that the user does not need to save the textgrid. They will click on "continue" to move to the next sound. 
     		pause  Mark your segments. 

# We will save the TextGrid object, so that the user doesn't have to do it for each file. First, deselect the sound object, leaving only the TextGrid selected.
    		minus Sound 'object_name$'

# Save the textgrid, giving it the same filename as the sound file, and the extension ".TextGrid". 
     		Save as text file... 'directory$''object_name$'.TextGrid
	endif

#    End the loop, and go on to the next file. To conserve memory, first remove the objects that we are through with. I like to do this by selecting all the objects in the list, then deselecting any we will still be using, such as the list of filenames.
    	select all
	minus Strings file-list
	Remove

# This specifies the end of the loop.
endfor

# Clean up the Praat objects window.
select Strings file-list
Remove

# Display a message letting you know that you've reached the end of the list.
printline TextGrids have been created for 'word$'.'filetype$' files in 
printline 'directory$'