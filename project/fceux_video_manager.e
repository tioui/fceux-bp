note
	description: "An interface to the {VIDEO_MANAGER}."
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

deferred class
	FCEUX_VIDEO_MANAGER

feature -- Access

	set_palette(a_index, a_red, a_green, a_blue:NATURAL_8)
			-- Change the color at `a_index' in the system color palette to (`a_red', `a_green', `a_blue')
		deferred
		end

	get_palette(a_index:NATURAL_8):TUPLE[red, green, blue:NATURAL_8]
			-- Retreive the color (`a_red', `a_green', `a_blue') at `a_index' in the system color palette
		deferred
		end

	draw_next_frame(a_buffer:POINTER)
			-- Draw the video frame pointed by `a_buffer'
		deferred
		end

	video_has_changed
			-- A change has occured in the internal video system
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
