note
	description: "The emulation engine"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	EMULATION_ENGINE

inherit
	GAME_LIBRARY_SHARED
		redefine
			default_create
		end
	AUDIO_LIBRARY_SHARED
		redefine
			default_create
		end
	ERROR_CONSTANTS
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Initialization of `Current'
		do
			error_index := No_error
			initialize_base_directory
			create configuration
			create input_manager.make(configuration)
			create emulator.make (configuration)
			create video_manager.make (configuration, emulator)
			error_index := video_manager.error_index
			create driver.make(configuration, emulator, video_manager)
			create audio_manager.make(configuration, emulator)
			if emulator.has_error then
				error_index := General_error
			else
				emulator.prepare
			end
		end

feature -- Access

	has_error:BOOLEAN
			-- An error occured
		do
			Result := error_index /= No_error
		end

	error_index:INTEGER
			-- A error index to indicate the error type (0 for No Error)

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

	run_game(a_game_file:READABLE_STRING_GENERAL; a_ntsc, a_pal:BOOLEAN)
			-- Execute the emulator on the game from the file `a_game_file'
			-- Using `a_ntsc' or `a_pal' video mode. If `a_ntsc' and
			-- `a_pal' are not set, the emulator will try to autodetect the
			-- video mode
		require
			No_Error: not has_error
			NTSC_or_PAL: not (a_ntsc and a_pal)
		local
			l_index:INTEGER
		do
			emulator.load_game (a_game_file, not a_ntsc and not a_pal)
			if emulator.has_error then
				error_index := game_file_not_valid
			else
				l_index := 1
				across configuration.buttons as la_buttons loop
					emulator.set_input_gamepad (l_index)
					l_index := l_index + 1
				end
				emulator.set_input_gamepad (configuration.buttons.count)
				game_library.quit_signal_actions.extend (agent on_quit)
				video_manager.window.key_pressed_actions.extend (agent on_key_pressed)
				video_manager.window.key_released_actions.extend (agent on_key_released)
				desired_fps_delta :=  1000 / emulator.desired_fps
				audio_manager.prepare(desired_fps_delta)
				resume
			end
		end

	close
		do
			driver.close
		end

	resume
		local
			l_timestamp:NATURAL_32
			l_emulate_action:PROCEDURE[TUPLE]
--			l_fps:REAL_64
		do
--			number_frame := 0
			from
				must_quit := False
				next_frame := game_library.time_since_create
			until
				must_quit
			loop
				if game_library.time_since_create > (next_frame + (desired_fps_delta * 2)) then
					l_emulate_action := agent emulator.emulate_skip_audio_video
					print("Skipping audio and video frame%N")
				elseif game_library.time_since_create > (next_frame + desired_fps_delta) then
					l_emulate_action := agent emulator.emulate_skip_video
					print("Skipping video frame%N")
				else
					l_emulate_action := agent emulator.emulate
				end
				from
					l_timestamp := game_library.time_since_create
				until
					l_timestamp > (next_frame + desired_fps_delta)
				loop
					l_timestamp := game_library.time_since_create
				end
--				print("Next Frame: " + next_frame.out + "%N")
--				l_fps := (1000 / (l_timestamp - fps_counter))
--				print("FPS: " + l_fps.out + "%N")
--				fps_counter := l_timestamp
				next_frame := next_frame + desired_fps_delta
				emulate_next_frame(l_emulate_action)
				l_timestamp := game_library.time_since_create
				if l_timestamp < (next_frame + (desired_fps_delta / 2)).floor.to_natural_32 then
					game_library.delay (((next_frame + (desired_fps_delta / 2)).floor.to_natural_32) - l_timestamp)
				end
			end
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

	emulate_next_frame(a_emulate_action:PROCEDURE[TUPLE])
			-- Use the `a_emulator_action' to emulate the next audio and video frame.
		do
			game_library.update_events
			if attached emulator.input_buffer as la_buffer then
				input_manager.update(la_buffer)
			end
			a_emulate_action.call
			audio_manager.play_samples (emulator.sound_buffer, emulator.sound_buffer_size)
			if not emulator.pixel_buffer.is_default_pointer then
				video_manager.draw_next_frame (emulator.pixel_buffer)
			end
--			number_frame := number_frame + 1
--			print("Frame #" + number_frame.out + "%N")
		end

--	number_frame:INTEGER
			-- The number of total frame used since the creation of `Current'
			-- To debug only.

--	fps_counter:NATURAL_32
			-- Used to show FPS
			-- To debug only


	next_frame:REAL_64
			-- The Timestamp to play the next frame

	desired_fps_delta:REAL_64
			-- The number of milliseconds between two frames

	must_quit:BOOLEAN
			-- The game must stop

	on_quit(a_timestamp:NATURAL)
			-- When the user close the application
		do
			must_quit := True
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