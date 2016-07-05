note
	description: "A {JOYSTICK_STATUS} to manage joystick buttons."
	author: "Louis Marchand"
	date: "Thu, 16 Jun 2016 20:07:02 +0000"
	revision: "0.1"

class
	JOYSTICK_BUTTON_STATUS

inherit
	JOYSTICK_STATUS
		redefine
			has_error, manifest
		end

create
	make

feature {NONE} -- Implementation

	make(a_joystick_index, a_button_index:INTEGER)
			-- Initialization of `Current' using `a_joystick_index' to initialize `joystick'
			-- and `a_button_index' as `button_index'
		do
			make_with_index (a_joystick_index)
			if not has_error then
				if button_index < joystick.buttons_count then
					button_index := a_button_index
				else
					has_internal_error := True
				end
			end

		end

feature -- Access

	button_index:INTEGER
			-- The index of the button in `joystick'

	has_error:BOOLEAN
			-- <Precursor>
		do
			Result := Precursor {JOYSTICK_STATUS} or has_internal_error
		end

	is_pressed:BOOLEAN
			-- <Precursor>
		require else
			No_Error: not has_error
		do
			if not has_error then
				Result := joystick.is_button_pressed (button_index)
			else
				Result := False
			end
		end


	manifest:READABLE_STRING_GENERAL
			-- <Precursor>
		do
			Result := Precursor {JOYSTICK_STATUS} + Manifest_joystick_button + button_index.out
		end

feature {NONE} -- Implementation

	has_internal_error:BOOLEAN
			-- Internal representation of `has_error'

end
