note
	description: ""
	author: "Pascal Belisle"
	date: "Summer 2016"
	revision: "None"

class
	PANEL_AUDIO_VIDEO

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
			items.extend (create {UI_CHECKBOX}.make (x + margin, y + margin, "AUDIO/VIDEO BOX", a_renderer, font))
		end

invariant

note
	license: ""
	source: ""

end
