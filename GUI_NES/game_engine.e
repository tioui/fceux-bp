note
	description : "Lance les fenêtres pop-up pour les tester"
	author: "Pascal Belisle"
	date: "Été 2016"
	version: "1.0"

class
	GAME_ENGINE

inherit
	GAME_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'
		local
			l_window_builder:GAME_WINDOW_RENDERED_BUILDER
			l_window:GAME_WINDOW_RENDERED
		do
			create l_window_builder
			create config.default_initialization
			l_window_builder.set_dimension (Window_width, Window_height)
			l_window_builder.set_title ("GUI_NES Implementation")
			l_window := l_window_builder.generate_window
			back := texture_from_file(l_window.renderer, "back.png")
			game_library.quit_signal_actions.extend (agent on_quit(?))
			game_library.iteration_actions.extend (agent on_iteration(?, l_window))
			l_window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?,?,?))
			l_window.mouse_button_released_actions.extend (agent on_mouse_released(?,?,?))
			l_window.mouse_motion_actions.extend (agent on_mouse_move(?, ?, ?, ?))
			l_window.key_pressed_actions.extend (agent on_key_pressed(?, ?, l_window))
			l_window.update
			game_library.launch
		end

feature {NONE} -- Implementation

	config: CONFIGURATION
			-- Contains the default settings

	current_menu: detachable MENU
			-- Holds the current menu or void.

	back: GAME_TEXTURE
			-- The background image

	has_error: BOOLEAN
			-- True if an error occured during the execution of `Current'

	on_iteration(a_timestamp:NATURAL_32; a_game_window:GAME_WINDOW_RENDERED)
			-- À faire à chaque iteration.
		do
			a_game_window.renderer.draw_texture (back, 0, 0)
			if attached {MENU_PAUSE} current_menu as la_menu then
				if la_menu.is_done then
					inspect
						la_menu.current_index
					when 2 then
						-- Reset game
						-- À faire
						current_menu := Void
					when 3 then
						current_menu := Void -- Est-ce nécessaire, sera t'il garbage collecté si je crée tout de suite le nouveau menu????
						current_menu := create {MENU_SETTINGS}.make (a_game_window, config)
					when 4 then
						-- Save state
						-- À faire
					when 5 then
						on_quit(a_timestamp)
					else
						current_menu := Void
					end
				else
					la_menu.on_iteration(a_game_window)
				end
			elseif attached {MENU_SETTINGS} current_menu as la_menu then
				if la_menu.is_done then
					current_menu := Void
				else
					la_menu.on_iteration(a_game_window)
				end
			end
			a_game_window.update
		end

	menu_pause_options: LIST[READABLE_STRING_GENERAL]
			-- The choices that will be shown to the user on pause
		do
			create {ARRAYED_LIST[READABLE_STRING_GENERAL]}Result.make(5)
			Result.extend("RESUME GAME")
			Result.extend("RESET GAME")
			Result.extend("CONTROL PANEL")
			Result.extend("SAVE STATE")
			Result.extend("QUIT")
		end

	on_quit(a_timestamp: NATURAL_32)
			-- Executed when user quits (when closing the window for exemple)
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur appuie sur un bouton de la souris.
		do

		end

	on_mouse_released(a_timestamp: NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur relâche un bouton de la souris.
		do

		end

	on_mouse_move(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_MOTION_STATE; a_delta_x, a_delta_y: INTEGER_32)
			--
		do

		end

	on_key_pressed(a_timestamp: NATURAL_32; a_key_state:GAME_KEY_STATE; a_window:GAME_WINDOW_RENDERED)
		do
			if attached {MENU} current_menu as la_menu then
				la_menu.on_key_pressed(a_timestamp, a_key_state, a_window)
			else
				if a_key_state.is_f then
					current_menu := create {MENU_PAUSE}. make (a_window, menu_pause_options)
				end
			end
		end

	texture_from_file (a_renderer:GAME_RENDERER; a_image_path:READABLE_STRING_GENERAL):GAME_TEXTURE
			-- Loads image from file `a_image_path' and returns it as a {GAME_SURFACE}
		local
			l_image:IMG_IMAGE_FILE
			l_surface:GAME_SURFACE
			l_texture:GAME_TEXTURE
		do
			has_error := False
			create l_image.make (a_image_path)
			if l_image.is_openable then
				l_image.open
				if not l_image.is_open then
					has_error := True
				end
			else
				has_error := True
			end
			if has_error then
				create l_surface.make (1, 1)
				create l_texture.make_from_surface (a_renderer, l_surface)
			else
				create l_texture.make_from_image (a_renderer, l_image)
			end
			Result := l_texture

		end

feature {NONE} -- Constantes

	Window_width:NATURAL_16 = 1024
		-- Width of the main window in pixels.

	Window_height:NATURAL_16 = 768
		-- Height of the main window in pixels.

invariant

note
	license: ""
	source: ""

end
