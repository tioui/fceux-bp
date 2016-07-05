note
	description: "The mother of any object that appears on screen!"
	author: "Pascal Belisle"
	date: "Summer 2016"
	version: "none"

deferred class
	UI_ITEM

feature -- Access

	label: STRING
			-- The text to print before `Current'

	x: INTEGER_32 assign set_x
			-- Horizontal position of `Current'.

	y: INTEGER_32 assign set_y
			-- Vertical position of `Current'.

	width, height: INTEGER
			-- size of `Current'

	set_x (a_x: INTEGER_32)
			-- Assign `a_x' to `x'.
		do
			x := a_x
		ensure
			is_assign: x = a_x
		end

	set_y (a_y: INTEGER_32)
			-- Assign `a_y' to `y'.
		do
			y := a_y
		ensure
			is_assign: y = a_y
		end

	is_active: BOOLEAN assign set_is_active
			-- If `Current' is being edited by the user

	set_is_active(a_value: BOOLEAN)
			-- Assign `a_value' to `is_active'
		do
			is_active := a_value
		ensure
			is_assigned: is_active = a_value
		end

	is_selected: BOOLEAN assign set_is_selected
		-- True is `Current' is selected (not necessary checked, see `is_checked')

	set_is_selected(a_value: BOOLEAN)
			-- Assign `a_value' to `is_selected'
		do
			is_selected := a_value
		ensure
			is_assigned: is_selected = a_value
		end

	current_texture: GAME_TEXTURE
			-- The image that will be displayed on screen

	on_click
			-- What to do when the user click or activate `Current'
		deferred

		end

	active_action (a_action: INTEGER)
			-- What to do when the user is using `Current' while `is_active' is True
			-- `a_action' contains the user action.
		do
		end

	show (a_renderer: GAME_RENDERER)
			-- Display `Current' on the screen window
		do
			a_renderer.draw_texture (current_texture, x, y)
			if is_selected then
				a_renderer.set_drawing_color (create {GAME_COLOR}.make (255, 255, 0, 100))
				a_renderer.draw_rectangle (x - 1, y - 1, width + 2, height + 2)
				a_renderer.draw_rectangle (x - 2, y - 2, width + 4, height + 4)
			end
		end

invariant

note
	license: ""
	source: ""

end
