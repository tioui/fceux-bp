note
	description: "The panel for the file settings (loading)"
	author: "Pascal Belisle"
	date: "Summer 2016"
	revision: "None"

class
	PANEL_FILE

inherit
	PANEL
	rename
		make as make_panel
	redefine
		active_action
	end

create
	make

feature {NONE} -- Initialization

	make (a_x, a_y: INTEGER; a_renderer: GAME_RENDERER; a_font: TEXT_FONT)
			-- <Precursor>
		do
			make_panel(a_x, a_y, a_renderer, a_font)
			items.extend (create {UI_CHECKBOX}.make (x + margin, y + margin, "TEST BOX", a_renderer, font))
			items.extend (create {UI_BUTTON}.make (x + margin, items.last.y + items.last.height + margin, 300, 50, "OK", a_font, a_renderer))
			items.extend (create {UI_BUTTON}.make (x + margin, items.last.y + items.last.height + margin, 300, 50, "CANCEL", a_font, a_renderer))
			create file_list.make(x + margin, items.last.y + items.last.height + margin, 10, "CHOOSE A FILE:", ".", a_font, a_renderer)
			items.extend (file_list)
		end

feature -- Access

	selected_file:READABLE_STRING_GENERAL
			-- The file presently selected by `Current'
		do
			Result := file_list.selected_file
		end

	active_action (a_action: INTEGER)
			-- <Precursor>
		do
			Precursor {PANEL}(a_action)
			if file_list.is_active and file_list.is_done then
				file_list.desactivate
			end
		end

feature {NONE} -- Implementation

	file_list:FILE_LIST


invariant

note
	license: ""
	source: ""

end
