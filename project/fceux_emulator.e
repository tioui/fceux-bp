note
	description: "Summary description for {FCEUX_EMULATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FCEUX_EMULATOR

create
	make

feature {NONE} -- Initialization

	make(a_from_configuration:CONFIGURATION)
		do
			has_error := False
			is_initialized := False
			configuration := a_from_configuration
			create managed_pixel_buffer.make (pixel_buffer_sizeof)
			create managed_sound_buffer.make (sound_buffer_sizeof)
			create managed_sound_buffer_size.make (sound_buffer_size_sizeof)
		end

feature -- Access

	initialize
		do
			is_initialized := fceui_initialize
			has_error := not is_initialized
		end

	is_initialized:BOOLEAN

	emulate
		require
			is_initialized
		local
			l_skip:INTEGER
		do
			if configuration.audio_skip then
				l_skip := 2
			elseif configuration.video_skip then
				l_skip := 1
			else
				l_skip := 0
			end
			fceui_emulate (managed_pixel_buffer.item, managed_sound_buffer.item, managed_sound_buffer_size.item, l_skip)
		end

	has_error:BOOLEAN

	game_cartrige:detachable GAME_CARTRIGE

	load_game(a_path:READABLE_STRING_GENERAL)
		require
			is_initialized
		local
			l_path:PATH
			l_cartrige_item:POINTER
			l_c_path:C_STRING
		do
			create l_path.make_from_string (a_path)
			create l_c_path.make (l_path.utf_8_name)
			l_cartrige_item := fceui_LoadGame(l_c_path.item, configuration.autodetect_video_mode, not configuration.show_console_message)
			if not l_cartrige_item.is_default_pointer then
				create game_cartrige.make (l_cartrige_item)
			end

		end

	disable_input(a_port:INTEGER)
			-- Disable the input port. `a_port' may be 1 or 2
			-- and represent the physical ports on the front of the NES
		require
			is_initialized
			a_port >= 1 and a_port <= 2
		do
			input_buffer := Void
			fceui_set_input(a_port - 1, Si_none, create {POINTER}, 0)
		end

	set_input_gamepad(a_port:INTEGER)
			-- Disable the input port. `a_port' may be 1 or 2
			-- and represent the physical ports on the front of the NES
		require
			is_initialized
			a_port >= 1 and a_port <= 2
		local
			l_input_buffer: MANAGED_POINTER
		do
			create l_input_buffer.make (4)
			fceui_set_input(a_port - 1, Si_gamepad, l_input_buffer.item + (a_port - 1), 0)
			input_buffer := l_input_buffer
			fceui_set_input_fc (sifc_none, create {POINTER}, 0)
		ensure
			Buffer_Is_Set: attached input_buffer as la_buffer and then la_buffer.count = 4
		end

	input_buffer:detachable MANAGED_POINTER

	pixel_buffer:POINTER
		do
			Result := managed_pixel_buffer.read_pointer (0)
		end

	sound_buffer:POINTER
		do
			Result := managed_sound_buffer.read_pointer (0)
		end

	sound_buffer_size:INTEGER
		do
			Result := managed_sound_buffer_size.read_integer_32 (0)
		end

	video_information:TUPLE[is_pal:BOOLEAN; first_scan_line, last_scan_line:INTEGER]
		local
			l_is_pal:BOOLEAN
			l_first_scan_line, l_last_scan_line:INTEGER
		do
			l_is_pal := fceui_get_current_video_system($l_first_scan_line, $l_last_scan_line)
			Result := [l_is_pal, l_first_scan_line, l_last_scan_line]
		end

	set_sound_volume(a_volume:NATURAL_32)
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetSoundVolume($a_volume)"
		end

	set_sound_quality(a_quality:INTEGER)
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetSoundQuality($a_quality)"
		end

	set_sound_rate(a_rate:INTEGER)
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_Sound($a_rate)"
		end

	set_triangle_volume(a_volume:NATURAL_32)
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetTriangleVolume($a_volume)"
		end

	set_square1_volume(a_volume:NATURAL_32)
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetSquare1Volume($a_volume)"
		end

	set_square2_volume(a_volume:NATURAL_32)
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetSquare2Volume($a_volume)"
		end

	set_noise_volume(a_volume:NATURAL_32)
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetNoiseVolume($a_volume)"
		end

	set_pcm_volume(a_volume:NATURAL_32)
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetPCMVolume($a_volume)"
		end

feature {NONE} -- Implementation

	managed_pixel_buffer:MANAGED_POINTER

	managed_sound_buffer:MANAGED_POINTER

	managed_sound_buffer_size:MANAGED_POINTER

	configuration:CONFIGURATION

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
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_GetCurrentVidSystem((int *)$a_first_scan_line, (int *)$a_last_scan_line)"
		end


	fceui_kill
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_Kill()"
		end

	fceui_emulate(a_pixel_buffer, a_sound_buffer, a_sound_buffer_size:POINTER; a_skip:INTEGER)
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_Emulate((uint8 **)$a_pixel_buffer, (int32 **)$a_sound_buffer, (int32 *)$a_sound_buffer_size, $a_skip)"
		end

	fceui_LoadGame(a_name:POINTER; a_overwrite_video_mode, a_silent:BOOLEAN):POINTER
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
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetInput($a_port, static_cast<ESI>($a_type), $ptr, $a_attrib)"
		end

	fceui_set_input_fc(a_type:INTEGER; ptr:POINTER; a_attrib:INTEGER)
		external
			"C++ inline use <driver.h>"
		alias
			"FCEUI_SetInputFC(static_cast<ESIFC>($a_type), $ptr, $a_attrib)"
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

end
