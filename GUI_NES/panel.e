note
	description: "The panel on which the settings are displayed."
	author: "Pascal Belisle"
	date: "Summer 2016"
	revision: "none"

deferred class
	PANEL

inherit
	MENU

feature {NONE} -- Initialization

	make (a_x, a_y: INTEGER; a_renderer: GAME_RENDERER; a_font: TEXT_FONT)
			-- Initialization of `Current' using `a_renderer' to draw, `font' for text
		require
			a_font.is_open
		do
			x := a_x
			y := a_y
			width := 800
			height := 600
			font := a_font
			margin := 15
			current_selection_index := 0
			create items.make
		end

feature -- Access

	items: LINKED_LIST[UI_ITEM]
			-- Contains the different settings options

	width, height: INTEGER
			-- size of `Current'

	margin: INTEGER
			-- Distance in pixel from the text to the border of `Current'

	current_selection_index: INTEGER
			-- current selection of the user, when 0 the `selected_tab_index' is used instead

	active_action (a_action: INTEGER)
			-- What to do when the user is using `Current'
			-- `a_action' contains the user action.
		do
			if current_selection_index > 0 and then items[current_selection_index].is_active then
				items[current_selection_index].active_action (a_action)
				if a_action = ESCAPE then
					items[current_selection_index].activate
				end
			else
				if a_action = DOWN or a_action = UP or a_action = LEFT or a_action = RIGHT then
					if current_selection_index > 0 then
						items[current_selection_index].is_selected := False
					end
					if a_action = DOWN or a_action = RIGHT then
						current_selection_index := current_selection_index \\ items.count + 1
						items[current_selection_index].is_selected := True
					else
						current_selection_index := current_selection_index - 1
						if a_action = LEFT or current_selection_index /= 0 then
							if a_action = LEFT and current_selection_index = 0 then
								current_selection_index := items.count
							end
							items[current_selection_index].is_selected := True
						end
					end
				elseif a_action = ESCAPE then
					is_done := True
				elseif a_action = RETURN then
					if current_selection_index > 0 then
						items[current_selection_index].activate
					end
				end
			end
		end

	show (a_renderer: GAME_RENDERER)
			-- Display `Current' on the screen window
		do
			a_renderer.drawing_color := create {GAME_COLOR}.make_rgb (196, 196, 196)
			a_renderer.draw_filled_rectangle (x, y, width, height)
			across items as la_items loop
				la_items.item.show(a_renderer)
			end
		end

feature {NONE} -- Implementation

	on_iteration(a_game_window:GAME_WINDOW_RENDERED)
			-- <precursor>
		do
			-- check_buttons
			show(a_game_window.renderer)
		end

	on_key_pressed(a_timestamp: NATURAL_32; a_key_state:GAME_KEY_STATE; a_window:GAME_WINDOW_RENDERED)
			-- <Precursor>
		do

		end

invariant

note
	license: ""
	source: ""

end
