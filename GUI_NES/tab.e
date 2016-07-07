note
	description: "The tab to switch between the setting panels."
	author: "Pascal Belisle"
	date: "Summer 2016"
	revision: "none"

class
	TAB

inherit
	UI_ITEM
		redefine
			activate, desactivate
		end

create
	make

feature {NONE} -- Initialization

	make (a_x, a_y: INTEGER; a_text: READABLE_STRING_GENERAL; a_renderer: GAME_RENDERER; a_font: TEXT_FONT)
			-- Initialization of `Current' using `a_renderer'
			-- `a_text' is the label displayed on `Current'
		require
			not a_text.is_empty
			a_font.is_open
		local
			l_text_normal, l_text_active: TEXT_SURFACE_BLENDED
			l_normal_surface, l_active_surface: GAME_SURFACE
		do
			label := a_text
			is_active := False
			margin := 15
			create l_text_normal.make (a_text, a_font, create {GAME_COLOR}.make_rgb (179, 179, 179))
			create l_text_active.make (a_text, a_font, create {GAME_COLOR}.make_rgb (0, 0, 0))
			x := a_x
			y := a_y
			width := l_text_normal.width + margin *2
			height := l_text_normal.height + margin * 2

			create l_normal_surface.make (width, height)
			create l_active_surface.make (width, height)
			l_normal_surface.draw_rectangle (create {GAME_COLOR}.make_rgb (94, 94, 94), 0, 0, width, height)
			l_active_surface.draw_rectangle (create {GAME_COLOR}.make_rgb (196, 196, 196), 0, 0, width, height)
			l_normal_surface.draw_surface (l_text_normal, margin, margin)
			l_active_surface.draw_surface (l_text_active, margin, margin)
			create normal_texture.make_from_surface (a_renderer, l_normal_surface)
			create active_texture.make_from_surface (a_renderer, l_active_surface)

			current_texture := normal_texture
		end

feature -- Access

	activate
			-- <Precursor>
		do
			Precursor
			current_texture := active_texture
		end

	desactivate
			-- <Precursor>
		do
			Precursor
			current_texture := normal_texture
		end

	active_texture, normal_texture: GAME_TEXTURE
			-- One image for each state depending on `is_active'

	margin: INTEGER
			-- Distance in pixel from the text to the border of `Current'


invariant

note
	license: ""
	source: ""

end
