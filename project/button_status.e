note
	description: "An interface for the buttons status report"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

deferred class
	BUTTON_STATUS

inherit
	BUTTON_STATUS_CONSTANTS

feature -- Access

	is_pressed:BOOLEAN
			-- `Current' has been pressed
		deferred
		end

	manifest:READABLE_STRING_GENERAL
			-- Text representation of `Current' to store in {CONFIGURATION}
		deferred
		end

end
