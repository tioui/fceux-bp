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
	default_initialization

feature {NONE} -- Initialization

	default_create
			-- Initialization of `Current'
		do
			default_initialization
		end

	make_with_base_directory(a_directory:READABLE_STRING_GENERAL)
			-- Initialization of `Current' using `a_directory' as `base_directory'
		do
--			base_directory := ""
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

	window_width:NATURAL assign set_window_width
			-- The horizontal dimension of the {GAME_WINDOW}

	set_window_width(a_window_width:NATURAL)
			-- Assign `a_window_width' to `window_width'
		do
			window_width := a_window_width
		ensure
			Is_Assign: window_width ~ a_window_width
		end

	window_height:NATURAL assign set_window_height
			-- The vertical dimension of the {GAME_WINDOW}

	set_window_height(a_window_height:NATURAL)
			-- Assign `a_window_height' to `window_height'
		do
			window_height := a_window_height
		ensure
			Is_Assign: window_height ~ a_window_height
		end

	full_screen:BOOLEAN assign set_full_screen
			-- The {GAME_WINDOW} will fill the screen

	set_full_screen(a_full_screen:BOOLEAN)
			-- Assign `a_full_screen' to `full_screen'
		do
			full_screen := a_full_screen
		ensure
			Is_Assign: full_screen ~ a_full_screen
		end

	full_screen_width:NATURAL assign set_full_screen_width
			-- The horizontal dimension of the `full_screen' {GAME_WINDOW}

	set_full_screen_width(a_full_screen_width:NATURAL)
			-- Assign `a_full_screen_width' to `full_screen_width'
		do
			full_screen_width := a_full_screen_width
		ensure
			Is_Assign: full_screen_width ~ a_full_screen_width
		end

	full_screen_height:NATURAL assign set_full_screen_height
			-- The vertical dimension of the `full_screen' {GAME_WINDOW}

	set_full_screen_height(a_full_screen_height:NATURAL)
			-- Assign `a_full_screen_height' to `full_screen_height'
		do
			full_screen_height := a_full_screen_height
		ensure
			Is_Assign: full_screen_height ~ a_full_screen_height
		end

	full_screen_display_index:INTEGER assign set_full_screen_display_index
			-- The index of the display that must receive the `full_screen' {GAME_WINDOW}

	set_full_screen_display_index(a_full_screen_display_index:INTEGER)
			-- Assign `a_full_screen_display_index' to `full_screen_display_index'
		do
			full_screen_display_index := a_full_screen_display_index
		ensure
			Is_Assign: full_screen_display_index ~ a_full_screen_display_index
		end

	show_console_message:BOOLEAN assign set_show_console_message
			-- Debug message is print to the console

	set_show_console_message(a_show_console_message:BOOLEAN)
			-- Assign `a_show_console_message' to `show_console_message'
		do
			show_console_message := a_show_console_message
		ensure
			Is_Assign: show_console_message ~ a_show_console_message
		end

	autodetect_video_mode:BOOLEAN assign set_autodetect_video_mode
			-- If a PAL game is load, change automaticaly the video mode

	set_autodetect_video_mode(a_autodetect_video_mode:BOOLEAN)
			-- Assign `a_autodetect_video_mode' to `autodetect_video_mode'
		do
			autodetect_video_mode := a_autodetect_video_mode
		ensure
			Is_Assign: autodetect_video_mode ~ a_autodetect_video_mode
		end

	video_skip:BOOLEAN assign set_video_skip
			-- Skip video frame if it is necessary

	set_video_skip(a_video_skip:BOOLEAN)
			-- Assign `a_video_skip' to `video_skip'
		do
			video_skip := a_video_skip
		ensure
			Is_Assign: video_skip ~ a_video_skip
		end

	audio_skip:BOOLEAN assign set_audio_skip
			-- Skip audio frame if it is necessary

	set_audio_skip(a_audio_skip:BOOLEAN)
			-- Assign `a_audio_skip' to `audio_skip'
		do
			audio_skip := a_audio_skip
		ensure
			Is_Assign: audio_skip ~ a_audio_skip
		end

	first_scan_line:INTEGER assign set_first_scan_line
			-- The first video line to scan

	set_first_scan_line(a_first_scan_line:INTEGER)
			-- Assign `a_first_scan_line' to `first_scan_line'
		do
			first_scan_line := a_first_scan_line
		ensure
			Is_Assign: first_scan_line ~ a_first_scan_line
		end

	last_scan_line:INTEGER assign set_last_scan_line
			-- The last video line to scan

	set_last_scan_line(a_last_scan_line:INTEGER)
			-- Assign `a_last_scan_line' to `last_scan_line'
		do
			last_scan_line := a_last_scan_line
		ensure
			Is_Assign: last_scan_line ~ a_last_scan_line
		end

	must_stretch:BOOLEAN assign set_must_stretch
			-- The Program must stretch the image when the window ratio
			-- is not the same as the video image ratio

	set_must_stretch(a_must_stretch:BOOLEAN)
			-- Assign `a_must_stretch' to `must_stretch'
		do
			must_stretch := a_must_stretch
		ensure
			Is_Assign: must_stretch ~ a_must_stretch
		end

	buttons:LIST[LIST[LIST[BUTTON_STATUS]]]
			-- Every buttons for every controller
			-- The outer list represent every controllers
			-- The second list represent every button
			-- the inner list represent possibly multiple
			-- {BUTTON_STATUS} for the same button

	sound_rate:INTEGER assign set_sound_rate
			-- The frequency of the sound samples

	set_sound_rate(a_sound_rate:INTEGER)
			-- Assign `a_sound_rate' to `sound_rate'
		do
			sound_rate := a_sound_rate
		ensure
			Is_Assign: sound_rate ~ a_sound_rate
		end

	sound_buffer_size:INTEGER assign set_sound_buffer_size
			-- The number of millisecond of sound sample to put in the sound buffer

	set_sound_buffer_size(a_sound_buffer_size:INTEGER)
			-- Assign `a_sound_buffer_size' to `sound_buffer_size'
		do
			sound_buffer_size := a_sound_buffer_size
		ensure
			Is_Assign: sound_buffer_size ~ a_sound_buffer_size
		end

	sound_volume:NATURAL_32 assign set_sound_volume
			-- The master sound volume

	set_sound_volume(a_sound_volume:NATURAL_32)
			-- Assign `a_sound_volume' to `sound_volume'
		do
			sound_volume := a_sound_volume
		ensure
			Is_Assign: sound_volume ~ a_sound_volume
		end

	sound_quality:INTEGER assign set_sound_quality
			-- he quality of the generated sound

	set_sound_quality(a_sound_quality:INTEGER)
			-- Assign `a_sound_quality' to `sound_quality'
		do
			sound_quality := a_sound_quality
		ensure
			Is_Assign: sound_quality ~ a_sound_quality
		end

	sound_triangle_volume:NATURAL_32 assign set_sound_triangle_volume
			-- The volume of the triangle sound channel

	set_sound_triangle_volume(a_sound_triangle_volume:NATURAL_32)
			-- Assign `a_sound_triangle_volume' to `sound_triangle_volume'
		do
			sound_triangle_volume := a_sound_triangle_volume
		ensure
			Is_Assign: sound_triangle_volume ~ a_sound_triangle_volume
		end

	sound_square1_volume:NATURAL_32 assign set_sound_square1_volume
			-- The volume of the first square sound channel

	set_sound_square1_volume(a_sound_square1_volume:NATURAL_32)
			-- Assign `a_sound_square1_volume' to `sound_square1_volume'
		do
			sound_square1_volume := a_sound_square1_volume
		ensure
			Is_Assign: sound_square1_volume ~ a_sound_square1_volume
		end

	sound_square2_volume:NATURAL_32 assign set_sound_square2_volume
			-- The volume of the second square sound channel

	set_sound_square2_volume(a_sound_square2_volume:NATURAL_32)
			-- Assign `a_sound_square2_volume' to `sound_square2_volume'
		do
			sound_square2_volume := a_sound_square2_volume
		ensure
			Is_Assign: sound_square2_volume ~ a_sound_square2_volume
		end

	sound_noise_volume:NATURAL_32 assign set_sound_noise_volume
			-- The volume of the noise sound channel

	set_sound_noise_volume(a_sound_noise_volume:NATURAL_32)
			-- Assign `a_sound_noise_volume' to `sound_noise_volume'
		do
			sound_noise_volume := a_sound_noise_volume
		ensure
			Is_Assign: sound_noise_volume ~ a_sound_noise_volume
		end

	sound_pcm_volume:NATURAL_32 assign set_sound_pcm_volume
			-- The volume of the PCM sound channel

	set_sound_pcm_volume(a_sound_pcm_volume:NATURAL_32)
			-- Assign `a_sound_pcm_volume' to `sound_pcm_volume'
		do
			sound_pcm_volume := a_sound_pcm_volume
		ensure
			Is_Assign: sound_pcm_volume ~ a_sound_pcm_volume
		end

feature{NONE} -- Implementation

	button_factory:BUTTON_STATUS_FACTORY
			-- The factory used to generate {BUTTON_STATUS}


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
