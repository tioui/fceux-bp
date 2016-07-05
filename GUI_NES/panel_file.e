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
			items.extend (create {UI_LIST}.make (x + margin, items.last.y + items.last.height + margin, 10, "CHOOSE A FILE:", dir_content, a_font, a_renderer))
		end

	dir_content: LINKED_LIST[STRING_8]
            -- Returns file and directory names for the current directory.
        local
        	l_dir: DIRECTORY
        do
        	create Result.make
        	create l_dir.make (".")
            across
                l_dir.entries as ic
            loop
                Result.extend (ic.item.name.as_string_8)
            end
        end

invariant

note
	license: ""
	source: ""

end