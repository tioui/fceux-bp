note
	description: "Summary description for {MENU_PAUSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_PAUSE

inherit
	MENU

create
	make

feature {NONE} -- Initialization

	make (a_game_window:GAME_WINDOW_RENDERED; a_options: LIST[READABLE_STRING_GENERAL])
			-- Initialization of `Current'. Will be drawn on `a_game_window'
			-- `a_options' must contain at least one {STRING}. Its content will be converted to game texture and shown to user.
		require
			not a_options.is_empty
		do
			create font.make ("8bitOperatorPlus8-Bold.ttf", 72)
			if font.is_openable then
				font.open
			else
				has_error := True
				print("Couldn't load the Font file")
			end
			create {ARRAYED_LIST [TUPLE[normal, active:GAME_TEXTURE]]}options.make(a_options.count)
			across a_options as la_options loop
				add_option(la_options.item, a_game_window.renderer)
			end
			margin := 15
			current_index := 1
			set_centered(a_game_window.width, a_game_window.height)
		end

feature

	width, height: INTEGER
			-- size of `Current'

	margin: INTEGER
			-- The spacing between each menu item

	options: LIST [TUPLE[normal, active:GAME_TEXTURE]]
			-- Contains {TEXT_SURFACE_BLENDED} of the options the user can choose from

	set_centered (a_width, a_height: INTEGER)
			-- Calculate the `x' and `y' of `Current' so that the menu appears centered based on the window `a_width' and `a_height'
		do
			set_size
			x := a_width // 2 - width // 2
			y := a_height // 2 - height // 2
		end

	set_size
			-- Sets the `width' and `height' of `Current'
		do
			width := 0
			height := 0
			across options as la_options loop
				if la_options.item.normal.width > width then
					width := la_options.item.normal.width
				end
				height := height + la_options.item.normal.height + margin
			end
		end

	on_iteration(a_game_window:GAME_WINDOW_RENDERED)
			-- <precursor>
		do
			-- check_buttons
			show(a_game_window.renderer)
		end

	current_index: INTEGER
			-- current choice of the user

	show(a_renderer:GAME_RENDERER)
			-- display `Current'
		local
			i, l_y, l_offset: INTEGER
		do
			i := 1
			l_y := y
			across options as la_options loop
				l_offset := (width - la_options.item.normal.width) // 2
				if i ~ current_index then
					a_renderer.draw_texture (la_options.item.active, x + l_offset, l_y)
				else
					a_renderer.draw_texture (la_options.item.normal, x + l_offset, l_y)
				end
				l_y := l_y + la_options.item.normal.height + margin
				i := i + 1
			end
		end

	add_option(a_option_text: READABLE_STRING_GENERAL; a_renderer: GAME_RENDERER)
			-- add and option to `options'
		require
			not a_option_text.is_empty
			font.is_open
		local
			l_text_normal, l_text_active: TEXT_SURFACE_BLENDED
		do
			create l_text_normal.make (a_option_text, font, create {GAME_COLOR}.make_rgb (255, 255, 255))
			create l_text_active.make (a_option_text, font, create {GAME_COLOR}.make_rgb (255, 234, 0))
			if not l_text_normal.has_error or not l_text_active.has_error then
				options.extend (
								[create {GAME_TEXTURE}.make_from_surface (a_renderer, l_text_normal),
								create {GAME_TEXTURE}.make_from_surface (a_renderer, l_text_active)]
								)
			end
		end

	on_key_pressed(a_timestamp: NATURAL_32; a_key_state:GAME_KEY_STATE; a_window:GAME_WINDOW_RENDERED)
			-- <Precursor>
		do
			if a_key_state.is_down then
				current_index := current_index \\ options.count + 1
			elseif a_key_state.is_up then
				if current_index = 1 then
					current_index := options.count
				else
					current_index := current_index - 1
				end
			elseif a_key_state.is_return or a_key_state.is_escape then
				is_done := True
			end
		end

invariant

note
	license: ""
	source: ""

end
