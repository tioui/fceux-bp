note
	description: "Summary description for {GAME_CARTRIGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_CARTRIGE

create
	make

feature {NONE} -- Initialization

	make(a_pointer:POINTER)
		do
			item := a_pointer
		end

feature -- Access

	exists:BOOLEAN
		do
			Result := not item.is_default_pointer
		end

feature {FCEUX_EMULATOR} -- Implementation

	item:POINTER

end
