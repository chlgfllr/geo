#Extracts time indices of labels in textgrid.
#Copyright Christian DiCanio, Haskins Laboratories, October 2011.
#Modifié avec l'aide de Shi

form Extract Time Indices from Textgrids
	sentence Directory_name: /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files
	sentence Output_folder: /Users/chloe/geo/
	sentence Log_file: acoustic_measures
	positive Labeled_tier_number: 3
endform



Create Strings as file list... list 'directory_name$'/*.TextGrid

num = Get number of strings
name$ = "'output_folder$'" + "'log_file$'" + ".txt"
#Create a single datafile with all the useful information
#header$="file filename"
header$ = "speaker	file	word	syll-nb	segment	syll-id	position	constriction	glottal-burst	vowel	v-duration	glottalization	vot'	vot	interburst	type 'newline$'"
fileappend "'name$'" 'header$'

for ifile to num
	select Strings list
	fileName$ = Get string... ifile
	ref$ = mid$("'fileName$'",1,17)
	speaker$ = mid$("'fileName$'",7,3)

	Read from file... 'directory_name$'/'fileName$'
	cGrid = selected("TextGrid")
	select 'cGrid'
	focus_word$ = Get label of interval... 1 2
	ints = Get number of intervals... 'labeled_tier_number'
	total_syll = Get number of intervals... 2
	fw_syll = total_syll - 2
	
	for i to ints
		segment$ = Get label of interval... 'labeled_tier_number' i
		if segment$ = "p>"
			start = Get start point... 'labeled_tier_number' i
			end = Get end point... 'labeled_tier_number' i
			s = Get interval at time: 2, start
			kel_syll$ = Get label of interval: 2, s
				if kel_syll$ = "1"
				position$ = "initial"
				elsif kel_syll$ = "2"
				position$ = "medial"
				elsif kel_syll$ = "3"
				position$ = "medial"
				endif
			
			glottal_burst$ = Get label of interval: 4, i
			
			next_segment$ = Get label of interval: 3, i+1
			next_start = Get start point: 3, i+1
			next_end = Get end point: 3, i+1
			next_duration = (next_end - next_start) * 1000
			
			glottal_vowel$ = Get label of interval: 4, i+1
			
			v = Get interval at time: 5, end
			extendVOT$ = Get label of interval: 5, v
			extendVOT_start = Get start point: 5, v
			extendVOT_end = Get end point: 5, v
			extendVOT_duration = (extendVOT_end - extendVOT_start) * 1000
			
			k = Get interval at time: 6, end
			regularVOT$ = Get label of interval: 6, k
			regularVOT_start = Get start point: 6, k
			regularVOT_end = Get end point: 6, k
			regularVOT_duration = (regularVOT_end - regularVOT_start) * 1000
			
			inter_burst = (extendVOT_duration - regularVOT_duration)
			total_duration = ((end - start) * 1000)
			type$ = "ejective"
			#writes a line in the output tsv file with name of file, focus word, number of syllables of the word, segment, which syllable it appears in, duration of segment in ms
			fileappend "'name$'" 'speaker$''tab$''ref$''tab$''focus_word$''tab$''fw_syll''tab$''segment$''tab$''kel_syll$''tab$''position$''tab$''total_duration:2''tab$''glottal_burst$''tab$''next_segment$''tab$''next_duration:2''tab$''glottal_vowel$''tab$''extendVOT_duration:2''tab$''regularVOT_duration:2''tab$''inter_burst:2''tab$''type$''newline$'
		elsif segment$ = "t>"
			start = Get start point... 'labeled_tier_number' i
			end = Get end point... 'labeled_tier_number' i
			s = Get interval at time: 2, start
			kel_syll$ = Get label of interval: 2, s
				if kel_syll$ = "1"
				position$ = "initial"
				elsif kel_syll$ = "2"
				position$ = "medial"
				elsif kel_syll$ = "3"
				position$ = "medial"
				endif
			
			glottal_burst$ = Get label of interval: 4, i
			
			next_segment$ = Get label of interval: 3, i+1
			next_start = Get start point: 3, i+1
			next_end = Get end point: 3, i+1
			next_duration = (next_end - next_start) * 1000
			
			glottal_vowel$ = Get label of interval: 4, i+1
			
			v = Get interval at time: 5, end
			extendVOT$ = Get label of interval: 5, v
			extendVOT_start = Get start point: 5, v
			extendVOT_end = Get end point: 5, v
			extendVOT_duration = (extendVOT_end - extendVOT_start) * 1000
			
			k = Get interval at time: 6, end
			regularVOT$ = Get label of interval: 6, k
			regularVOT_start = Get start point: 6, k
			regularVOT_end = Get end point: 6, k
			regularVOT_duration = (regularVOT_end - regularVOT_start) * 1000
			
			inter_burst = (extendVOT_duration - regularVOT_duration)
			total_duration = ((end - start) * 1000)
			type$ = "ejective"
			#writes a line in the output tsv file with name of file, focus word, number of syllables of the word, segment, which syllable it appears in, duration of segment in ms
			fileappend "'name$'" 'speaker$''tab$''ref$''tab$''focus_word$''tab$''fw_syll''tab$''segment$''tab$''kel_syll$''tab$''position$''tab$''total_duration:2''tab$''glottal_burst$''tab$''next_segment$''tab$''next_duration:2''tab$''glottal_vowel$''tab$''extendVOT_duration:2''tab$''regularVOT_duration:2''tab$''inter_burst:2''tab$''type$''newline$'
		elsif segment$ = "k>"
			start = Get start point... 'labeled_tier_number' i
			end = Get end point... 'labeled_tier_number' i
			s = Get interval at time: 2, start
			kel_syll$ = Get label of interval: 2, s
				if kel_syll$ = "1"
				position$ = "initial"
				elsif kel_syll$ = "2"
				position$ = "medial"
				elsif kel_syll$ = "3"
				position$ = "medial"
				endif
			
			glottal_burst$ = Get label of interval: 4, i
			
			next_segment$ = Get label of interval: 3, i+1
			next_start = Get start point: 3, i+1
			next_end = Get end point: 3, i+1
			next_duration = (next_end - next_start) * 1000
			
			glottal_vowel$ = Get label of interval: 4, i+1
			
			v = Get interval at time: 5, end
			extendVOT$ = Get label of interval: 5, v
			extendVOT_start = Get start point: 5, v
			extendVOT_end = Get end point: 5, v
			extendVOT_duration = (extendVOT_end - extendVOT_start) * 1000
			
			k = Get interval at time: 6, end
			regularVOT$ = Get label of interval: 6, k
			regularVOT_start = Get start point: 6, k
			regularVOT_end = Get end point: 6, k
			regularVOT_duration = (regularVOT_end - regularVOT_start) * 1000
			
			inter_burst = (extendVOT_duration - regularVOT_duration)
			total_duration = ((end - start) * 1000)
			type$ = "ejective"
			#writes a line in the output tsv file with name of file, focus word, number of syllables of the word, segment, which syllable it appears in, duration of segment in ms
			fileappend "'name$'" 'speaker$''tab$''ref$''tab$''focus_word$''tab$''fw_syll''tab$''segment$''tab$''kel_syll$''tab$''position$''tab$''total_duration:2''tab$''glottal_burst$''tab$''next_segment$''tab$''next_duration:2''tab$''glottal_vowel$''tab$''extendVOT_duration:2''tab$''regularVOT_duration:2''tab$''inter_burst:2''tab$''type$''newline$'
		elsif segment$ = "p"
			start = Get start point... 'labeled_tier_number' i
			end = Get end point... 'labeled_tier_number' i
			s = Get interval at time: 2, start
			kel_syll$ = Get label of interval: 2, s
				if kel_syll$ = "1"
				position$ = "initial"
				elsif kel_syll$ = "2"
				position$ = "medial"
				elsif kel_syll$ = "3"
				position$ = "medial"
				endif
			
			glottal_burst$ = Get label of interval: 4, i
			
			next_segment$ = Get label of interval: 3, i+1
			next_start = Get start point: 3, i+1
			next_end = Get end point: 3, i+1
			next_duration = (next_end - next_start) * 1000
			
			glottal_vowel$ = Get label of interval: 4, i+1
			zero$ = "0"
			k = Get interval at time: 5, end
			regularVOT$ = Get label of interval: 5, k
			regularVOT_start = Get start point: 5, k
			regularVOT_end = Get end point: 5, k
			regularVOT_duration = (regularVOT_end - regularVOT_start) * 1000
			
			total_duration = ((end - start) * 1000)
			type$ = "pulmonic"
			#writes a line in the output tsv file with name of file, focus word, number of syllables of the word, segment, which syllable it appears in, duration of segment in ms
			fileappend "'name$'" 'speaker$''tab$''ref$''tab$''focus_word$''tab$''fw_syll''tab$''segment$''tab$''kel_syll$''tab$''position$''tab$''total_duration:2''tab$''glottal_burst$''tab$''next_segment$''tab$''next_duration:2''tab$''glottal_vowel$''tab$''zero$''tab$''regularVOT_duration:2''tab$''zero$''tab$''type$''newline$'
		elsif segment$ = "t"
			start = Get start point... 'labeled_tier_number' i
			end = Get end point... 'labeled_tier_number' i
			s = Get interval at time: 2, start
			kel_syll$ = Get label of interval: 2, s
				if kel_syll$ = "1"
				position$ = "initial"
				elsif kel_syll$ = "2"
				position$ = "medial"
				elsif kel_syll$ = "3"
				position$ = "medial"
				endif
			
			glottal_burst$ = Get label of interval: 4, i
			
			next_segment$ = Get label of interval: 3, i+1
			next_start = Get start point: 3, i+1
			next_end = Get end point: 3, i+1
			next_duration = (next_end - next_start) * 1000
			
			glottal_vowel$ = Get label of interval: 4, i+1
			zero$ = "0"
			extendVOT$ = "0"
			extendVOT_duration$ = "0"
			
			k = Get interval at time: 5, end
			regularVOT$ = Get label of interval: 5, k
			regularVOT_start = Get start point: 5, k
			regularVOT_end = Get end point: 5, k
			regularVOT_duration = (regularVOT_end - regularVOT_start) * 1000
			
			total_duration = ((end - start) * 1000)
			type$ = "pulmonic"
			#writes a line in the output tsv file with name of file, focus word, number of syllables of the word, segment, which syllable it appears in, duration of segment in ms
			fileappend "'name$'" 'speaker$''tab$''ref$''tab$''focus_word$''tab$''fw_syll''tab$''segment$''tab$''kel_syll$''tab$''position$''tab$''total_duration:2''tab$''glottal_burst$''tab$''next_segment$''tab$''next_duration:2''tab$''glottal_vowel$''tab$''zero$''tab$''regularVOT_duration:2''tab$''zero$''tab$''type$''newline$'
		elsif segment$ = "k"
			start = Get start point... 'labeled_tier_number' i
			end = Get end point... 'labeled_tier_number' i
			s = Get interval at time: 2, start
			kel_syll$ = Get label of interval: 2, s
				if kel_syll$ = "1"
				position$ = "initial"
				elsif kel_syll$ = "2"
				position$ = "medial"
				elsif kel_syll$ = "3"
				position$ = "medial"
				endif
			
			glottal_burst$ = Get label of interval: 4, i
			
			next_segment$ = Get label of interval: 3, i+1
			next_start = Get start point: 3, i+1
			next_end = Get end point: 3, i+1
			next_duration = (next_end - next_start) * 1000
			
			glottal_vowel$ = Get label of interval: 4, i+1
			zero$ = "0"
			k = Get interval at time: 5, end
			regularVOT$ = Get label of interval: 5, k
			regularVOT_start = Get start point: 5, k
			regularVOT_end = Get end point: 5, k
			regularVOT_duration = (regularVOT_end - regularVOT_start) * 1000
			
			total_duration = ((end - start) * 1000)
			type$ = "pulmonic"
			#writes a line in the output tsv file with name of file, focus word, number of syllables of the word, segment, which syllable it appears in, duration of segment in ms
			fileappend "'name$'" 'speaker$''tab$''ref$''tab$''focus_word$''tab$''fw_syll''tab$''segment$''tab$''kel_syll$''tab$''position$''tab$''total_duration:2''tab$''glottal_burst$''tab$''next_segment$''tab$''next_duration:2''tab$''glottal_vowel$''tab$''zero$''tab$''regularVOT_duration:2''tab$''zero$''tab$''type$''newline$'
		endif		
	endfor
endfor

select all
Remove