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
		redefine
			manifest
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
			Result := Precursor {KEYBOARD_STATUS} + manifest_keyboard_virtual + key_code.out.as_string_32
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
