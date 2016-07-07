note
	description: "A checkbox!"
	author: "Pascal Belisle"
	date: "Summer 2016"
	revision: "none"

class
	UI_CHECKBOX

inherit
	UI_ITEM
		redefine
			active_action
		end

create
	make

feature {NONE} -- Initialization

	make (a_x, a_y: INTEGER; a_text: READABLE_STRING_GENERAL; a_renderer: GAME_RENDERER; a_font: TEXT_FONT)
			-- Initialization of `Current' using `a_renderer' to draw at position `a_x',`a_y'
			-- `a_font' and `a_text' for the `label'
		require
			not a_text.is_empty
			a_font.is_open
		local
			l_label_surface, l_x_surface: TEXT_SURFACE_BLENDED
			l_surface_unchecked, l_surface_checked, l_box: GAME_SURFACE
			l_margin: INTEGER
		do
			is_selected := False
			l_margin := 15
			label := a_text
			create l_label_surface.make (label, a_font, create {GAME_COLOR}.make_rgb (0, 0, 0))
			create l_x_surface.make ("X", a_font, create {GAME_COLOR}.make_rgb (0, 0, 0))

			x := a_x
			y := a_y

			create l_box.make (l_label_surface.height, l_label_surface.height)
			l_box.draw_rectangle (create {GAME_COLOR}.make_rgb (100, 100, 100), 0, 0, l_box.width, l_box.height)
			l_box.draw_rectangle (create {GAME_COLOR}.make_rgb (255, 255, 255), 2, 2, l_box.width, l_box.height)

			width := l_label_surface.width + l_margin * 3 + l_box.width
			height := l_label_surface.height + l_margin * 2

			create l_surface_unchecked.make (width, height)
			l_surface_unchecked.draw_rectangle (create {GAME_COLOR}.make_rgb (196, 196, 196), 0, 0, width, height)
			l_surface_unchecked.draw_surface (l_label_surface, l_margin, l_margin)
			l_surface_unchecked.draw_surface (l_box, l_label_surface.width + l_margin * 2, l_margin)

			create l_surface_checked.make (width, height)
			l_box.draw_surface (l_x_surface, 1, 1)
			l_surface_checked.draw_rectangle (create {GAME_COLOR}.make_rgb (196, 196, 196), 0, 0, width, height)
			l_surface_checked.draw_surface (l_label_surface, l_margin, l_margin)
			l_surface_checked.draw_surface (l_box, l_label_surface.width + l_margin * 2, l_margin)

			create unchecked_texture.make_from_surface (a_renderer, l_surface_unchecked)
			create checked_texture.make_from_surface (a_renderer, l_surface_checked)

			current_texture := unchecked_texture
		end

feature

	is_checked: BOOLEAN assign set_is_checked
			-- True if `Current' is checked

	set_is_checked(a_value: BOOLEAN)
			-- Assign `a_value' to `is_checked'
		do
			is_checked := a_value
			if is_checked then
				current_texture := checked_texture
			else
				current_texture := unchecked_texture
			end
		ensure
			is_assigned: is_checked = a_value
		end

	unchecked_texture, checked_texture: GAME_TEXTURE
			-- Texture representing the two states of `Current'


	active_action (a_action: INTEGER)
			-- <Precursor>
		do
			if a_action = RETURN then
				set_is_checked(not is_checked)
			end
		end

invariant

note
	license: ""
	source: ""

end
