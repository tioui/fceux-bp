note
	description: "A simple UI Button !!!"
	author: "Pascal Belisle"
	date: "Summer 2016"
	revision: "none"

class
	UI_BUTTON

inherit
	UI_ITEM

create
	make

feature -- Initialisation

	make (a_x, a_y, a_width, a_height: INTEGER; a_text: READABLE_STRING_GENERAL; a_font: TEXT_FONT; a_renderer: GAME_RENDERER)
			-- Initialization of `Current' at position `a_x', `a_y' (assigned to `x' and `y').
			-- The size `a_width' and `a_height' will be assigned to `width' and `height'
			-- If `a_width' and `a_height' are less than the text dimensions, text will be croped
			-- `a_text' is the text on the button, will be assigned to `label'
		require
			a_font.is_open
			a_width > 0
			a_height > 0
		local
			l_text_surface : TEXT_SURFACE_BLENDED
			l_button_surface: GAME_SURFACE
		do
			label := a_text
			x := a_x
			y := a_y
			width := a_width
			height := a_height
			create l_text_surface.make (label, a_font, create {GAME_COLOR}.make_rgb (0, 0, 0))
			create l_button_surface.make (width, height)
			l_button_surface.draw_rectangle (create {GAME_COLOR}.make_rgb (255, 255, 255), 0, 0, width, height)
			l_button_surface.draw_rectangle (create {GAME_COLOR}.make_rgb (99, 99, 99), 1, 1, width, height)
			l_button_surface.draw_rectangle (create {GAME_COLOR}.make_rgb (196, 196, 196), 2, 2, width-4, height-4)
			l_button_surface.draw_surface (l_text_surface, (width // 2) - (l_text_surface.width // 2), (height // 2) - (l_text_surface.height // 2))
			create current_texture.make_from_surface (a_renderer, l_button_surface)
		end



invariant

note
	license: ""
	source: ""


end
