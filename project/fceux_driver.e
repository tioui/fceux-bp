note
	description: "Summary description for {FCEUX_DRIVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	make(a_configuration:CONFIGURATION; a_emulator:FCEUX_EMULATOR; a_video_manager:FCEUX_VIDEO_MANAGER)
			-- <Precursor>
		do
			make_callback(a_video_manager)
			emulator := a_emulator
			configuration := a_configuration
			default_create
		end

feature -- Access

feature -- C externals

	is_turbo:BOOLEAN assign set_is_turbo
		external
			"C++ inline use <bpdriver.h>"
		alias
			"turbo"
		end

	set_is_turbo(a_value:BOOLEAN)
		external
			"C++ inline use <bpdriver.h>"
		alias
			"turbo = $a_value"
		end

	is_movie_finished:BOOLEAN assign set_is_movie_finished
		external
			"C++ inline use <bpdriver.h>"
		alias
			"closeFinishedMovie"
		end

	set_is_movie_finished(a_value:BOOLEAN)
		external
			"C++ inline use <bpdriver.h>"
		alias
			"turbo = $a_value"
		end

feature {NONE} -- Implementation

	emulator:FCEUX_EMULATOR

	configuration:CONFIGURATION

feature {NONE} -- Implementation

	show_message(a_message:STRING_8)
		do
			io.standard_default.put_string (a_message)
		end

	show_error(a_message:STRING_8)
		do
			io.error.put_string (a_message)
		end



end
