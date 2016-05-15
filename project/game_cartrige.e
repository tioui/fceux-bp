note
	description: "Representation of a NES game cartrige"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	GAME_CARTRIGE

create
	make

feature {NONE} -- Initialization

	make(a_pointer:POINTER)
			-- Initialization of `Current' using `a_pointer' as internal `item'
		do
			item := a_pointer
		end

feature -- Access

	exists:BOOLEAN
			-- `Current' is valid
		do
			Result := not item.is_default_pointer
		end

feature {FCEUX_EMULATOR} -- Implementation

	item:POINTER
	
invariant

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
