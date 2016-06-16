note
	description: "A {BUTTON_STATUS} that used a joystick to update"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

deferred class
	JOYSTICK_STATUS

inherit
	BUTTON_STATUS
	GAME_LIBRARY_SHARED

feature {NONE} -- Initialization

	make_with_index(a_joystick_index:INTEGER)
			-- Initialization of `Current' using `a_joystick_index' to initialize `joystick'
		do
			across game_library.joysticks as la_joysticks loop
				if la_joysticks.item.index = a_joystick_index then
					internal_joystick := la_joysticks.item
					if not la_joysticks.item.is_open then
						la_joysticks.item.open
					end
				end
			end
		end

feature -- Access

	has_error:BOOLEAN
			-- Set if an error occured when creating `Current'
		do
			Result := not attached internal_joystick
		end

	joystick:GAME_JOYSTICK
			-- The {GAME_JOYSTICK} to poll for status
		require
			No_Error: not has_error
		do
			check attached internal_joystick as la_joystick then
				Result := la_joystick
			end
		end


	manifest:READABLE_STRING_GENERAL
			-- <Precursor>
		require else
			No_Error: not has_error
		do
			if has_error then
				Result := Manifest_joystick + "0"
			else
				Result := Manifest_joystick + joystick.index.out
			end
		end

feature {NONE} -- Implementation

	internal_joystick: detachable GAME_JOYSTICK
			-- The internal representation of `joystick'

invariant
	Error_Valid: not has_error implies attached internal_joystick

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
