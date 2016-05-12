note
	description: "Summary description for {FCEUX_VIDEO_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FCEUX_VIDEO_MANAGER

feature -- Access

	set_palette(a_index, a_red, a_green, a_blue:NATURAL_8)
		deferred
		end

	get_palette(a_index:NATURAL_8):TUPLE[red, green, blue:NATURAL_8]
		deferred
		end

	draw_next_frame(a_buffer:POINTER)
		deferred
		end

	video_has_changed
		deferred
		end


end
