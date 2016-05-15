note
	description: "Representation of a NES game cartrige"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	GAME_CARTRIGE

create
	make

feature {NONE} -- Initialization

	make(a_pointer:POINTER)
			-- Initialization of `Current' using `a_pointer' as internal `item'
		do
			item := a_pointer
		end

feature -- Access

	exists:BOOLEAN
			-- `Current' is valid
		do
			Result := not item.is_default_pointer
		end

feature {FCEUX_EMULATOR} -- Implementation

	item:POINTER

end
