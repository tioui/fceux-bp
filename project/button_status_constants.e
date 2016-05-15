note
	description: "Constants used in buttons configuration manifests."
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

deferred class
	BUTTON_STATUS_CONSTANTS

feature {NONE} -- Constants

	manifest_keyboard_name:STRING_32
			-- The prefix of the manifest text for keyboard name
		once
			Result := {STRING_32}"Keyboard_Name_"
		end

	manifest_keyboard_virtual:STRING_32
			-- The prefix of the manifest text for virtual keyboard code
		once
			Result := {STRING_32}"Keyboard_Virtual_"
		end

	Manifest_keyboard_physical:STRING_32
			-- The prefix of the manifest text for physical keyboard code
		once
			Result := {STRING_32}"Keyboard_Physical_"
		end

end
