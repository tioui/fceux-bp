note
	description: "An {AUDIO_SOUND} that stream NES emulated sound frame"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	STREAM_SOUND

inherit
	AUDIO_SOUND

create
	make

feature {NONE} -- Initialization

	make(a_frequency:INTEGER)
			-- Initialization of `Current' using `a_frequency' as `frequency'
		do
			frequency := a_frequency
			open
		end

feature {AUDIO_SOURCE}

	fill_buffer(a_buffer:POINTER;a_max_length:INTEGER)
			-- <Precursor>
		local
			l_count:INTEGER
			l_managed_source_buffer, l_managed_destination_buffer:MANAGED_POINTER
		do
			if not is_buffer_managed then
				l_count := (buffer_count.min (a_max_length // byte_per_buffer_sample) - 1)
				create l_managed_source_buffer.share_from_pointer (buffer, buffer_count * 4)
				create l_managed_destination_buffer.share_from_pointer (a_buffer, a_max_length)
				across
					0 |..| l_count as la_index
				loop
					l_managed_destination_buffer.put_integer_16 (
													l_managed_source_buffer.read_integer_16 (
															(la_index.item * byte_per_buffer_sample * 2)),
													la_index.item * byte_per_buffer_sample
												)
				end
				last_buffer_size := (l_count + 1) * byte_per_buffer_sample
				is_buffer_managed := True
			else
				last_buffer_size := 0
			end
		end

	byte_per_buffer_sample:INTEGER
			-- <Precursor>
		once
			Result := bits_per_sample // 8
		end


feature --Access

	set_sample(a_buffer:POINTER; a_count:INTEGER)
		do
			buffer := a_buffer
			buffer_count := a_count
			is_buffer_managed := False
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

	buffer:POINTER
			-- The last audio samples frame to play

	buffer_count:INTEGER
			-- The number of sample in the `buffer'

	is_buffer_managed:BOOLEAN
			-- Is `buffer' already played

end
