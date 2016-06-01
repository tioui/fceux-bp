note
	description: "Managed audio the processing"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	AUDIO_MANAGER


create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION; a_emulator:FCEUX_EMULATOR)
			-- Initialization of `Current' using `a_emulator' as `emulator'
			-- and `a_configuration' as `configuration'
		local
			l_buffer_size:INTEGER
		do
			configuration := a_configuration
			emulator := a_emulator
			create source.make (0)
			create managed_buffer.make (1)
		end

feature -- Access

	is_prepared:BOOLEAN
			-- Has `prepare' been sucessully called

	prepare(a_fps_delta:REAL_64)
			-- Set the `emulator' sound properties
		require
			Not_Prepared: not is_prepared
		do
			emulator.set_sound_volume (configuration.sound_volume)
			emulator.set_sound_quality (configuration.sound_quality)
			emulator.set_sound_rate (configuration.sound_rate)
			emulator.set_triangle_volume (configuration.sound_triangle_volume)
			emulator.set_square1_volume (configuration.sound_square1_volume)
			emulator.set_square2_volume (configuration.sound_square2_volume)
			emulator.set_noise_volume (configuration.sound_noise_volume)
			emulator.set_pcm_volume (configuration.sound_pcm_volume)
			create managed_buffer.make (
							(((configuration.sound_rate / 1000) * a_fps_delta) * 2.2).ceiling
						)
			is_prepared := True
		ensure
			Prepared: is_prepared
		end


	play_samples(a_buffer:POINTER; a_count: INTEGER_32)
			-- Play the sont pointed by `a_buffer' of len `a_count'
		require
			Prepared: is_prepared
		do
			source.clear_processed_buffers
			if not source.is_playing or source.is_stop then
				source.play
			end
			if source.buffer_tail /= (source.buffer_head + 1) \\ source.Nb_buffer then
				if not a_buffer.is_default_pointer and a_count > 0 then
					adapt_buffer(a_buffer, a_count)
					source.queue_buffer (managed_buffer.item, a_count * 2, 1, 16, 44100)
				end
			end
			if not source.is_playing or source.is_stop then
				source.play
			end
		end

feature {NONE} -- Implementation

	adapt_buffer(a_buffer:POINTER; a_count:INTEGER_32)
			-- Transform the `a_count' Signed 32 bits samples in `a_buffer'
			-- to Signed 16 bits samples in `managed_buffer'
		local
			l_position:INTEGER
			l_sample:INTEGER_16
			l_managed_source_buffer:MANAGED_POINTER
		do
			create l_managed_source_buffer.share_from_pointer (a_buffer, a_count * 4)
			across 1 |..| a_count as la_index loop
				l_position := (la_index.item - 1) * 2
				l_sample := l_managed_source_buffer.read_integer_16 (l_position * 2)
				managed_buffer.put_integer_16 (l_sample, l_position)
			end
		end

	source:AUDIO_STREAMING_SOURCE
			-- The source of the audio

	emulator:FCEUX_EMULATOR
			-- The Fceux emulator wrapper

	configuration:CONFIGURATION
			-- The application coufiguration container

	managed_buffer:MANAGED_POINTER
			-- After the call to `adapt_buffer', contain
			-- the Signed 16 bits samples to use in the `source'

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
