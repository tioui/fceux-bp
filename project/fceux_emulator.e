note
	description: "A Wrapper to the NES emulator backend (Fceux)"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	FCEUX_EMULATOR

create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION)
			-- Initialization of `Current' using `a_configuration' as `configuration'
		do
			has_error := False
			is_prepared := False
			configuration := a_configuration
			create managed_pixel_buffer.make (pixel_buffer_sizeof)
			create managed_sound_buffer.make (sound_buffer_sizeof)
			create managed_sound_buffer_size.make (sound_buffer_size_sizeof)
			create input_buffer.make (4)
		end

feature -- Access

	prepare
			-- Initialised the internal NES emulator backend
		do
			is_prepared := fceui_initialize
			has_error := not is_prepared
		end

	is_prepared:BOOLEAN
			-- Has `prepare' been called

	has_error:BOOLEAN
			-- An error has occured

	emulate
			-- Emulate an audio and video frame
		require
			Is_Prepared: is_prepared
		do
			emulate_frame (False, False)
		end

	emulate_skip_video
			-- Emulate an audio frame only
		require
			Is_Prepared: is_prepared
		do
			emulate_frame (True, False)
		end

	emulate_skip_audio_video
			-- Emulate the next frame but does not generate audio or video information
		require
			Is_Prepared: is_prepared
		do
			emulate_frame (True, True)
		end

	game_cartrige:detachable GAME_CARTRIGE
			-- The loaded game

	load_game(a_path:READABLE_STRING_GENERAL; a_autodetect_video_mode:BOOLEAN)
			-- Load the game in `a_path' to the `game_cartrige'
		require
			is_prepared
		local
			l_path:PATH
			l_cartrige_item:POINTER
			l_c_path:C_STRING
		do
			create l_path.make_from_string (a_path)
			create l_c_path.make (l_path.utf_8_name)
			l_cartrige_item := fceui_LoadGame(l_c_path.item, a_autodetect_video_mode, not configuration.show_console_message)
			if not l_cartrige_item.is_default_pointer then
				create game_cartrige.make (l_cartrige_item)
			else
				has_error := True
			end

		end

	disable_input(a_port:INTEGER)
			-- Disable the input port. `a_port' may be 1 or 2
			-- and represent the physical ports on the front of the NES
		require
			is_prepared
			a_port >= 1 and a_port <= 2
		do
			fceui_set_input(a_port - 1, Si_none, create {POINTER}, 0)
		end

	set_input_gamepad(a_port:INTEGER)
			-- Disable the input port. `a_port' may be 1 or 2
			-- and represent the physical ports on the front of the NES
		require
			is_prepared
			a_port >= 1 and a_port <= 2
		do
			fceui_set_input(a_port - 1, Si_gamepad, input_buffer.item, 0)
			fceui_set_input_fc (sifc_none, create {POINTER}, 0)
		end

	input_buffer:MANAGED_POINTER
			-- The memory buffer to place input informations
			-- For gamepad, each bit represent the state of a button
			-- (0 for unpressed and 1 for pressed) in that order:
			-- A, B, Select, Start, Up, Down, Left, Right
			-- The gamepad 1 used the first byte and gamepad 2
			-- used the second

	pixel_buffer:POINTER
			-- The buffer to the pixels of an emulated frame
			-- NULL if the video frame has been skipped
		do
			Result := managed_pixel_buffer.read_pointer (0)
		end

	sound_buffer:POINTER
			-- The buffer to the sound samples of an emulated frame
			-- NULL if the sound frame has been skipped
			-- Each sample is 4 byte long, but only the first 16 bits
			-- has data, you can ignore the other 16 bits.
		do
			Result := managed_sound_buffer.read_pointer (0)
		end

	sound_buffer_size:INTEGER
			-- If an emulated sound frame has been emulated,
			-- represent the number of samples that has been generated
		do
			Result := managed_sound_buffer_size.read_integer_32 (0)
		end

	video_information:TUPLE[is_pal:BOOLEAN; first_scan_line, last_scan_line:INTEGER]
			-- Some informations about emulateor video system. If `is_pal' if `True',
			-- The game is emulated using PAL standard and NTSC if `False'.
			-- `Current' emulate only the lines between `first_scan_line' and `last_scan_line'
			-- of a video frame.
		require
			Is_Prepared: is_prepared
		local
			l_is_pal:BOOLEAN
			l_first_scan_line, l_last_scan_line:INTEGER
		do
			l_is_pal := fceui_get_current_video_system($l_first_scan_line, $l_last_scan_line)
			Result := [l_is_pal, l_first_scan_line, l_last_scan_line]
		end

	set_sound_volume(a_volume:NATURAL_32)
			-- Set the master sound volume to `a_volume'
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetSoundVolume($a_volume)"
		end

	set_sound_quality(a_quality:INTEGER)
			-- Set the sound quality to `a_quality'
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetSoundQuality($a_quality)"
		end

	set_sound_rate(a_rate:INTEGER)
			-- Set the sound sample rate to `a_rate'
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_Sound($a_rate)"
		end

	set_triangle_volume(a_volume:NATURAL_32)
			-- Set the volume of the triangle sound channel to `a_volume'
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetTriangleVolume($a_volume)"
		end

	set_square1_volume(a_volume:NATURAL_32)
			-- Set the volume of the first square sound channel to `a_volume'
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetSquare1Volume($a_volume)"
		end

	set_square2_volume(a_volume:NATURAL_32)
			-- Set the volume of the second square sound channel to `a_volume'
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetSquare2Volume($a_volume)"
		end

	set_noise_volume(a_volume:NATURAL_32)
			-- Set the volume of the noise sound channel to `a_volume'
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetNoiseVolume($a_volume)"
		end

	set_pcm_volume(a_volume:NATURAL_32)
			-- Set the volume of the PCM sound channel to `a_volume'
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetPCMVolume($a_volume)"
		end

	desired_fps:REAL_64
			-- The number of frame per second that must be used in the system
		require
			Is_Prepared: is_prepared
		do
			Result := fceui_get_desired_fps.to_natural_32 / 256 / 65536
		end

feature {NONE} -- Implementation

	emulate_frame(a_skip_video, a_skip_audio:BOOLEAN)
			-- Emulate one frame. If `a_skip_video' is set, does not generate
			-- the image frame. If `a_skip_audio' is set, does not generate the
			-- audio and video frame
		require
			is_prepared
			Skip_Consistant: a_skip_audio implies a_skip_video
		local
			l_skip:INTEGER
		do
			if a_skip_audio and configuration.audio_skip then
				l_skip := 2
			elseif a_skip_video and configuration.video_skip then
				l_skip := 1
			else
				l_skip := 0
			end
			if l_skip > 0 then
				managed_pixel_buffer.put_pointer (create {POINTER}, 0)
			end
			fceui_emulate (managed_pixel_buffer.item, managed_sound_buffer.item, managed_sound_buffer_size.item, l_skip)
		end

	managed_pixel_buffer:MANAGED_POINTER
			-- Internal representation of `pixel_buffer'

	managed_sound_buffer:MANAGED_POINTER
			-- Internal representation of `sound_buffer'

	managed_sound_buffer_size:MANAGED_POINTER
			-- Internal representation of `sound_buffer_size'

	configuration:CONFIGURATION
			-- Every configurationa of the system

feature {NONE} -- C external

	pixel_buffer_sizeof:INTEGER
		external
			"C++ inline"
		alias
			"sizeof(uint8 **)"
		end

	sound_buffer_sizeof:INTEGER
		external
			"C++ inline"
		alias
			"sizeof(int32 **)"
		end

	sound_buffer_size_sizeof:INTEGER
		external
			"C++ inline"
		alias
			"sizeof(int32 *)"
		end

	fceui_get_current_video_system(a_first_scan_line, a_last_scan_line:POINTER):BOOLEAN
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_GetCurrentVidSystem((int *)$a_first_scan_line, (int *)$a_last_scan_line)"
		end


	fceui_kill
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_Kill()"
		end

	fceui_emulate(a_pixel_buffer, a_sound_buffer, a_sound_buffer_size:POINTER; a_skip:INTEGER)
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_Emulate((uint8 **)$a_pixel_buffer, (int32 **)$a_sound_buffer, (int32 *)$a_sound_buffer_size, $a_skip)"
		end

	fceui_LoadGame(a_name:POINTER; a_overwrite_video_mode, a_silent:BOOLEAN):POINTER
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_LoadGame((const char*)$a_name, $a_overwrite_video_mode, $a_silent)"
		end

	fceui_initialize:BOOLEAN
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_Initialize()"
		end

	fceui_set_input(a_port, a_type:INTEGER; ptr:POINTER; a_attrib:INTEGER)
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetInput($a_port, static_cast<ESI>($a_type), $ptr, $a_attrib)"
		end

	fceui_set_input_fc(a_type:INTEGER; ptr:POINTER; a_attrib:INTEGER)
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetInputFC(static_cast<ESIFC>($a_type), $ptr, $a_attrib)"
		end

	fceui_get_desired_fps:NATURAL_64
		require
			Is_Prepared: is_prepared
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_GetDesiredFPS()"
		end

	Si_none:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SI_NONE"
		end

	Si_gamepad:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SI_GAMEPAD"
		end

	Si_zapper:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SI_ZAPPER"
		end

	Si_powerpad_a:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SI_POWERPADA"
		end

	Si_powerpad_b:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SI_POWERPADA"
		end

	Si_arkanoid:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SI_ARKANOID"
		end

	Sifc_unset:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_UNSET"
		end

	Sifc_none:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_NONE"
		end

	Sifc_arkanoid:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_ARKANOID"
		end

	Sifc_shadow:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_SHADOW"
		end

	Sifc_4player:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_4PLAYER"
		end

	Sifc_fkb:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_FKB"
		end

	Sifc_suborkb:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_SUBORKB"
		end

	Sifc_hypershot:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_HYPERSHOT"
		end

	Sifc_mahjong:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_MAHJONG"
		end

	Sifc_quizking:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_QUIZKING"
		end

	Sifc_ftrainera:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_FTRAINERA"
		end

	Sifc_ftrainerb:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_FTRAINERB"
		end

	Sifc_oekakids:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_OEKAKIDS"
		end

	Sifc_bworld:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_BWORLD"
		end

	Sifc_toprider:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_TOPRIDER"
		end

	Sifc_count:INTEGER
		external
			"C++ inline use <driver.h>"
		alias
			"SIFC_COUNT"
		end



invariant

note
	ToDo: "[
				FCEUI_SetInput:
							X SI_NONE
							X SI_GAMEPAD
							- SI_ZAPPER
							- SI_POWERPAD
							- SI_ARKANOID
				FCEUI_SetInputFC
				FCEUI_DisableFourScore
				FCEUI_SetSnapName
				FCEUI_DisableSpriteLimitation
				FCEUI_SaveExtraDataUnderBase
				FCEUI_Initialize
				FCEUI_SetBaseDirectory
				FCEUI_SetDirOverride
				FCEUI_Emulate
				FCEUI_CloseGame
				FCEUI_ResetNES
				FCEUI_PowerNES
				FCEUI_SetRenderedLines
				FCEUI_SetNetworkPlay
				FCEUI_SelectState
				FCEUI_SaveState
				FCEUI_LoadState
				FCEUI_SaveSnapshot
				FCEUI_DispMessage
				FCEUI_GetDesiredFPS
				FCEUI_GetCurrentVidSystem
				FCEUI_GetNTSCTH
				FCEUI_SetNTSCTH
				FCEUI_AddCheat
				FCEUI_DelCheat
				FCEUI_ListCheats
				FCEUI_GetCheat
				FCEUI_SetCheat
				FCEUI_CheatSearchBegin
				FCEUI_CheatSearchEnd
				FCEUI_CheatSearchGetCount
				FCEUI_CheatSearchGet
				FCEUI_CheatSearchGetRange
				FCEUI_CheatSearchShowExcluded
				FCEUI_CheatSearchSetCurrentAsOriginal
				FCEUI_MemDump
				FCEUI_DumpMem
				FCEUI_MemPoke
				FCEUI_NMI
				FCEUI_IRQ
				FCEUI_Disassemble
				FCEUI_GetIVectors
			]"

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
