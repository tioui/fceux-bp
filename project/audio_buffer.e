note
	description: "Summary description for {AUDIO_BUFFER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUDIO_BUFFER

inherit
	MEMORY_STRUCTURE
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Initialization of `Current'
		do
			make
			set_head(0)
			set_tail(0)
			set_data(create {POINTER})
		end

feature -- Access

	head:INTEGER assign set_head
			-- Position of the last value added into `Current'
		do
			Result := get_structure_head(item)
		end

	set_head(a_head:INTEGER)
			-- Assign `head' with the value of `a_head'
		require
			Head_Valid: a_head >= 0
		do
			set_structure_head(item, a_head)
		ensure
			is_assign:head ~ a_head
		end

	tail:INTEGER assign set_tail
			-- Position of the first value added into `Current'
		do
			Result := get_structure_tail(item)
		end

	set_tail(a_tail:INTEGER)
			-- Assign `tail' with the value of `a_tail'
		require
			Tail_Valid: a_tail >= 0
		do
			set_structure_tail(item, a_tail)
		ensure
			is_assign:tail ~ a_tail
		end

	data:POINTER assign set_data
		do
			Result := get_structure_data(item)
		end

	set_data(a_data:POINTER)
		do
			set_structure_data(item, a_data)
		ensure
			is_assign:data ~ a_data
		end

feature -- Measurement

	structure_size: INTEGER
			-- <Precursor>
		do
			Result := sizeof_audio_buffer
		end

feature {NONE} -- External

	sizeof_audio_buffer:INTEGER
		external
			"C inline use <bpaudio.h>"
		alias
			"sizeof(audio_buffer)"
		end

	set_structure_head(a_item:POINTER; a_head:INTEGER)
		external
			"C inline use <bpaudio.h>"
		alias
			"((audio_buffer*)$a_item)->head = (int)$a_head"
		end

	get_structure_head(a_item:POINTER):INTEGER
		external
			"C inline use <bpaudio.h>"
		alias
			"((audio_buffer*)$a_item)->head"
		end

	set_structure_tail(a_item:POINTER; a_tail:INTEGER)
		external
			"C inline use <bpaudio.h>"
		alias
			"((audio_buffer*)$a_item)->tail = (int)$a_tail"
		end

	get_structure_tail(a_item:POINTER):INTEGER
		external
			"C inline use <bpaudio.h>"
		alias
			"((audio_buffer*)$a_item)->tail"
		end

	set_structure_data(a_item:POINTER; a_data:POINTER)
		external
			"C inline use <bpaudio.h>"
		alias
			"((audio_buffer*)$a_item)->data = (Sint32*)$a_data"
		end

	get_structure_data(a_item:POINTER):POINTER
		external
			"C inline use <bpaudio.h>"
		alias
			"((audio_buffer*)$a_item)->data"
		end

invariant

	Head_Valid: head >= 0
	Tail_Valid: tail >= 0

end
