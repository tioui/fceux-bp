note
	description: "The emulation engine"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	EMULATION_ENGINE

inherit
	ENGINE
		redefine
			make, run
		end
	AUDIO_LIBRARY_SHARED
		export
			{NONE} all
		end
	ERROR_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION; a_window:GAME_WINDOW_RENDERED)
			-- <Precursor>
		do
			Precursor {ENGINE}(a_configuration, a_window)
			error_index := No_error
			is_game_open := False
			create input_manager.make(configuration)
			create emulator.make (configuration)
			create video_manager.make (window, configuration, emulator)
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

	open_game(a_game_file:READABLE_STRING_GENERAL; a_ntsc, a_pal:BOOLEAN)
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
			is_game_open := False
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
				desired_fps_delta := 1000 / emulator.desired_fps
				audio_manager.prepare(desired_fps_delta)
				is_game_open := True
			end
		ensure
			Open_Or_Error: not is_game_open implies has_error
		end

	is_game_open:BOOLEAN
			-- A game has been properly open

	close
			-- Be sure that everything is freed
		do
			driver.close
		end

	initialize_events
			-- <Precursor>
		do
			quit_asked := False
			game_library.quit_signal_actions.extend (agent on_quit)
			video_manager.window.key_pressed_actions.extend (agent on_key_pressed)
			video_manager.window.key_released_actions.extend (agent on_key_released)
		end

	run
			-- <Precursor>
		require else
			Game_Open: is_game_open
		local
			l_timestamp:NATURAL_32
			l_emulate_action:PROCEDURE[TUPLE]
--			l_fps:REAL_64
		do
			if is_game_open then
				initialize_events
				desired_fps_delta :=  1000 / emulator.desired_fps
	--			number_frame := 0
				from
					next_frame := game_library.time_since_create
				until
					must_stop
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
				Game_library.clear_all_events
			else
				error_index := General_error
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

	must_stop:BOOLEAN
			-- The main loop must be stoped
		do
			Result := quit_asked
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
