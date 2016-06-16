note
	description: "Contain the mecanics of the program"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

deferred class
	ENGINE

inherit
	ANY
	GAME_LIBRARY_SHARED
		export
			{NONE} all
		end
	ERROR_CONSTANTS
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION; a_window:GAME_WINDOW_RENDERED)
			-- Initialization of `Current' using `a_configuration'
			-- as `configuration' and `a_window' as `window'
		do
			configuration := a_configuration
			window := a_window
		end

feature -- Access

	run
			-- Launch the execution of `Current'
		require
			No_Error: not has_error
		do
			quit_asked := False
			game_library.quit_signal_actions.extend (agent on_quit)
			before_execution
			Game_library.launch
			after_execution
		end

	before_execution
			-- Initialize what is necessessary for the `run' routine
		do
		end

	after_execution
			-- Launched at the end of the `run' routine
		do
		end
			
	
	quit_asked:BOOLEAN
			-- The game must stop

	on_quit(a_timestamp:NATURAL)
			-- When the user close the application
		do
			quit_asked := True
			Game_library.stop
		end

	has_error:BOOLEAN
			-- Set if an error occured on creation
		do
			Result := error_index /= No_error
		end

	error_index:INTEGER
			-- A error index to indicate the error type (0 for No Error)

	configuration:CONFIGURATION
			-- Every configurations of the system

	window:GAME_WINDOW_RENDERED
			-- The {GAME_WINDOW} to draw every informations

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
