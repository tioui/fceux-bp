note
	description: "A {BUTTON_STATUS} that is managed by a physical keyboard button"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	KEYBOARD_PHYSICAL_STATUS

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
