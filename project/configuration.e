note
	description: "Keep every configuration o the system"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	CONFIGURATION

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Initialization of `Current'
		do
			create button_factory
			first_scan_line := 0
			last_scan_line := 239
			show_console_message := True
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
			adding_virtual_button(l_controller, "keyboard_name_Right")
			adding_virtual_button(l_controller, "keyboard_name_Left")
			adding_virtual_button(l_controller, "keyboard_name_Down")
			adding_virtual_button(l_controller, "keyboard_name_Up")
			adding_virtual_button(l_controller, "keyboard_name_a")
			adding_virtual_button(l_controller, "keyboard_name_s")
			adding_virtual_button(l_controller, "keyboard_name_d")
			adding_virtual_button(l_controller, "keyboard_name_f")
			buttons.extend(l_controller)
		end

	adding_virtual_button(
						a_controller:LIST[LIST[BUTTON_STATUS]];
						a_manifest:READABLE_STRING_GENERAL
					)
			-- Add a {BUTTON_STATUS} to `a_controller' from `a_manifest' text
		local
			a_buttons:LINKED_LIST[BUTTON_STATUS]
		do
			if attached button_factory.translate_manifest (a_manifest) as la_status then
				create a_buttons.make
				a_buttons.extend (la_status)
				a_controller.extend (a_buttons)
			end
		end

feature -- Access

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
