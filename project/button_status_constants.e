note
	description: "Summary description for {BUTTON_STATUS_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BUTTON_STATUS_CONSTANTS

feature {NONE} -- Constants

	manifest_keyboard_virtual:STRING_32
		once
			Result := {STRING_32}"Keyboard_Virtual_"
		end

	Manifest_keyboard_physical:STRING_32
		once
			Result := {STRING_32}"Keyboard_Physical_"
		end

end
