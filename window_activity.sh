#!/bin/sh
DATABASE_PATH=${WINDOW_ACTIVITY_DATABASE_PATH:-$HOME/.window_activity.sqlite}

if [ ! -f $DATABASE_PATH ]; then
	sqlite3 $DATABASE_PATH "\
		CREATE TABLE activity (process_name TEXT, window_title TEXT, since INTEGER, until INTEGER); \
		CREATE INDEX process_name_idx ON activity (process_name); \
		CREATE INDEX window_title_idx ON activity (window_title);"
fi

save_activity () {
	until=$(date +%s)
	# Debug: echo "$(date -Iseconds): $process_name $window_title $since $until" >> $HOME/.window_activity.log
	sqlite3 $DATABASE_PATH "\
		INSERT INTO activity (process_name, window_title, since, until) \
		VALUES ('$process_name', '$window_title', $since, $until)"
}

# TODO: Save last iteration
# TODO: Detect changes in titles
xprop -root -spy _NET_ACTIVE_WINDOW | \
while read line; do
	current_window_id=$(echo $line | cut -d" " -f5)

	if [ $current_window_id != "0x0" ]; then
		[ $previous_window_id ] && [ $current_window_id != $previous_window_id ] && save_activity

		process_name=$(xprop -id $current_window_id WM_CLASS | sed -n -e 's/.* "\(.*\)"$/\1/p' -e "s/'/\\\'/")
		window_title=$(xprop -id $current_window_id WM_NAME | sed -n -e 's/.* "\(.*\)"$/\1/p' -e "s/'/\\\'/")
		since=$(date +%s)
		previous_window_id=$current_window_id
	fi
done
