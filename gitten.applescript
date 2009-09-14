-- gitten.applescript
-- gittens

--  Created by Micah Rich on 9/13/09.
--  Copyright 2009 A Good Company™. All rights reserved.

property thePath : ""
property theStatus : ""

on run theObject
	set_path()
	set_status()
end run

on idle theObject
	set_path()
	set_status()
end idle

on clicked theObject
	set object_name to name of theObject
	if object_name is "pull" then
		do shell script "cd " & thePath & " && /usr/local/git/bin/git pull"
		set theStatus to the result
		set contents of text field "ResultsBox" of window 1 to theStatus as string
		
	else if object_name is "AddCommit" then
		set theMessage to (display dialog "Please enter your commit message:" buttons {"Cancel", "Commit"} default answer "" default button 2 with answer)
		try
			do shell script "cd " & thePath & " && /usr/local/git/bin/git add && /usr/local/git/bin/git commit -a -m'" & theMessage & "'"
		on error errStr
			set theStatus to errStr as string
			set contents of text field "ResultsBox" of window 1 to theStatus as string
		end try
		
	else if object_name is "push" then
		do shell script "cd " & thePath & " && /usr/local/git/bin/git push"
		set theStatus to the result
		set contents of text field "ResultsBox" of window 1 to theStatus as string
		
	end if
end clicked

on became key theObject
	set_path()
	set_status()
end became key

on became main theObject
	set_path()
	set_status()
end became main

on set_path()
	tell application "Finder"
		set theWindow to window 1
		set thePath to (POSIX path of (target of theWindow as alias))
	end tell
end set_path

on set_status()
	set theGitPath to (thePath & ".git" & "/config")
	if exists POSIX file (theGitPath) as string then
		try
			do shell script "cd " & thePath & " && /usr/local/git/bin/git status"
		on error errStr
			set theStatus to errStr
			if theStatus contains ("fatal:" as string) then
				set contents of text field "ResultsBox" of window 1 to (thePath & " isn't a git repo!")
			else
				set contents of text field "ResultsBox" of window 1 to (thePath & "
" & "
" & theStatus as string)
			end if
		end try
		
	else
		set contents of text field "ResultsBox" of window 1 to (theGitPath & " isn't a git repo!")
	end if
end set_status
