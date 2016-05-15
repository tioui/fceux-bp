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

note
	license: "[
		    Copyright (C) 2016 Louis Marchand

		    This program is free software: you can redistribute it and/or modify
		    it under the terms of the GNU General Public License as published by
		    the Free Software Foundation, either version 3 of the License, or
		    (at your option) any later version.

		    This program is distributed in the hope that it will be useful,
		    but WITHOUT ANY WARRANTY; without even the implied warranty of
		    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		    GNU General Public License for more details.

		    You should have received a copy of the GNU General Public License
		    along with this program.  If not, see <http://www.gnu.org/licenses/>.
		]"
end
