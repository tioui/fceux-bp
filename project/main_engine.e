note
description: "The {ENGINE} that do the link between every other {ENGINE}s"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	MAIN_ENGINE

inherit
	ENGINE
		redefine
			default_create, run
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		local
			l_configuration:CONFIGURATION
			l_window_builder:GAME_WINDOW_RENDERED_BUILDER
			l_window:GAME_WINDOW_RENDERED
		do
			create l_configuration
			create l_window_builder
			l_window_builder.set_dimension (l_configuration.window_width.to_integer_32, l_configuration.window_height.to_integer_32)
			l_window_builder.enable_resizable
			l_window := l_window_builder.generate_window
			make(l_configuration, l_window)
			window.set_display_mode (fullscreen_display_mode)
			if configuration.full_screen then
				window.set_fullscreen
			end
			if not configuration.must_stretch then
				window.renderer.set_logical_size (256, 240)
			end
			create emulation_engine.make(l_configuration, l_window)
			error_index := emulation_engine.error_index
		end

	fullscreen_display_mode:GAME_DISPLAY_MODE
			-- The {GAME_DISPLAY_MODE} to use in fullscreen setting.
		local
			l_mode:GAME_DISPLAY_MODE
			l_displays: LIST [GAME_DISPLAY]
			l_display:GAME_DISPLAY
		do
			l_displays := game_library.displays
			if l_displays.valid_index (1) then
				if l_displays.valid_index (configuration.full_screen_display_index) then
					l_display := l_displays.at (configuration.full_screen_display_index)
				else
					l_display := l_displays.at (1)
				end
				if configuration.full_screen_width = 0 or configuration.full_screen_height = 0 then
					Result := l_display.current_mode
				else
					create l_mode.make (configuration.full_screen_width.to_integer_32, configuration.full_screen_height.to_integer_32)
					Result := l_display.closest_mode (l_mode)
				end
			else
				create Result.make (configuration.full_screen_width.to_integer_32, configuration.full_screen_height.to_integer_32)
				error_index := Cannot_Found_Display
			end
		end

feature -- Access

	run
			-- <Precursor>
		do
			emulation_engine.open_game(
								"/home/louis/Documents/Super Mario Bros 3 (U) (PRG 0).nes",
								False, False
							)
			if emulation_engine.is_game_open then
				emulation_engine.run
			else
				if emulation_engine.error_index = Game_file_not_valid then
					print("The ROM file is not valid.%N")
				else
					print("Unmanaged error.%N")
				end
			end
			emulation_engine.close
		end

	emulation_engine:EMULATION_ENGINE
			-- The {ENGINE} used for game emulation

invariant

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
