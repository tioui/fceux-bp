note
	description: "Managed audio the processing"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	AUDIO_MANAGER_OLD

inherit
	AUDIO_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION; a_emulator:FCEUX_EMULATOR)
			-- Initialization of `Current' using `a_emulator' as `emulator'
			-- and `a_configuration' as `configuration'
		do
			configuration := a_configuration
			emulator := a_emulator
			audio_library.sources_add
			source := audio_library.last_source_added
			create sound.make(configuration.sound_rate)
		end

feature -- Access

	prepare
			-- Set the `emulator' sound properties
		do
			emulator.set_sound_volume (configuration.sound_volume)
			emulator.set_sound_quality (configuration.sound_quality)
			emulator.set_sound_rate (configuration.sound_rate)
			emulator.set_triangle_volume (configuration.sound_triangle_volume)
			emulator.set_square1_volume (configuration.sound_square1_volume)
			emulator.set_square2_volume (configuration.sound_square2_volume)
			emulator.set_noise_volume (configuration.sound_noise_volume)
			emulator.set_pcm_volume (configuration.sound_pcm_volume)
		end

	play_sound(a_buffer:POINTER; a_count: INTEGER_32)
			-- Play the sont pointed by `a_buffer' of len `a_count'
		do
			sound.set_sample (a_buffer, a_count)
			if source.sound_queued.count = 0 then
				source.queue_sound_infinite_loop (sound)
			end
			if not source.is_playing then
				source.play
			end
			audio_library.update
		end

feature {NONE} -- Implementation

	sound: STREAM_SOUND
			-- The sound streamer

	source:AUDIO_SOURCE
			-- The source of the audio

	emulator:FCEUX_EMULATOR
			-- The Fceux emulator wrapper

	configuration:CONFIGURATION
			-- The application coufiguration container

feature {NONE} -- C External



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
