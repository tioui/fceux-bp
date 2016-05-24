note
	description: "Summary description for {AUDIO_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUDIO_MANAGER

inherit
	GAME_LIBRARY_SHARED
	GAME_SDL_ANY

create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION; a_emulator:FCEUX_EMULATOR)
			-- Initialization of `Current' using `a_emulator' as `emulator'
			-- and `a_configuration' as `configuration'
		do
			configuration := a_configuration
			emulator := a_emulator
			is_prepare := False
			create buffer
		end

feature -- Acess

	close
		do
			Sdl_pause_audio(device_id, 1)
			Sdl_close_audio_device(device_id)
			{GAME_SDL_EXTERNAL}.sdl_quitsubsystem ({GAME_SDL_EXTERNAL}.sdl_init_audio)
			buffer_data.memory_free
			is_prepare := False
		end

	prepare
			-- Set the `emulator' sound properties
		local
			l_desired_spec, l_obtained_spec:POINTER
			l_error:INTEGER
			l_converter:UTF_CONVERTER
			l_managed_pinter:MANAGED_POINTER
		do
			emulator.set_sound_volume (configuration.sound_volume)
			emulator.set_sound_quality (configuration.sound_quality)
			emulator.set_sound_rate (configuration.sound_rate)
			emulator.set_triangle_volume (configuration.sound_triangle_volume)
			emulator.set_square1_volume (configuration.sound_square1_volume)
			emulator.set_square2_volume (configuration.sound_square2_volume)
			emulator.set_noise_volume (configuration.sound_noise_volume)
			emulator.set_pcm_volume (configuration.sound_pcm_volume)
			clear_error
			l_error := {GAME_SDL_EXTERNAL}.sdl_initsubsystem ({GAME_SDL_EXTERNAL}.sdl_init_audio)
			if l_error < 0 then
				manage_error_code (l_error, "Cannot initialize library sub system.")
			else
				create l_converter
				print("Number of device: " + Sdl_get_number_audio_devices(False).out + "%N")
				across 0 |..| (Sdl_get_number_audio_devices(False) - 1) as la_index loop
					create l_managed_pinter.make_from_pointer (Sdl_get_audio_device_name(la_index.item, False), 255)
					print("Device: " + l_converter.utf_8_0_pointer_to_escaped_string_32 (l_managed_pinter) + "%N")
				end

				l_obtained_spec := l_desired_spec.memory_calloc (1, sdl_audio_spec_sizeof)
				l_desired_spec := create_spec
				set_audio_callback(l_desired_spec)
				device_id := Sdl_open_audio_device(create {POINTER}, False, l_desired_spec, l_obtained_spec, 0 )
				if device_id > 0 then
					buffer_data := buffer_data.memory_calloc (1000, 4)
					Sdl_pause_audio(device_id, 0)
					is_prepare := True
				else
					manage_error_code (device_id.to_integer_32 - 1, "Cannot Open Audio device.")
				end
				l_desired_spec.memory_free
				l_obtained_spec.memory_free
			end
		end

	is_prepare:BOOLEAN

	play_sound(a_input_buffer:POINTER; a_count: INTEGER_32)
			-- Play the sont pointed by `a_buffer' of len `a_count'
		require
			Prepare: is_prepare
		do
			buffer_data.memory_copy (a_input_buffer, a_count * 4)
			Sdl_lock_audio(device_id)
			buffer.set_data (buffer_data)
			buffer.set_tail (0)
			buffer.set_head (a_count)
			Sdl_unlock_audio(device_id)
		end

	buffer_data:POINTER

feature {NONE} -- Implementation

	create_spec:POINTER
		do
			Result := Result.memory_calloc (1, sdl_audio_spec_sizeof)
			sdl_audio_spec_set_freq (Result, configuration.sound_rate)
			sdl_audio_spec_set_format (Result, sdl_signed_16_bits_format)
			sdl_audio_spec_set_channels (Result, channels)
			sdl_audio_spec_set_samples (Result, samples)
			sdl_audio_spec_set_userdata(Result, buffer.item)
		end

	device_id:NATURAL_32

	buffer:AUDIO_BUFFER

	emulator:FCEUX_EMULATOR
			-- The Fceux emulator wrapper

	configuration:CONFIGURATION
			-- The application coufiguration container

feature -- Constants

	Samples:NATURAL_16 = 512

	Channels:NATURAL_8 = 1

feature {NONE} -- Externals

	set_audio_callback(a_spec:POINTER)
		external
			"C inline use <bpaudio.h>"
		alias
			"((SDL_AudioSpec*)$a_spec)->callback=audioCallback"
		end

	Sdl_signed_16_bits_format:INTEGER
		external
			"C inline use <SDL.h>"
		alias
			"AUDIO_S16SYS"
		end

	Sdl_allow_any_format_change:INTEGER
		external
			"C inline use <SDL.h>"
		alias
			"SDL_AUDIO_ALLOW_ANY_CHANGE"
		end

	Sdl_lock_audio(a_device:NATURAL_32)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_LockAudioDevice((SDL_AudioDeviceID)$a_device)"
		end

	Sdl_unlock_audio(a_device:NATURAL_32)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_UnlockAudioDevice((SDL_AudioDeviceID)$a_device)"
		end

	Sdl_get_number_audio_devices(a_is_capture:BOOLEAN):INTEGER
		external
			"C inline use <SDL.h>"
		alias
			"SDL_GetNumAudioDevices((int)$a_is_capture)"
		end

	Sdl_get_audio_device_name(a_index:INTEGER; a_is_capture:BOOLEAN):POINTER
		external
			"C inline use <SDL.h>"
		alias
			"SDL_GetAudioDeviceName((int)$a_index, (int)$a_is_capture)"
		end

	Sdl_pause_audio(a_device:NATURAL_32; a_is_pause:INTEGER)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_PauseAudioDevice((SDL_AudioDeviceID)$a_device, (int)$a_is_pause)"
		end

	Sdl_open_audio_device(a_device_name:POINTER; a_is_capture:BOOLEAN; a_desired, a_obtained:POINTER; a_allow_changes:INTEGER):NATURAL_32
		external
			"C inline use <SDL.h>"
		alias
			"SDL_OpenAudioDevice((char *)$a_device_name, (int)$a_is_capture, (SDL_AudioSpec*) $a_desired, (SDL_AudioSpec*) $a_obtained, (int)$a_allow_changes)"
		end

	Sdl_close_audio_device(a_device:NATURAL_32)
		external
			"C inline use <SDL.h>"
		alias
			"SDL_CloseAudioDevice((SDL_AudioDeviceID)$a_device)"
		end

	sdl_audio_spec_sizeof:INTEGER
		external
			"C inline use <SDL.h>"
		alias
			"sizeof(SDL_AudioSpec)"
		end

	sdl_audio_spec_set_freq(a_spec:POINTER; a_value:INTEGER)
		external
			"C inline use <SDL.h>"
		alias
			"((SDL_AudioSpec *)$a_spec)->freq = (int)$a_value"
		end

	sdl_audio_spec_set_format(a_spec:POINTER; a_value:INTEGER)
		external
			"C inline use <SDL.h>"
		alias
			"((SDL_AudioSpec *)$a_spec)->format = (int)$a_value"
		end

	sdl_audio_spec_set_channels(a_spec:POINTER; a_value:NATURAL_8)
		external
			"C inline use <SDL.h>"
		alias
			"((SDL_AudioSpec *)$a_spec)->channels = (Uint8)$a_value"
		end

	sdl_audio_spec_set_samples(a_spec:POINTER; a_value:NATURAL_16)
		external
			"C inline use <SDL.h>"
		alias
			"((SDL_AudioSpec *)$a_spec)->samples = (Uint16)$a_value"
		end

	sdl_audio_spec_set_userdata(a_spec:POINTER; a_value:POINTER)
		external
			"C inline use <SDL.h>"
		alias
			"((SDL_AudioSpec *)$a_spec)->userdata = $a_value"
		end

end
