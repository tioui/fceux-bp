note
	description: "Summary description for {INPUT_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INPUT_MANAGER

create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION)
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

	on_key_pressed(a_key_state: GAME_KEY)
		do
			keyboard_status.do_all (agent {KEYBOARD_STATUS}.on_pressed(a_key_state))
		end

	on_key_released(a_key_state: GAME_KEY)
		do
			keyboard_status.do_all (agent {KEYBOARD_STATUS}.on_released(a_key_state))
		end
		
	update(a_buffer:MANAGED_POINTER)
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

	configuration:CONFIGURATION

end
