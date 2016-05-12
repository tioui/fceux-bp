note
	description: "Summary description for {FCEUX_ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FCEUX_ENGINE

inherit
	GAME_LIBRARY_SHARED
		redefine
			default_create
		end
	AUDIO_LIBRARY_SHARED
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			has_error := False
			error_text := ""
			initialize_base_directory
			create configuration
			create input_manager.make(configuration)
			create emulator.make (configuration)
			create video_manager.make (configuration, emulator)
			create driver.make(configuration, emulator, video_manager)
			create audio_manager.make(configuration, emulator)
			if emulator.has_error then
				has_error := True
			else
				emulator.initialize
			end
		end

feature -- Access

	has_error:BOOLEAN

	error_text:READABLE_STRING_GENERAL

	base_directory:READABLE_STRING_GENERAL

	configuration:CONFIGURATION

	emulator:FCEUX_EMULATOR

	driver:FCEUX_DRIVER

	input_manager:INPUT_MANAGER

	video_manager:VIDEO_MANAGER

	audio_manager:AUDIO_MANAGER

	run
		require
			not has_error
		local
			l_index:INTEGER
		do
			emulator.load_game ("/home/louis/Documents/Super Mario Bros 3 (U) (PRG 0).nes")
--			emulator.load_game ("/home/louis/Documents/Super Mario Bros (E).nes")
			audio_manager.initialize
			l_index := 1
			across configuration.buttons as la_buttons loop
				emulator.set_input_gamepad (l_index)
				l_index := l_index + 1
			end
			emulator.set_input_gamepad (configuration.buttons.count)
			game_library.quit_signal_actions.extend (agent on_quit)
			game_library.iteration_actions.extend (agent on_iteration)
			video_manager.window.key_pressed_actions.extend (agent on_key_pressed)
			video_manager.window.key_released_actions.extend (agent on_key_released)
			game_library.launch
		end

feature {NONE} -- Implementation

	on_key_pressed(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
		do
			if not a_key_state.is_repeat then
				input_manager.on_key_pressed(a_key_state)
			end
		end

	on_key_released(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
		do
			if not a_key_state.is_repeat then
				input_manager.on_key_released(a_key_state)
			end
		end

	on_iteration(a_timestamp:NATURAL)
		do
			emulator.emulate
			if not emulator.pixel_buffer.is_default_pointer then
				video_manager.draw_next_frame (emulator.pixel_buffer)
			else
				print("Skipping frame!%N")
			end
			if attached emulator.input_buffer as la_buffer then
				input_manager.update(la_buffer)
			end
			audio_manager.add_sound (emulator.sound_buffer, emulator.sound_buffer_size)
		end

	on_quit(a_timestamp:NATURAL)
		do
			game_library.stop
		end

	initialize_base_directory
		local
			l_operating_environment: OPERATING_ENVIRONMENT
			l_execution_environment: EXECUTION_ENVIRONMENT
			l_directory:DIRECTORY

		do
			create l_operating_environment
			create l_execution_environment
			if attached l_execution_environment.home_directory_path as la_path then
				base_directory := la_path.name + l_operating_environment.directory_separator.out + ".fceux-bp"
				create l_directory.make_with_name (base_directory)
				if not l_directory.exists or else not l_directory.is_readable then
					base_directory := ""
				end
			else
				base_directory := ""
			end
		end

	initialize_config
		do

		end

end
