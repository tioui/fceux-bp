note
	description: "An interface to the {VIDEO_MANAGER}."
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

deferred class
	FCEUX_VIDEO_MANAGER

feature -- Access

	set_palette(a_index, a_red, a_green, a_blue:NATURAL_8)
			-- Change the color at `a_index' in the system color palette to (`a_red', `a_green', `a_blue')
		deferred
		end

	get_palette(a_index:NATURAL_8):TUPLE[red, green, blue:NATURAL_8]
			-- Retreive the color (`a_red', `a_green', `a_blue') at `a_index' in the system color palette
		deferred
		end

	draw_next_frame(a_buffer:POINTER)
			-- Draw the video frame pointed by `a_buffer'
		deferred
		end

	video_has_changed
			-- A change has occured in the internal video system
		deferred
		end


end
