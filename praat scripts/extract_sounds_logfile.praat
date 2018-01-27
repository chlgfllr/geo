# Extrait des variables caracteristiques des enregistrements
# Extrait les séquences CV correspondantes qui nous intéressent
# The script is a modified version of the script "collect_formant_data_from_files.praat" by Mietta Lennes, available here: http://www.helsinki.fi/~lennes/praat-scripts/
# The modifications were done by Dan McCloy (drmccloy@uw.edu) in December 2011.

# This script is distributed under the GNU General Public License.
# Copyright 4.7.2003 Mietta Lennes

## Modified January 27 2018 by Chloe Gfeller

form Get pitch formants and duration from labeled segments in files
	comment Directory of sound files. Be sure to include the final "/"
	text sound_directory /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/resampled/
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files. Be sure to include the final "/"
	text textGrid_directory /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/resampled/
	sentence TextGrid_file_extension .TextGrid
	comment Full path of the resulting text file:
	text resultsfile /Users/chloe/Desktop/test_praat/data.item
	comment Which tier do you want to analyze?
	integer Tier 3
endform

# Make a listing of all the sound files in a directory:
Create Strings as file list... list 'sound_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultsfile$)
	pause The file 'resultsfile$' already exists! Do you want to overwrite it?
	filedelete 'resultsfile$'
endif

# Create a header row for the result file: (remember to edit this if you add or change the analyses!)
header$ = "#file onset offset #item phone pulm place vowel position speaker question new 'newline$'"
fileappend "'resultsfile$'" 'header$'

# Open each sound file in the directory:
for ifile to numberOfFiles
	filename$ = Get string... ifile
    ref$ = mid$("'filename$'",1,17)
	speaker$ = mid$("'filename$'",7,3)
    focus$ = mid$("'filename$",14,1)
    
	Read from file... 'sound_directory$''filename$'

	# get the name of the sound object:
	soundname$ = selected$ ("Sound", 1)

	# Look for a TextGrid by the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"

	# if a TextGrid exists, open it and do the analysis:
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		
        select TextGrid 'soundname$'
		numberOfIntervals = Get number of intervals... tier
        
		# Pass through all intervals in the designated tier, and if they have a label, do the analysis:
		for i to numberOfIntervals
            segment$ = Get label of interval... 3 i
            start = Get start point... 3 i
            s = Get interval at time: 2, start
        
            kel_syll$ = Get label of interval: 2, s
        
            if kel_syll$ = "1"
                position$ = "initial"
                                    
                    if segment$ = "p>"
                        start = Get start point... 'tier' i
                        end = Get end point... 'tier' i
                 
                        vowel$ = Get label of interval: 3, i+1
                        sequence$ = segment$ + vowel$
                        
                        type$ = "ejective"
                        place$ = "labial"
                 
                        quest$ = mid$("'filename$'",17,1)
                        
                        if quest$ = "1"
                            question$ = "question"
                        else
                            question$ = "answer"
                        endif
                 
                        if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                            echo$ = "new"
                        else
                            if quest$ = "1"
                                echo$ = "new"
                            else
                                echo$ = "echo"
                            endif
                        endif    
                        
                        sequence_start = Get start point... 3 i
                        sequence_end = Get end point... 3 i+1
            
                        select Sound 'soundname$'
                        Extract part: sequence_start, sequence_end, "rectangular", 1, "yes"
                        Write to WAV file... /Users/chloe/Desktop/test_praat/items/'ifile'.wav
                 
                        fileappend "'resultsfile$'" 'ref$' 'start:6' 'end:6' 'ifile' 'sequence$' 'type$' 'place$' 'vowel$' 'kel_syll$' 'speaker$' 'question$' 'echo$' 'newline$'

                        # select the TextGrid so we can iterate to the next interval:
                        select TextGrid 'soundname$'
                    
                    elsif segment$ = "t>"
                        start = Get start point... 'tier' i
                        end = Get end point... 'tier' i
                 
                        vowel$ = Get label of interval: 3, i+1
                        sequence$ = segment$ + vowel$
                        
                        type$ = "ejective"
                        place$ = "coronal"
                 
                        quest$ = mid$("'filename$'",17,1)
                        
                        if quest$ = "1"
                            question$ = "question"
                        else
                            question$ = "answer"
                        endif
                 
                        if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                            echo$ = "new"
                        else
                            if quest$ = "1"
                                echo$ = "new"
                            else
                                echo$ = "echo"
                            endif
                        endif    
                        
                        sequence_start = Get start point... 3 i
                        sequence_end = Get end point... 3 i+1
            
                        select Sound 'soundname$'
                        Extract part: sequence_start, sequence_end, "rectangular", 1, "yes"
                        Write to WAV file... /Users/chloe/Desktop/test_praat/items/'ifile'.wav
                         
                        fileappend "'resultsfile$'" 'ref$' 'start:6' 'end:6' 'ifile' 'sequence$' 'type$' 'place$' 'vowel$' 'kel_syll$' 'speaker$' 'question$' 'echo$' 'newline$'

                        # select the TextGrid so we can iterate to the next interval:
                        select TextGrid 'soundname$'
                        
                    elsif segment$ = "k>"
                        start = Get start point... 'tier' i
                        end = Get end point... 'tier' i
                 
                        vowel$ = Get label of interval: 3, i+1
                        sequence$ = segment$ + vowel$
                        
                        type$ = "ejective"
                        place$ = "velar"
                 
                        quest$ = mid$("'filename$'",17,1)
                        
                        if quest$ = "1"
                            question$ = "question"
                        else
                            question$ = "answer"
                        endif
                 
                        if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                            echo$ = "new"
                        else
                            if quest$ = "1"
                                echo$ = "new"
                            else
                                echo$ = "echo"
                            endif
                        endif 
                        
                        sequence_start = Get start point... 3 i
                        sequence_end = Get end point... 3 i+1
            
                        select Sound 'soundname$'
                        Extract part: sequence_start, sequence_end, "rectangular", 1, "yes"
                        Write to WAV file... /Users/chloe/Desktop/test_praat/items/'ifile'.wav
                 
                        fileappend "'resultsfile$'" 'ref$' 'start:6' 'end:6' 'ifile' 'sequence$' 'type$' 'place$' 'vowel$' 'kel_syll$' 'speaker$' 'question$' 'echo$' 'newline$'

                        # select the TextGrid so we can iterate to the next interval:
                        select TextGrid 'soundname$'
                        
                    elsif segment$ = "p"
                        start = Get start point... 'tier' i
                        end = Get end point... 'tier' i
                 
                        vowel$ = Get label of interval: 3, i+1
                        sequence$ = segment$ + vowel$
                        
                        type$ = "pulmonic"
                        place$ = "labial"
                 
                        quest$ = mid$("'filename$'",17,1)
                        
                        if quest$ = "1"
                            question$ = "question"
                        else
                            question$ = "answer"
                        endif
                 
                        if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                            echo$ = "new"
                        else
                            if quest$ = "1"
                                echo$ = "new"
                            else
                                echo$ = "echo"
                            endif
                        endif    
                        
                        sequence_start = Get start point... 3 i
                        sequence_end = Get end point... 3 i+1
            
                        select Sound 'soundname$'
                        Extract part: sequence_start, sequence_end, "rectangular", 1, "yes"
                        Write to WAV file... /Users/chloe/Desktop/test_praat/items/'ifile'.wav
                 
                        fileappend "'resultsfile$'" 'ref$' 'start:6' 'end:6' 'ifile' 'sequence$' 'type$' 'place$' 'vowel$' 'kel_syll$' 'speaker$' 'question$' 'echo$' 'newline$'

                        # select the TextGrid so we can iterate to the next interval:
                        select TextGrid 'soundname$'
                        
                    elsif segment$ = "t"
                        start = Get start point... 'tier' i
                        end = Get end point... 'tier' i
                 
                        vowel$ = Get label of interval: 3, i+1
                        sequence$ = segment$ + vowel$
                        
                        type$ = "pulmonic"
                        place$ = "coronal"
                 
                        quest$ = mid$("'filename$'",17,1)
                        
                        if quest$ = "1"
                            question$ = "question"
                        else
                            question$ = "answer"
                        endif
                 
                        if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                            echo$ = "new"
                        else
                            if quest$ = "1"
                                echo$ = "new"
                            else
                                echo$ = "echo"
                            endif
                        endif    
                        
                        sequence_start = Get start point... 3 i
                        sequence_end = Get end point... 3 i+1
            
                        select Sound 'soundname$'
                        Extract part: sequence_start, sequence_end, "rectangular", 1, "yes"
                        Write to WAV file... /Users/chloe/Desktop/test_praat/items/'ifile'.wav        
                 
                        fileappend "'resultsfile$'" 'ref$' 'start:6' 'end:6' 'ifile' 'sequence$' 'type$' 'place$' 'vowel$' 'kel_syll$' 'speaker$' 'question$' 'echo$' 'newline$'

                        # select the TextGrid so we can iterate to the next interval:
                        select TextGrid 'soundname$'
                        
                    elsif segment$ = "k"
                        start = Get start point... 'tier' i
                        end = Get end point... 'tier' i
                 
                        vowel$ = Get label of interval: 3, i+1
                        sequence$ = segment$ + vowel$
                        
                        type$ = "pulmonic"
                        place$ = "velar"
                 
                        quest$ = mid$("'filename$'",17,1)
                        
                        if quest$ = "1"
                            question$ = "question"
                        else
                            question$ = "answer"
                        endif
                 
                        if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                            echo$ = "new"
                        else
                            if quest$ = "1"
                                echo$ = "new"
                            else
                                echo$ = "echo"
                            endif
                        endif    
                                                
                        sequence_start = Get start point... 3 i
                        sequence_end = Get end point... 3 i+1
            
                        select Sound 'soundname$'
                        Extract part: sequence_start, sequence_end, "rectangular", 1, "yes"
                        Write to WAV file... /Users/chloe/Desktop/test_praat/items/'ifile'.wav
        
                 
                        fileappend "'resultsfile$'" 'ref$' 'start:6' 'end:6' 'ifile' 'sequence$' 'type$' 'place$' 'vowel$' 'kel_syll$' 'speaker$' 'question$' 'echo$' 'newline$'

                        # select the TextGrid so we can iterate to the next interval:
                        select TextGrid 'soundname$'
                        
                    endif
                
			endif
            
		endfor
	
    endif
	
    # Remove the Sound object
	select Sound 'soundname$'
	Remove
	# and go on with the next sound file!
	select Strings list

endfor

# When everything is done, remove the list of sound file paths:
Remove