note
	description: "Summary description for {KEYBOARD_STATUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	KEYBOARD_STATUS

inherit
	BUTTON_STATUS


feature {NONE} -- Initialization

	make(a_code:INTEGER)
			-- Initialization of `Current' using `a_code' as `keycode'
		do
			default_create
			key_code := a_code
		end

feature -- Access

	key_code:INTEGER

	is_pressed:BOOLEAN
			-- <Precursor>

	on_pressed(a_key:GAME_KEY)
		deferred
		end

	on_released(a_key:GAME_KEY)
		deferred
		end

end
