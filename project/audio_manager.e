note
	description: "Summary description for {AUDIO_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUDIO_MANAGER

inherit
	AUDIO_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION; a_emulator:FCEUX_EMULATOR)
		do
			configuration := a_configuration
			emulator := a_emulator
			audio_library.sources_add
			source := audio_library.last_source_added
			create sound.make(configuration.sound_rate)
		end

feature -- Access

	initialize
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

	add_sound(a_buffer:POINTER; a_count: INTEGER_32)
		do
			print("Count: " + a_count.out)
			sound.add_sample (a_buffer, a_count)
			if source.sound_queued.count = 0 then
				source.queue_sound (sound)
			end
			if not source.is_playing then
				source.play
			end
			audio_library.update
		end

feature {NONE} -- Implementation

	sound: STREAM_SOUND

	source:AUDIO_SOURCE

	emulator:FCEUX_EMULATOR

	configuration:CONFIGURATION
end
