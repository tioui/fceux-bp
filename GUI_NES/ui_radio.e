note
	description: "A set of checkboxes in which we can only select one at a time."
	author: "Pascal Belisle"
	date: "Summer 2016"
	revision: "none"

class
	UI_RADIO

inherit
	UI_ITEM

create
	make

feature -- Initialization

	make (a_x, a_y, a_width, a_height: INTEGER; a_text: READABLE_STRING_GENERAL; a_list: LIST[READABLE_STRING_GENERAL]; a_font: TEXT_FONT; a_renderer: GAME_RENDERER)
			-- Initialization of `Current'
		require
			not a_list.is_empty
			a_font.is_open
		do
			x := a_x
			y := a_y
			width := a_width
			height := a_height
			current_choice_index := 1
			label := a_text
			create current_texture.make_from_surface (a_renderer, create {GAME_SURFACE}.make (1, 1))
		end

	create_options
			-- Creates the different options using `a_font'
		do

		end

feature -- Implementation

--	choices: LIST[UI_CHECKBOX]
			-- The options

	current_choice_index: INTEGER
			-- The current position in `choices'

invariant

note
	license: ""
	source: ""

end
