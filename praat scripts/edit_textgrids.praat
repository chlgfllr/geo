##  This script opens all the sound files in a given directory, plus their associated textgrids so that you can review/change the marks.


directory$ = "C:\Users\chloe_000\OneDrive\Documents\M2\Georgian\Data\Recordings\s08_Nino\original_020\s08_interv020\vot_s08\"
extension$ = ".wav"

Create Strings as file list... list 'directory$'*'extension$'
number_of_files = Get number of strings
for x from 1 to number_of_files
     select Strings list
     current_file$ = Get string... x
     Read from file... 'directory$''current_file$'
     object_name$ = selected$ ("Sound")
     Read from file... 'directory$''object_name$'.TextGrid
     plus Sound 'object_name$'
     Edit
     pause  Mark your segments! 
     minus Sound 'object_name$'
     Write to text file... 'directory$''object_name$'.TextGrid
     select all
     minus Strings list
     Remove
endfor

select Strings list
Remove
print All files processed -- that was fun!

## written by Katherine Crosswhite
## crosswhi@ling.rochester.edu