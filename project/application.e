note
	description: "A NES (Famicom) emulator based on Fceux."
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	APPLICATION

inherit
	ARGUMENTS
	GAME_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED
	ERROR_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_engine:detachable EMULATION_ENGINE
		do
			game_library.enable_video
			audio_library.enable_sound
			create l_engine
			if not l_engine.has_error then
				l_engine.run_game("/home/louis/Documents/Super Mario Bros 3 (U) (PRG 0).nes", False, False)
				--l_engine.run_game("/home/louis/Documents/Super Mario Bros (E).nes", False, False)
				if l_engine.error_index = Game_file_not_valid then
					print("The ROM file is not valid.%N")
				end
				l_engine.close
			else
				print("Unmanaged error. Will close now.%N")
			end
			l_engine := Void
			game_library.clear_all_events
			game_library.quit_library
			audio_library.quit_library
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
