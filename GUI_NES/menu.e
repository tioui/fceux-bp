note
	description: ""
	author: ""
	date: "Summer 2016"
	revision: ""

deferred class
	MENU

inherit
	UI_CONSTANTS
	TEXT_LIBRARY_SHARED
	GAME_LIBRARY_SHARED
	IMG_LIBRARY_SHARED

feature -- Implementation

	x: INTEGER_32 assign set_x
			-- Horizontal position of `Current'.

	y: INTEGER_32 assign set_y
			-- Vertical position of `Current'.

	set_x (a_x: INTEGER_32)
			-- Assign `a_x' to `x'.
		do
			x := a_x
		ensure
			is_assign: x = a_x
		end

	set_y (a_y: INTEGER_32)
			-- Assign `a_y' to `y'.
		do
			y := a_y
		ensure
			is_assign: y = a_y
		end

 	font: TEXT_FONT
 			-- To write text on surfaces that will be shown to the user

	is_done: BOOLEAN
			-- True when player presses start or return

	has_error: BOOLEAN
			-- True if an error occured

	on_iteration(a_game_window:GAME_WINDOW_RENDERED)
			-- Things to do each frame
		deferred

		end

	on_key_pressed(a_timestamp: NATURAL_32; a_key_state:GAME_KEY_STATE; a_window:GAME_WINDOW_RENDERED)
			-- When user presses a key
		deferred

		end

invariant

note
	license: ""
	source: ""

end
