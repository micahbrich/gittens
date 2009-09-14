-- gitten.applescript
-- gittens
--
-- icon by Nora (nora_pixel@hotmail.com) via http://www.pixelgirlpresents.com/icons.php
--
--  Created by Micah Rich on 9/13/09.
--  Copyright 2009 A Good Company™. All rights reserved.

property thePath : ""
property theStatus : ""
property extraMessage : ""
global theWindow


on clicked theObject
	set_path()
	set object_name to name of theObject
	if object_name is "pull" then
		do shell script "bin/bash/ cd " & thePath & " ;/usr/local/git/bin//git pull origin master"
		set extraMessage to the result
	else if object_name is "AddCommit" then
		set messageDialog to (display dialog "Please enter your commit message:" buttons {"Cancel", "Commit"} default answer "" default button 2 with answer)
		set theMessage to text returned of messageDialog
		do shell script "cd " & thePath & " ;/usr/local/git/bin//git add ."
		do shell script "cd " & thePath & " ;/usr/local/git/bin//git commit -a -m\"" & theMessage & "\""
		set extraMessage to the result
		
	else if object_name is "push" then
		do shell script "cd " & thePath & " ; /usr/local/git/bin//git push origin master"
		set extraMessage to the result
	end if
	set_status(extraMessage)
	
end clicked

on idle theObject
	set_path()
	set_status(extraMessage)
end idle

on activated theObject
	set_path()
	set_status("Welcome!")
end activated



on set_path()
	tell application "Finder"
		set theWindow to window 1
		set thePath to (POSIX path of (target of theWindow as alias))
	end tell
end set_path

on set_status(extraMessage)
	set_path()
	set theGitPath to (thePath & ".git" & "/config")
	if exists POSIX file (theGitPath) as string then
		try
			set gitStatus to do shell script "cd " & thePath & " ;/usr/local/git/bin//git status"
		on error errStr
			set gitStatus to errStr
			if gitStatus contains ("fatal:" as string) then
				set theStatus to (theGitPath & " isn't a git repo!")
			else
				set theStatus to ((extraMessage as string) & "
" & "
" & gitStatus)
				
			end if
		end try
		
	else
		set theStatus to (theGitPath & " isn't a git repo!")
		
	end if
	
	set the string value of text field "ResultsBox" of window "main" to (theStatus)
	
end set_status