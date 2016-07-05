note
	description: "Summary description for {PANEL_KEYMAP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PANEL_KEYMAP

inherit
	PANEL
	rename
		make as make_panel
	end

create
	make

feature {NONE} -- Initialization

	make (a_x, a_y: INTEGER; a_renderer: GAME_RENDERER; a_font: TEXT_FONT)
			-- <Precursor>
		do
			make_panel(a_x, a_y, a_renderer, a_font)
			items.extend (create {UI_CHECKBOX}.make (x + margin, y + margin, "KEYMAP BOX", a_renderer, font))
		end

invariant

note
	license: ""
	source: ""

end
