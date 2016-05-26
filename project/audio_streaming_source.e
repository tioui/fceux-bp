note
	description: "Summary description for {AUDIO_STREAMING_SOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
end
