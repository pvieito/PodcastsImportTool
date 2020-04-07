reopen application "Podcasts"

tell application "System Events"
    tell process "Podcasts"
        set frontmost to true
        tell application "Podcasts" to open location "podcast:${feedURL}"

        delay 1
        set frontmost to true
        keystroke return
        delay 1
    end tell
end tell
