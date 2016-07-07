note
	description: "A {UI_LIST} that can browse file system"
	author: "Louis Marchand"
	date: "Thu, 07 Jul 2016 15:14:52 +0000"
	revision: "0.1"

class
	FILE_LIST

inherit
	UI_LIST
		rename
			make as make_list
		redefine
			valid_selection
		end

create
	make

feature {NONE} -- Initialization

	make(a_x, a_y, a_count: INTEGER; a_label, a_starting_directory: READABLE_STRING_GENERAL; a_font: TEXT_FONT; a_renderer: GAME_RENDERER)
			-- Initialization of `Current' at position `a_x', `a_y' (to be assigned to `x' and `y'
			-- `a_label' is the text to be shown above the list. Assigned to `label'
			-- `a_count' is the number of item of `choices' to show. Assigned to `item_count'
			-- `a_font' is the font to print the text. Assigned to `font'
			-- `a_renderer' to draw things. Assigned to `renderer'
		do
			create current_path.make_from_string (a_starting_directory)
			current_path := current_path.canonical_path
			make_list (a_x, a_y, a_count, a_label, dir_content(a_starting_directory), a_font, a_renderer)
		end

feature -- Access

	current_directory:READABLE_STRING_GENERAL
			-- The directory that `Current' is listing
		do
			Result := current_path.name
		end

	selected_file:READABLE_STRING_GENERAL
			-- The full path name of the file presently selected by `Current'
		do
			Result := selected_path.name
		end

feature {NONE} -- Implementation

	current_path:PATH
			-- The directory {PATH} that `Current' is listing

	selected_path:PATH
			-- The full {PATH} of the file presently selected by `Current'
		do
			Result := current_path.extended (choices[selected_index]).canonical_path
		end

	valid_selection
			-- <Precursor>
		local
			l_file:RAW_FILE
			l_new_path:PATH
		do
			l_new_path := selected_path
			create l_file.make_with_path (l_new_path)
			if l_file.exists and then l_file.is_readable then
				if l_file.is_directory then
					current_path := selected_path
					set_choices (dir_content (l_new_path.name))
				else
					is_done := True
				end
			else
				-- Print Error
			end
		end

	dir_content(a_path: READABLE_STRING_GENERAL): LIST[READABLE_STRING_GENERAL]
            -- Returns file and directory names for the directory `a_path'.
        local
        	l_dir: DIRECTORY
        	l_result:LINKED_LIST[READABLE_STRING_GENERAL]
        	l_sorted_list:SORTED_TWO_WAY_LIST[IMMUTABLE_STRING_32]
        do
        	create l_sorted_list.make
        	create {LINKED_LIST[READABLE_STRING_GENERAL]}Result.make
        	create l_dir.make (a_path)
            across
                l_dir.entries as ic
            loop
            	if ic.item.is_parent_symbol then
            		Result.extend (ic.item.name)
            	elseif not ic.item.is_current_symbol then
            		l_sorted_list.extend (ic.item.name)
            	end
            end
            Result.append (l_sorted_list)
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
