note
	description: "A {BUTTON_STATUS} that is managed by a virtual keyboard button"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	KEYBOARD_VIRTUAL_STATUS

inherit
	KEYBOARD_STATUS
		rename
			make as make_with_code
		end

create
	make_with_name,
	make_with_code

feature {NONE} -- Implementation

	make_with_name(a_name:READABLE_STRING_GENERAL)
			-- Initialisation of `Current' using `a_name' as button name
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
		do
			Result := manifest_keyboard_virtual + key_code.out.as_string_32
		end

end
