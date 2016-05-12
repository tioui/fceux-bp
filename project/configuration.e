note
	description: "Summary description for {CONFIGURATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURATION

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			ntfc_palette := 0
			tint := 0
			hue := 0
			palette_file := ""
			is_pal := False
			has_game_genie := False
			is_low_pass := False
			is_sprite_limitation_disabled := True
			first_scan_line := 0
			last_scan_line := 239
			show_console_message := True
			autodetect_video_mode := True
			video_skip := False
			audio_skip := False
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
		local
			l_button_factory:BUTTON_STATUS_FACTORY
			l_controller:ARRAYED_LIST[LIST[BUTTON_STATUS]]
		do
			create l_button_factory
			create {ARRAYED_LIST[LIST[LIST[BUTTON_STATUS]]]} buttons.make (2)
			create l_controller.make (8)
			adding_virtual_button(l_button_factory, l_controller, "keyboard_virtual_Right")
			adding_virtual_button(l_button_factory, l_controller, "keyboard_virtual_Left")
			adding_virtual_button(l_button_factory, l_controller, "keyboard_virtual_Down")
			adding_virtual_button(l_button_factory, l_controller, "keyboard_virtual_Up")
			adding_virtual_button(l_button_factory, l_controller, "keyboard_virtual_a")
			adding_virtual_button(l_button_factory, l_controller, "keyboard_virtual_s")
			adding_virtual_button(l_button_factory, l_controller, "keyboard_virtual_d")
			adding_virtual_button(l_button_factory, l_controller, "keyboard_virtual_f")
			buttons.extend(l_controller)
		end

	adding_virtual_button(
						a_button_factory:BUTTON_STATUS_FACTORY;
						a_controller:LIST[LIST[BUTTON_STATUS]];
						a_manifest:READABLE_STRING_GENERAL
					)
		local
			a_buttons:LINKED_LIST[BUTTON_STATUS]
		do
			if attached a_button_factory.translate_manifest (a_manifest) as la_status then
				create a_buttons.make
				a_buttons.extend (la_status)
				a_controller.extend (a_buttons)
			end
		end

feature -- Access

	show_console_message:BOOLEAN

	autodetect_video_mode:BOOLEAN

	video_skip:BOOLEAN

	audio_skip:BOOLEAN

	ntfc_palette:INTEGER

	tint:INTEGER

	hue:INTEGER

	palette_file:READABLE_STRING_GENERAL

	is_pal:BOOLEAN

	has_game_genie:BOOLEAN

	is_low_pass:BOOLEAN

	is_sprite_limitation_disabled:BOOLEAN

	first_scan_line:INTEGER

	last_scan_line:INTEGER

	must_stretch:BOOLEAN

	buttons:LIST[LIST[LIST[BUTTON_STATUS]]]

	sound_rate:INTEGER

	sound_volume:NATURAL_32

	sound_quality:INTEGER

	sound_triangle_volume:NATURAL_32

	sound_square1_volume:NATURAL_32

	sound_square2_volume:NATURAL_32

	sound_noise_volume:NATURAL_32

	sound_pcm_volume:NATURAL_32


invariant
	Skip_Valid: audio_skip implies video_skip
end
