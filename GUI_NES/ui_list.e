note
	description: "A list of options that can be scrolled."
	author: "Pascal Belisle"
	date: "Summer 2016"
	revision: "none"

class
	UI_LIST

inherit
	UI_ITEM
		redefine
			active_action, show, activate
		end

create
	make

feature {NONE} -- Initialization

	make (a_x, a_y, a_count: INTEGER; a_label: READABLE_STRING_GENERAL; a_list: LIST[READABLE_STRING_GENERAL]; a_font: TEXT_FONT; a_renderer: GAME_RENDERER)
			-- Initialization of `Current' at position `a_x', `a_y' (to be assigned to `x' and `y'
			-- `a_label' is the text to be shown above the list. Assigned to `label'
			-- `a_list' contains the options to be selected. Assigned to `choices'
			-- `a_count' is the number of item of `a_list' to show. Assigned to `item_count'
			-- `a_font' is the font to print the text. Assigned to `font'
			-- `a_renderer' to draw things. Assigned to `renderer'
		require
			not a_list.is_empty
		local
			l_temp_text: TEXT_SURFACE_BLENDED
			l_symbol_font: TEXT_FONT
		do
			x := a_x
			y := a_y
			renderer := a_renderer
			item_count := a_count
			font := a_font
			label := a_label
			choices := a_list
			create l_symbol_font.make ("WINGDNG3.TTF", 24)
			if l_symbol_font.is_openable then
				l_symbol_font.open
			else
				print("Couldn't load the Font file")
			end
			create l_temp_text.make (label, font, create {GAME_COLOR}.make_rgb (0, 0, 0))
			create label_texture.make_from_surface (renderer, l_temp_text)
			width := 300
			item_height := l_temp_text.height
			choice_index := 1
			selected_index := 1
			create button_up.make (x, y + label_texture.height, width, 30, "abcdefgpABCDEFGP", l_symbol_font, renderer)
			update_current_texture
			height := current_texture.height
			create button_down.make (x, y + label_texture.height + button_up.height + height, width, 30, "Qq", l_symbol_font, renderer)
		ensure
			button_same_widht: button_up.width = button_down.width
		end

feature -- Access

	set_choices(a_choices: LIST[READABLE_STRING_GENERAL])
			-- Assign `choices' with the value of `a_choices'
		do
			choices := a_choices
			choice_index := 1
			selected_index := 1
			update_current_texture
		ensure
			Is_Assign: choices ~ a_choices
		end

	selected_index: INTEGER
			-- The current selection in `choices'

	choices : LIST[READABLE_STRING_GENERAL] assign set_choices
			-- A list of all the options to choose from

	is_done: BOOLEAN
			-- True when player presses start, the A button or return

	activate
			-- <Precursor>
		do
			Precursor
			is_done := False
		end

feature {NONE} -- Implementation

	update_current_texture
			-- Converts the visible options in `choices' using `font'
			-- Updates `current_texture'
		local
			i, l_next_y: INTEGER
			l_surface: GAME_SURFACE
			l_white, l_black, l_blue: GAME_COLOR
		do
			create l_white.make_rgb (255, 255, 255)
			create l_black.make_rgb (0, 0, 0)
			create l_blue.make_rgb (255, 0, 0)
			create l_surface.make (width, item_height * item_count)
			l_surface.draw_rectangle (create {GAME_COLOR}.make_rgb (196, 196, 196), 0, 0, width, item_height)
			l_next_y := label_texture.height + button_up.height
			from
				i := choice_index
			until
				(i = choice_index + item_count)
			loop
				if i > choices.count then
					l_surface.draw_rectangle (l_white, 1, l_next_y, width, item_height)
				else
					if i = selected_index then
						l_surface.draw_rectangle (l_blue, 1, l_next_y, width, item_height)
						l_surface.draw_surface (create {TEXT_SURFACE_BLENDED}.make (choices[i], font, l_white), 1, l_next_y)
					else
						l_surface.draw_rectangle (l_white, 1, l_next_y, width, item_height)
						l_surface.draw_surface (create {TEXT_SURFACE_BLENDED}.make (choices[i], font, l_black), 1, l_next_y)
					end
				end
				i := i + 1
				l_next_y := l_next_y + item_height
			end
			current_texture := create {GAME_TEXTURE}.make_from_surface (renderer, l_surface)
		end

	renderer: GAME_RENDERER
			-- We need to keep a refenrence to the game window renderer to update `current_texture'

	font: TEXT_FONT
			-- The font!!!

	label_texture: GAME_TEXTURE
			-- The texture on which the label is printed

	item_count: INTEGER
			-- The number of items to be shown on screen
	item_height: INTEGER
			-- The height of each item in the list

	button_up, button_down: UI_BUTTON
			-- The buttons used to browse through the list for the mouse user.

	choice_index: INTEGER
			-- The current position  in `choices' to start drawing the options

	show (a_renderer: GAME_RENDERER)
			-- <Precursor>
		do
			a_renderer.drawing_color := create {GAME_COLOR}.make_rgb (0, 0, 0)
			a_renderer.draw_texture (label_texture, x, y)
			button_up.show (a_renderer)
			button_down.show (a_renderer)
			a_renderer.draw_texture (current_texture, x, y + label_texture.height + button_up.height)
			if is_selected then
				if is_active then
					a_renderer.set_drawing_color (create {GAME_COLOR}.make_rgb (0, 255, 0))
				else
					a_renderer.set_drawing_color (create {GAME_COLOR}.make_rgb (255, 255, 0))
				end
				a_renderer.draw_rectangle (x - 1, y + label_texture.height + button_up.height - 1, width + 2, current_texture.height + 2)
				a_renderer.draw_rectangle (x - 2, y + label_texture.height + button_up.height - 2, width + 4, current_texture.height + 4)
			end
		end

	valid_selection
			-- Check if the selected item is a valid selection to return and if so, set `is_done'
		do
			is_done := True
		end

	active_action (a_action: INTEGER)
			-- <Precursor>
			-- See the Constants section for `a_action' possible choices
		do
			inspect a_action
			when DOWN then
				if selected_index < choices.count then
					selected_index := selected_index + 1
					if (selected_index - choice_index) = 5 then
						choice_index := choice_index + 1
					end
					update_current_texture
				end
			when UP then
				if selected_index > 1 then
					selected_index := selected_index - 1
					if choice_index > 1 then
						choice_index := choice_index - 1
					end
					update_current_texture
				end
			when RETURN then
				valid_selection
			end
		end

invariant

note
	license: ""
	source: ""

end
