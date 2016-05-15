note
	description: "Every emulation input mnagement"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	INPUT_MANAGER

create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION)
			-- Initialization of `Current' using `a_configuration' as `configuration'
		do
			configuration := a_configuration
			create {LINKED_LIST[KEYBOARD_STATUS]}keyboard_status.make
			across configuration.buttons as la_controller loop
				across la_controller.item as la_buttons loop
					across la_buttons.item as la_button loop
						if attached {KEYBOARD_STATUS} la_button.item as la_keyboard_status then
							keyboard_status.extend (la_keyboard_status)
						end
					end
				end
			end
		end

feature -- Access

	on_key_pressed(a_key: GAME_KEY)
			-- When `a_key' has been pressed
		do
			keyboard_status.do_all (agent {KEYBOARD_STATUS}.on_pressed(a_key))
		end

	on_key_released(a_key: GAME_KEY)
			-- When `a_key' has been repeased
		do
			keyboard_status.do_all (agent {KEYBOARD_STATUS}.on_released(a_key))
		end

	update(a_buffer:MANAGED_POINTER)
			-- Change the data in `a_buffer' to represent `Current'
			-- For gamepad, each bit represent the state of a button
			-- (0 for unpressed and 1 for pressed) in that order:
			-- A, B, Select, Start, Up, Down, Left, Right
			-- The gamepad 1 used the first byte and gamepad 2
			-- used the second
		local
			l_mask:NATURAL_8
			l_index:INTEGER
		do
			l_index := 0
			across configuration.buttons as la_controllers loop
				l_mask := 0
				across la_controllers.item as la_controller loop
					l_mask := l_mask.bit_shift_left (1)
					if across la_controller.item as la_buttons some la_buttons.item.is_pressed end then
						l_mask := l_mask.bit_or (1)
					end
				end
				a_buffer.put_natural_8 (l_mask, l_index)
				l_index := l_index + 1
			end
		end

feature {NONE} -- Implementation

	keyboard_status:LIST[KEYBOARD_STATUS]
			-- Each {BUTTON_STATUS} representing that is managed a keyboard key

	configuration:CONFIGURATION
			-- Every configuration of the system

end
