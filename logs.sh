#!/bin/bash

LOGDIR=/var/log/
START="Apr 27, 2015 8:00:00 PM"
END="Apr 30, 2015 8:00:00 PM"
SEVERITY=SEVERE
OUTPUT=/root/test.txt

set -e

which date >/dev/null 2>&1
which cut >/dev/null 2>&1
which wc >/dev/null 2>&1

function date_to_epoch {
	date -d"$1" +%s
}

function parse_logfile {
	local LOGFILE=$1
	local TMP=$(mktemp)
	local LINE=
	
	echo "Reading $LOGFILE..."
	while read LINE; do
		local TIME=$(echo $LINE | cut -d' ' -f1-5)
		local EPOCH=$(date_to_epoch "$TIME")
		
		local SEV=$(echo $LINE | cut -d' ' -f8 | cut -d':' -f1)
		
		if (( EPOCH >= START_EPOCH )) && (( EPOCH <= END_EPOCH)); then
			if [[ "$SEV" == "$SEVERITY" ]]; then
				echo $LINE >> $TMP
			fi
		fi
	done < $LOGFILE
	
	local C=$(wc -l $TMP | cut -d' ' -f1)
	if (( C > 0 )); then
		echo "$C entries found."
		echo $LOGFILE >> $OUTPUT
		echo $C >> $OUTPUT
		cat $TMP >> $OUTPUT
	fi
	
	/bin/rm -f $TMP
}

START_EPOCH=$(date_to_epoch "$START")
END_EPOCH=$(date_to_epoch "$END")

[[ -f $OUTPUT ]] && /bin/rm -f $OUTPUT

for FILE in $LOGDIR/*; do
	parse_logfile $FILE
done
