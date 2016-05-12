note
	description: "Summary description for {KEYBOARD_HARDWARE_STATUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	KEYBOARD_HARDWARE_STATUS

inherit
	KEYBOARD_STATUS

create
	make

feature -- Access

	on_pressed(a_key:GAME_KEY)
			-- <Precursor>
		do
			if key_code = a_key.physical_code then
				is_pressed := True
			end
		end

	on_released(a_key:GAME_KEY)
			-- <Precursor>
		do
			if key_code = a_key.physical_code then
				is_pressed := False
			end
		end

	manifest:READABLE_STRING_GENERAL
			-- <Precursor>
		do
			Result := manifest_keyboard_physical + key_code.out
		end

end
