note
	description: "Summary description for {KEYBOARD_VIRTUAL_STATUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	KEYBOARD_VIRTUAL_STATUS

inherit
	KEYBOARD_STATUS
		rename
			make as make_with_code
		end

create
	make

feature {NONE} -- Implementation

	make(a_name:READABLE_STRING_GENERAL)
		local
			l_key:GAME_KEY
		do
			create l_key.make_from_name (a_name)
			make_with_code(l_key.virtual_code)
		end

feature -- Access

	on_pressed(a_key:GAME_KEY)
			-- <Precursor>
		do
			if key_code = a_key.virtual_code then
				is_pressed := True
			end
		end

	on_released(a_key:GAME_KEY)
			-- <Precursor>
		do
			if key_code = a_key.virtual_code then
				is_pressed := False
			end
		end

	manifest:READABLE_STRING_GENERAL
			-- <Precursor>
		local
			l_key:GAME_KEY
		do
			create l_key.make_from_virtual_code (key_code)
			Result := manifest_keyboard_virtual + l_key.unicode_out
		end

end
