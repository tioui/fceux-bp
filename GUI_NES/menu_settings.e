note
	description: "The GUI to change the settings and loading files."
	author: "Pascal Belisle"
	date: "Summer 2016"
	revision: "none"

class
	MENU_SETTINGS

inherit
	MENU

create
	make

feature {NONE} -- Initialization

	make (a_game_window:GAME_WINDOW_RENDERED; a_config: CONFIGURATION)
			-- Initialization of `Current'. Will be drawn on `a_game_window'
		do
			config := a_config
			tab_spacing := 3
			x := 100
			y := 70
			create font.make ("8bitOperatorPlus8-Bold.ttf", 24)
			if font.is_openable then
				font.open
			else
				has_error := True
				print("Couldn't load the Font file")
			end
			create tabs.make (4)
			tabs.extend (create {TAB}.make (x, y, "FILE", a_game_window.renderer, font))
			tabs.extend (create {TAB}.make (tabs.last.x + tabs.last.width + tab_spacing, y, "AUDIO/VIDEO", a_game_window.renderer, font))
			tabs.extend (create {TAB}.make (tabs.last.x + tabs.last.width + tab_spacing, y, "CONTROLLER", a_game_window.renderer, font))
			tabs.extend (create {TAB}.make (tabs.last.x + tabs.last.width + tab_spacing, y, "KEYMAP", a_game_window.renderer, font))
			tabs.extend (create {TAB}.make (tabs.last.x + tabs.last.width + tab_spacing, y, "ABOUT", a_game_window.renderer, font))
			tabs.first.activate
			tabs.first.is_selected := True
			create panels.make (4)
			-- Important: Panels must be created in the same order as the tabs above
			panels.extend (create {PANEL_FILE}.make (x, y + tabs.first.height, a_game_window.renderer, font))
			panels.extend (create {PANEL_AUDIO_VIDEO}.make (x, y + tabs.first.height, a_game_window.renderer, font))
			panels.extend (create {PANEL_CONTROLLER_SETTINGS}.make (x, y + tabs.first.height, a_game_window.renderer, font))
			panels.extend (create {PANEL_KEYMAP}.make (x, y + tabs.first.height, a_game_window.renderer, font))
			panels.extend (create {PANEL_ABOUT}.make (x, y + tabs.first.height, a_game_window.renderer, font))
			active_panel_index := 1
			selected_tab_index := 1
		ensure
			font.is_open
			tabs.count = panels.count
		end

feature

	config: CONFIGURATION
			-- Contains the default settings

	tab_spacing: INTEGER
			-- The spacing between each tab in pixel

	tabs: ARRAYED_LIST[TAB]
			-- Contains the tabs to switch between the setting panels

	panels: ARRAYED_LIST[PANEL]
			-- Contains the panels on which we display the settings

	active_panel_index: INTEGER
			-- the current {PANEL} shown to the user

	selected_tab_index: INTEGER
			-- to navigate through the tabs

	on_iteration(a_game_window:GAME_WINDOW_RENDERED)
			-- <Precursor>
		do
			show(a_game_window.renderer)
		end

	show(a_renderer:GAME_RENDERER)
			-- display `Current'
		do
			panels[active_panel_index].show(a_renderer)
			across tabs as la_tabs loop
				la_tabs.item.show(a_renderer)
			end
		end

	on_key_pressed(a_timestamp: NATURAL_32; a_key_state:GAME_KEY_STATE; a_window:GAME_WINDOW_RENDERED)
			-- <Precursor>
		do
			if a_key_state.is_down  then
				if panels[active_panel_index].current_selection_index = 0 then
					tabs[selected_tab_index].is_selected := False
				end
				panels[active_panel_index].active_action(DOWN)
			elseif a_key_state.is_up then
				if panels[active_panel_index].current_selection_index > 0 then
					panels[active_panel_index].active_action(UP)
					if panels[active_panel_index].current_selection_index = 0 then
						tabs[selected_tab_index].is_selected := True
					end
				end
			elseif a_key_state.is_left then
				if panels[active_panel_index].current_selection_index = 0 then
					tabs[selected_tab_index].is_selected := False
					if selected_tab_index = 1 then
						selected_tab_index := tabs.count
					else
						selected_tab_index := selected_tab_index - 1
					end
					tabs[selected_tab_index].is_selected := True
				else
					panels[active_panel_index].active_action(LEFT)
				end
			elseif a_key_state.is_right then
				if panels[active_panel_index].current_selection_index = 0 then
					tabs[selected_tab_index].is_selected := False
					selected_tab_index := selected_tab_index \\ tabs.count + 1
					tabs[selected_tab_index].is_selected := True
				else
					panels[active_panel_index].active_action(RIGHT)
				end
			elseif a_key_state.is_escape then
				panels[active_panel_index].active_action(ESCAPE)
				if panels[active_panel_index].is_done then
					is_done := True
				end
			elseif a_key_state.is_return then
				if panels[active_panel_index].current_selection_index = 0 then
					if active_panel_index /= selected_tab_index then
						tabs[active_panel_index].desactivate
						active_panel_index := selected_tab_index
						tabs[active_panel_index].activate
					end
				else
					panels[active_panel_index].active_action(RETURN)
				end
			end
		end

invariant

note
	license: ""
	source: ""

end
