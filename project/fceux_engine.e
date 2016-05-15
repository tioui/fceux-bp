note
	description: "The emulation engine"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

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
			-- Initialization of `Current'
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
				emulator.prepare
			end
		end

feature -- Access

	has_error:BOOLEAN
			-- An error occured

	error_text:READABLE_STRING_GENERAL
			-- A text error to show

	base_directory:READABLE_STRING_GENERAL
			-- Th directory to used in `Current'

	configuration:CONFIGURATION
			-- Every configurations of the system

	emulator:FCEUX_EMULATOR
			-- The emulator backend

	driver:FCEUX_DRIVER
			-- The emulator frontend driver

	input_manager:INPUT_MANAGER
			-- Manage every input of the emulator

	video_manager:VIDEO_MANAGER
			-- Manage video frame and video system of `Current'

	audio_manager:AUDIO_MANAGER
			-- Manage audio frame and audio system of `Current'

	run
			-- Execute the emulator
		require
			not has_error
		local
			l_index:INTEGER
		do
			emulator.load_game ("/home/louis/Documents/Super Mario Bros 3 (U) (PRG 0).nes")
--			emulator.load_game ("/home/louis/Documents/Super Mario Bros (E).nes")
			audio_manager.prepare
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
			old_timestamp := game_library.time_since_create
			game_library.set_iteration_per_second (emulator.desired_fps.bit_shift_right (24))
			game_library.launch
		end

feature {NONE} -- Implementation

	on_key_pressed(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- When a keyboard key has been pressed
		do
			if not a_key_state.is_repeat then
				input_manager.on_key_pressed(a_key_state)
			end
		end

	on_key_released(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- When a keyboard key has been released
		do
			if not a_key_state.is_repeat then
				input_manager.on_key_released(a_key_state)
			end
		end

	on_iteration(a_timestamp:NATURAL)
			-- at each game iteration
		do
			print("FPS: " + (1000/(a_timestamp - old_timestamp)).out + "%N")
			old_timestamp := a_timestamp
			emulator.emulate
			if not emulator.pixel_buffer.is_default_pointer then
				video_manager.draw_next_frame (emulator.pixel_buffer)
			else
				print("Skipping frame!%N")
			end
			if attached emulator.input_buffer as la_buffer then
				input_manager.update(la_buffer)
			end
			audio_manager.play_sound (emulator.sound_buffer, emulator.sound_buffer_size)
		end

	old_timestamp:NATURAL_32
			-- Temporary: Used to show FPS

	on_quit(a_timestamp:NATURAL)
			-- When the user close the application
		do
			game_library.stop
		end

	initialize_base_directory
			-- Initialise `base_directory'
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
