# ---- My Timer ---- #

# ------------------
# Create a log for today
# ... get date
date6=$( date '+%y%m%d' )

# ... get part of day (AM/PM/EVE)
declare -i tempHour=$( date '+%l' )
declare -- tempAM=$( date '+%p' )

if [ $tempAM = AM ]
then
	ampm=AM
elif [ $tempHour -ge 7 ]
then
	ampm=EVE
else
	ampm=PM
fi

# ... create log where filename = 6-digit date (yymmdd.txt)
touch $date6.txt
declare -i nlines=$(< $date6.txt wc -l)

if [ $nlines = 0 ]
then	# initialize
	printf '%s\t%s\t%s\t%s\t%s\t%s\n' "nTimer" "Worked" "Earned" "AM/PM" "TotW" "TotE" >> $date6.txt
	declare -i nTimer=0		# initialize number of timers completed
	declare -i sWorked=0	# initialize total time lapsed
	declare -i sEarned=0 	# initialize total time earned
else
	arrLast=($( tail -n 1 $date6.txt ))
	declare -i nTimer=$[ $nlines - 1 ]
	declare -i sWorked=${arrLast[4]}
	declare -i sEarned=${arrLast[5]}
	printf '\n%s\n' "!!!You've worked $sWorked min and earned $sEarned min!!!"
fi

# ------------------
# Now the TIMER(s)
inCont=y 				# initialize continuation dummy

while [ $inCont = y ]
do
	# ... start timer
	printf '\n%s\n' "Hello 2too, choose your E[T] (^-^)/"
	read inMean

	printf '\n%s\n' "Now choose your range\(^-^)"
	read inRange

	printf '\n%s\n' "Finally, pick a ratio of return\(^-^)/"
	read inRate

	declare -i tdrawn=$(( RANDOM % ( $inRange + 1) + $inMean ))
	declare -i tsaved=$(( $tdrawn / $inRate ))

	ttimer $tdrawn

	# ... sound feedback
	printf \\a 			# 'duang' sound
	say -v Kyoko おめでと う	     
	#say -v Ting-Ting 完成啦！休息，休息一下	# say -v \? for a list of voices

	# ... update and record time to log
	declare -i nTimer=$[ $nTimer + 1 ]
	declare -i sWorked=$[ $sWorked + $tdrawn ]
	declare -i sEarned=$[ $sEarned + $tsaved ]
	printf '%s\t%s\t%s\t%s\t%s\t%s\n' $nTimer $tdrawn $tsaved $ampm $sWorked $sEarned >> $date6.txt

	# ... ask whether to continue
	printf '\n%s\n' "Would you like to start a new timer? (y / anything)"
	read inCont
done
