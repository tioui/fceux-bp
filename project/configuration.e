note
	description: "Keep every configuration o the system"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	CONFIGURATION

inherit
	GAME_LIBRARY_SHARED
		redefine
			default_create
		end

create
	default_create,
	make_with_base_directory

feature {NONE} -- Initialization

	default_create
			-- Initialization of `Current'
		do
			initialize_base_directory
			default_initialization
		end

	make_with_base_directory(a_directory:READABLE_STRING_GENERAL)
			-- Initialization of `Current' using `a_directory' as `base_directory'
		do
			base_directory := a_directory
			default_initialization
		end

	default_initialization
			-- Initialize every configurations in `Current'
		do
			create button_factory
			window_width := 256
			window_height := 240
			full_screen := False
			full_screen_width := 0
			full_screen_height := 0
			full_screen_display_index := 0
			first_scan_line := 0
			last_scan_line := 239
			show_console_message := true
			autodetect_video_mode := True
			video_skip := True
			audio_skip := True
			must_stretch := False
			initialize_buttons
			sound_rate := 44100
			sound_volume := 150
			sound_quality := 1
			sound_triangle_volume := 256
			sound_square1_volume := 256
			sound_square2_volume := 256
			sound_noise_volume := 256
			sound_pcm_volume := 256
		end

	initialize_buttons
			-- Initialize every `buttons' configuration
		local
			l_controller:ARRAYED_LIST[LIST[BUTTON_STATUS]]
		do
			create {ARRAYED_LIST[LIST[LIST[BUTTON_STATUS]]]} buttons.make (2)
			create l_controller.make (8)
			adding_button(l_controller, "keyboard_name_Right;Joystick_0_Button_12")
			adding_button(l_controller, "keyboard_name_Left;Joystick_0_Button_11")
			adding_button(l_controller, "keyboard_name_Down;Joystick_0_Button_14")
			adding_button(l_controller, "keyboard_name_Up;Joystick_0_Button_13")
			adding_button(l_controller, "keyboard_name_a;Joystick_0_Button_7")
			adding_button(l_controller, "keyboard_name_s;Joystick_0_Button_6")
			adding_button(l_controller, "keyboard_name_d;Joystick_0_Button_0")
			adding_button(l_controller, "keyboard_name_f;Joystick_0_Button_1")
			buttons.extend(l_controller)
			create l_controller.make (8)
			adding_button(l_controller, "keyboard_name_l;Joystick_1_Button_12")
			adding_button(l_controller, "keyboard_name_j;Joystick_1_Button_11")
			adding_button(l_controller, "keyboard_name_k;Joystick_1_Button_14")
			adding_button(l_controller, "keyboard_name_i;Joystick_1_Button_13")
			adding_button(l_controller, "keyboard_name_q;Joystick_1_Button_7")
			adding_button(l_controller, "keyboard_name_w;Joystick_1_Button_6")
			adding_button(l_controller, "keyboard_name_e;Joystick_1_Button_1")
			adding_button(l_controller, "keyboard_name_r;Joystick_1_Button_0")
			buttons.extend(l_controller)
		end

	adding_button(
						a_controller:LIST[LIST[BUTTON_STATUS]];
						a_manifest:READABLE_STRING_GENERAL
					)
			-- Add a {BUTTON_STATUS} to `a_controller' from `a_manifest' text
		local
			a_buttons:ARRAYED_LIST[BUTTON_STATUS]
			a_manifests:LIST [READABLE_STRING_GENERAL]
		do
			a_manifests := a_manifest.split ({CHARACTER_32}';')
			create a_buttons.make(a_manifests.count)
			across a_manifests as la_manifest loop
				if attached button_factory.translate_manifest (la_manifest.item) as la_status then
					a_buttons.extend (la_status)
				end
			end
			a_controller.extend (a_buttons)
		end

feature -- Access

	base_directory:READABLE_STRING_GENERAL
			-- Th directory to used in `Current'

	window_width, window_height:NATURAL
			-- The dimension of the {GAME_WINDOW}

	full_screen:BOOLEAN
			-- The {GAME_WINDOW} will fill the screen

	full_screen_width, full_screen_height:NATURAL
			-- The dimension of the `full_screen' {GAME_WINDOW}

	full_screen_display_index:INTEGER
			-- The index of the display that must receive the `full_screen' {GAME_WINDOW}

	show_console_message:BOOLEAN
			-- Debug message is print to the console

	autodetect_video_mode:BOOLEAN
			-- If a PAL game is load, change automaticaly the video mode

	video_skip:BOOLEAN
			-- Skip video frame if it is necessary

	audio_skip:BOOLEAN
			-- Skip audio frame if it is necessary

	first_scan_line:INTEGER
			-- The first video line to scan

	last_scan_line:INTEGER
			-- The last video line to sca

	must_stretch:BOOLEAN
			-- The Program must stretch the image when the window ratio
			-- is not the same as the video image ratio

	buttons:LIST[LIST[LIST[BUTTON_STATUS]]]
			-- Every buttons for every controller
			-- The outer list represent every controllers
			-- The second list represent every button
			-- the inner list represent possibly multiple
			-- {BUTTON_STATUS} for the same button

	sound_rate:INTEGER
			-- The frequency of the sound samples

	sound_buffer_size:INTEGER
			-- The number of millisecond of sound sample to put in the sound buffer

	sound_volume:NATURAL_32
			-- The master sound volume

	sound_quality:INTEGER
			-- he quality of the generated sound

	sound_triangle_volume:NATURAL_32
			-- The volume of the triangle sound channel

	sound_square1_volume:NATURAL_32
			-- The volume of the first square sound channel

	sound_square2_volume:NATURAL_32
			-- The volume of the second square sound channel

	sound_noise_volume:NATURAL_32
			-- The volume of the noise sound channel

	sound_pcm_volume:NATURAL_32
			-- The volume of the PCM sound channel

feature{NONE} -- Implementation

	button_factory:BUTTON_STATUS_FACTORY
			-- The factory used to generate {BUTTON_STATUS}

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


invariant
	Skip_Valid: audio_skip implies video_skip

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
