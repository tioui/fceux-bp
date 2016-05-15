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

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_engine:detachable FCEUX_ENGINE
		do
			game_library.enable_video
			audio_library.enable_sound
			create l_engine
			if not l_engine.has_error then
				l_engine.run
			end
			l_engine := Void
			game_library.clear_all_events
			game_library.quit_library
			audio_library.quit_library
		end

end
