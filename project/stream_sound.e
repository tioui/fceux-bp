note
	description: "Summary description for {STREAM_SOUND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STREAM_SOUND

inherit
	AUDIO_SOUND

create
	make

feature {NONE} -- Initialization

	make(a_frequency:INTEGER)
		do
			frequency := a_frequency
			create buffer.make (Buffer_size)
			buffer_tail := 0
			buffer_head := 0
			open
		end

feature {AUDIO_SOURCE}

	fill_buffer(a_buffer:POINTER;a_max_length:INTEGER)
			-- <Precursor>
		do
			if buffer_tail >= buffer_head then
				last_buffer_size := buffer_tail - buffer_head
			else
				last_buffer_size := buffer_size - buffer_head
			end
			if a_max_length < last_buffer_size then
				last_buffer_size := a_max_length
			end
			if last_buffer_size > 0 then
				a_buffer.memory_copy (buffer.item + buffer_head, last_buffer_size)
				buffer_head := (buffer_head + last_buffer_size) \\ buffer_size
			end
		end

	byte_per_buffer_sample:INTEGER
			-- <Precursor>
		once
			Result := bits_per_sample // 8
		end


feature --Access

	add_sample(a_buffer:POINTER; a_count:INTEGER)
		local
			l_index:INTEGER
			l_next_buffer_tail:INTEGER
			l_managed_pointer:MANAGED_POINTER
			l_stop:BOOLEAN
		do
			create l_managed_pointer.share_from_pointer (a_buffer, a_count * 4)
			from
				l_index := 0
				l_stop := False
			until
				l_index >= a_count or
				l_stop
			loop
				l_next_buffer_tail := (buffer_tail + byte_per_buffer_sample) \\ Buffer_size
				if l_next_buffer_tail /= buffer_head then
					buffer.put_integer_16 (l_managed_pointer.read_integer_16 (l_index * 2) , buffer_tail)
					buffer_tail := l_next_buffer_tail
				else
					l_stop := True
				end
				l_index := l_index + 1
			end
		end

	channel_count:INTEGER
			-- <Precursor>
		once
			Result := 1
		end

	frequency:INTEGER
			-- <Precursor>

	bits_per_sample:INTEGER
			-- <Precursor>
		once
			Result := 16
		end

	is_signed:BOOLEAN
			-- <Precursor>
		once
			Result := True
		end

	is_seekable:BOOLEAN
			-- <Precursor>
		once
			Result := False
		end

	restart
			-- <Precursor>
		do
		end

	is_openable:BOOLEAN
			-- <Precursor>
		once
			Result := True
		end

	open
			-- <Precursor>
		do
			is_open := True
		end

feature {NONE} -- Implementation

	buffer:MANAGED_POINTER

	buffer_head:INTEGER

	buffer_tail:INTEGER

	Buffer_size:INTEGER = 65536

end
