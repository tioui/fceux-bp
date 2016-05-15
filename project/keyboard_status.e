note
	description: "A {BUTTON_STATUS} that is managed by a keyboard button"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

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
			-- The internal code of `Current'

	is_pressed:BOOLEAN
			-- <Precursor>

	on_pressed(a_key:GAME_KEY)
			-- When `a_key' has been pressed
		deferred
		end

	on_released(a_key:GAME_KEY)
			-- When `a_key' has been released
		deferred
		end

end
