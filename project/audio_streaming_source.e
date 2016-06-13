note
	description: "An {AUDIO_SOURCE} that can manage real time streaming"
	author: "Louis Marchand"
	date: "Sun, 05 Jun 2016 05:26:07 +0000"
	revision: "0.1"

class
	AUDIO_STREAMING_SOURCE

inherit
	AUDIO_SOURCE
		rename
			update_playing as clear_processed_buffers,
			is_stop as is_source_stop,
			is_al_stop as is_stop
		export
			{AUDIO_MANAGER} queue_buffer, buffer_tail, buffer_head, nb_buffer, is_stop
			{NONE}
				queue_sound, queue_sound_loop, queue_sound_infinite_loop, sound_queued
		redefine
			clear_processed_buffers, nb_buffer
		end

create
	make

feature -- Access

	nb_buffer:INTEGER
			-- The number of internal buffer in `Current'
		once ("PROCESS")
			Result:=10
		end

	clear_processed_buffers
			-- Clear the internal buffers
		do
			from
			until processed_buffers_number < 1
			loop
				unqueue_buffer
			end
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
