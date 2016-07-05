note
	description: "Classe temporaire pour tester mes fenêtre pop-up"
	author: "Pascal Belisle et Louis Marchand"
	date: "Été 2016"
	revision: "1.0"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	IMG_LIBRARY_SHARED
	TEXT_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Initialisation de `Current'
		local
			l_engine:detachable GAME_ENGINE
		do
			game_library.enable_video
			game_library.enable_joystick
			image_file_library.enable_image (true, false, false)
			text_library.enable_text
			create l_engine.make
			l_engine := Void
			game_library.clear_all_events
			image_file_library.quit_library
			text_library.quit_library
			game_library.quit_library
		end

invariant

note
	license: ""
	source: ""

end
