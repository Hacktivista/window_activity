# window_activity.sh

```
./window_activity.sh
```

Captures window activity and saves to a SQLite database.

## Requirements

- xprop
- [SQLite](https://sqlite.org)

## Configuration

### Environment variables

- `WINDOW_ACTIVITY_DATABASE_PATH` defaults to `$HOME/.window_activity.sqlite`: Set database path

## Installation

It's a good idea to copy it in a place in your `$PATH`, like `/usr/local/bin`.

## Wishlist

- Save last window activity, it's lost because data is captured on active windows changes
- Detect changes in titles, as it's captured by active window change, title changes (Eg. browser tab change) are in the same window, so not detected
- Wayland support?

## Useful SQL queries

### Count seconds per window in a date range

```
SELECT process_name as Process, window_title as Window,
SUM(until - since) as Seconds
FROM activity
WHERE since >= strftime('%s','2017-10-01 00:00:00')
AND until < strftime('%s','2017-11-01 00:00:00')
GROUP BY Window
ORDER BY Seconds DESC;
```
