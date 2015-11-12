#!/bin/sh

# REMEMBER TO EDIT LINE 6 and 9

# Your ShowRSS user id. Log on to ShowRSS and extract it from a feed address at http://showrss.info/?cs=feeds
SHOWRSS_USER_ID=123456789

# Directory where you want torrent files to be saved to
TORRENTS_DIR=""

FEED_URI="http://showrss.info/rss.php?user_id=$SHOWRSS_USER_ID&hd=null&proper=null&magnets=false&namespaces=true"

echo "Downloading feed data"

# This looks a bit odd, but it's done this way to make it work on as many platforms as possible
TORRENT_URLS=$(curl --progress-bar $FEED_URI | tr ">" "\n" | egrep -o "enclosure\ url=\"(.*?)\"" | cut -d "\"" -f 2)

for TORRENT_URL in $TORRENT_URLS
do
    TORRENT_FILENAME=$(basename "$TORRENT_URL")
    
    FILE_PATH="$TORRENTS_DIR/$TORRENT_FILENAME"
    
    if ! [ -f $FILE_PATH ]
    then
        echo "Downloading torrent file"
        curl --progress-bar -o $FILE_PATH $TORRENT_URL
    fi
done
