"""
A script to automatically export bookmarks from Firefox's SQLite database.

There does not seem to be a programmatic way to get Firefox to export its bookmarks in
the conventional HTML format. However, you can access the bookmark information directly
in Firefox's internal database, which is what this script does.

Always be careful when working with the internal database! If you delete data, you will
likely not be able to recover it.

Author:  Ian Fisher (iafisher@protonmail.com)
Version: March 2019
"""
import os
import json
import shutil
import sqlite3
import tempfile
from collections import namedtuple


FIREFOX_FOLDER = "/home/node/.mozilla/firefox/i0b92six.default-esr"


# The `add_date` and `last_modified` fields are integer timestamps, which can be
# converted to human-readable strings by the time.ctime standard library functions.
# The `tags` field is a list of strings; all other fields are just strings.
Bookmark = namedtuple(
    "Bookmark", ["id", "title", "url", "add_date", "last_modified", "tags", "parent", "guid"]
)


# Firefox acquires a lock on places.sqlite that prevents us from even reading the
# database file, so we need to copy it to a temporary directory first so that the script
# works even when Firefox is open.
tmpdir = tempfile.gettempdir()
shutil.copy(os.path.join(FIREFOX_FOLDER, "places.sqlite"), tmpdir)

conn = sqlite3.connect(os.path.join(tmpdir, "places.sqlite"))
cursor = conn.cursor()
cursor.execute("""
    SELECT
        moz_places.id, 
        moz_places.guid,
        moz_bookmarks.title, 
        moz_places.url, 
        moz_bookmarks.dateAdded,
        moz_bookmarks.lastModified,
        moz_bookmarks.parent
    FROM
        moz_bookmarks
    LEFT JOIN
        -- The actual URLs are stored in a separate moz_places table, which is pointed
        -- at by the moz_bookmarks.fk field.
        moz_places
    ON
        moz_bookmarks.fk = moz_places.id
    WHERE
        -- Type 1 is for bookmarks; type 2 is for folders and tags.
        moz_bookmarks.type = 1
    AND
        moz_bookmarks.title IS NOT NULL
    ;
""")
rows = cursor.fetchall()

# A loop to get the tags for each bookmark.
bookmarks = []
for place_id, guid, title, url, date_added, last_modified, parent_id in rows:
    # Fetch the parent bookmark's title and guid
    cursor.execute("""
        SELECT 
            A.title, 
            A.guid  -- Fetching the parent's guid
        FROM 
            moz_bookmarks A, 
            moz_bookmarks B
        WHERE
            A.id <> B.id
        AND
            B.parent = A.id
        AND
            B.title IS NULL
        AND
            B.fk = ?;
    """, (place_id,))
    
    tag_names = [r[0] for r in cursor.fetchall()]
    
    # Fetch the parent bookmark's guid
    cursor.execute("SELECT title, guid FROM moz_bookmarks WHERE id=?", (parent_id,))
    parent_title, parent_guid = cursor.fetchone()  # Unpack both title and guid

    # Update the Bookmark instantiation to use parent_guid
    print(json.dumps(Bookmark(parent_title, title, url, date_added, last_modified, tag_names, parent_guid, guid)._asdict()))

conn.close()

chromium