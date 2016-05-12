note
	description: "Summary description for {BUTTON_STATUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BUTTON_STATUS

inherit
	BUTTON_STATUS_CONSTANTS

feature -- Access

	is_pressed:BOOLEAN
		deferred
		end

	manifest:READABLE_STRING_GENERAL
		deferred
		end

end
