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

	name:READABLE_STRING_GENERAL
		require
			Exists: exists
		local
			l_converter:UTF_CONVERTER
			l_c_string:C_STRING
		do
			create l_converter
			create l_c_string.make_shared_from_pointer (fceugi_name (item))
			Result := l_converter.utf_8_string_8_to_escaped_string_32(l_c_string.string)
		end

	mapper_number:INTEGER
		require
			Exists: exists
		do
			Result := fceugi_mapper_number(item)
		end


feature {FCEUX_EMULATOR} -- Implementation

	item:POINTER

feature {NONE} -- Externals

	fceugi_name(a_item:POINTER):POINTER
		external
			"C++ inline use <driver.h>"
		alias
			"((FCEUGI *)$a_item)->name"
		end

	fceugi_mapper_number(a_item:POINTER):INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"((FCEUGI *)$a_item)->mappernum"
		end

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
