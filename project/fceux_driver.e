note
	description: "A driver to manage the emulator frontend"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	FCEUX_DRIVER

inherit
	FCEUX_CALLBACK
		rename
			make as make_callback
		end

create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION; a_emulator:FCEUX_EMULATOR; a_video_manager:VIDEO_MANAGER)
			-- Initialization of `Current' using `a_video_manager' as `video_manager', `a_configuration' as `configuration'
			-- and `a_emulator' as `emulator'
		do
			make_callback(a_video_manager)
			emulator := a_emulator
			configuration := a_configuration
			default_create
		end

feature -- Access

feature -- C externals

	is_turbo:BOOLEAN assign set_is_turbo
			-- Is Turbo mode activated
		external
			"C++ inline use <bpdriver.h>"
		alias
			"turbo"
		end

	set_is_turbo(a_value:BOOLEAN)
			-- Activate or disactivate Turbo mode
		external
			"C++ inline use <bpdriver.h>"
		alias
			"turbo = $a_value"
		ensure
			Is_Set: a_value = is_turbo
		end

	is_movie_finished:BOOLEAN assign set_is_movie_finished
			-- The movie has been played
		external
			"C++ inline use <bpdriver.h>"
		alias
			"closeFinishedMovie"
		end

	set_is_movie_finished(a_value:BOOLEAN)
			-- Indicate if the movie has been played
		external
			"C++ inline use <bpdriver.h>"
		alias
			"turbo = $a_value"
		ensure
			Is_Set: is_movie_finished = a_value
		end

feature {NONE} -- Implementation

	emulator:FCEUX_EMULATOR
			-- The NES emulator

	configuration:CONFIGURATION
			-- The general system confidurations

feature {NONE} -- Implementation

	show_message(a_message:STRING_8)
			-- <Precursor>
		do
			io.standard_default.put_string (a_message)
		end

	show_error(a_message:STRING_8)
			-- <Precursor>
		do
			io.error.put_string (a_message)
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
