note
	description: "Summary description for {VIDEO_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VIDEO_MANAGER

inherit
	FCEUX_VIDEO_MANAGER
	GAME_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION; a_emulator: FCEUX_EMULATOR)
			-- <Precursor>
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_pixel_format:GAME_PIXEL_FORMAT
		do
			emulator := a_emulator
			configuration := a_configuration
			l_window_builder.set_dimension (256, 240)
			l_window_builder.enable_resizable
			window := l_window_builder.generate_window
			create l_pixel_format.default_create
			l_pixel_format.set_index8
			l_pixel_format.set_color_palette (create {GAME_COLOR_PALETTE}.make (256))
			create surface.make_for_pixel_format (l_pixel_format, 256, 240)
			create on_video_change
			first_scan_line := configuration.first_scan_line
			last_scan_line := configuration.last_scan_line
			create optimied_surface.make_for_window (window, surface.width, surface.height)
		end


feature -- Access

	on_video_change:ACTION_SEQUENCE[TUPLE[is_pal:BOOLEAN; first_scan_line, last_scan_line:INTEGER]]

	set_palette(a_index, a_red, a_green, a_blue:NATURAL_8)
		do
			if attached surface.pixel_format.color_palette as la_palette then
				la_palette.at (a_index) := create {GAME_COLOR}.make_rgb (a_red, a_green, a_blue)
			end
		end

	get_palette(a_index:NATURAL_8):TUPLE[red, green, blue:NATURAL_8]
		local
			l_color:GAME_COLOR_READABLE
		do
			if attached surface.pixel_format.color_palette as la_palette then
				l_color := la_palette.at (a_index)
			else
				create l_color.make_rgb (0, 0, 0)
			end
			Result := [l_color.red, l_color.green, l_color.blue]
		end

	draw_next_frame(a_buffer:POINTER)
		do
			surface.lock
			across first_scan_line |..| last_scan_line as la_index loop
				(surface.pixels.item + (la_index.item * surface.pixels.pitch)).memory_copy (a_buffer + (la_index.item * 256), 254)
			end
			surface.unlock
			if window.surface.width = surface.width and window.surface.height = surface.height then
				window.surface.draw_surface (surface, 0, 0)
			else
				optimied_surface.draw_surface (surface, 0, 0)
				if configuration.must_stretch then
					window.surface.draw_sub_surface_with_scale (
								optimied_surface, 0, 0, optimied_surface.width,
								optimied_surface.height, 0, 0, window.surface.width,
								window.surface.height
							)
				else
					if ratio_old_window_width /= window.surface.width or ratio_old_window_height /= window.surface.height then
						update_ratio
					end
					window.surface.draw_sub_surface_with_scale (
								optimied_surface,
								0, 0, optimied_surface.width, optimied_surface.height,
								ratio_destination_x, ratio_destination_y, ratio_destination_width, ratio_destination_height
							)
				end
			end
			window.update
		end

	update_ratio
			-- Update the `ratio_destination_x', `ratio_destination_y', `ratio_old_window_width' and
			-- `ratio_old_window_height' values.
		local
			l_width_ratio, l_height_ratio, l_ratio:REAL_64
		do
			ratio_old_window_width := window.surface.width
			ratio_old_window_height := window.surface.height
			l_width_ratio := ratio_old_window_width / optimied_surface.width
			l_height_ratio := ratio_old_window_height / optimied_surface.height
			l_ratio := l_width_ratio.min (l_height_ratio)
			ratio_destination_width := (optimied_surface.width * l_ratio).rounded
			ratio_destination_height := (optimied_surface.height * l_ratio).rounded
			ratio_destination_x := ratio_old_window_width // 2 - ratio_destination_width // 2
			ratio_destination_y := ratio_old_window_height // 2 - ratio_destination_height // 2
		end

	video_has_changed
		local
			l_video_informations:TUPLE[is_pal:BOOLEAN; first_scan_line, last_scan_line:INTEGER]
		do
			l_video_informations := emulator.video_information
			first_scan_line := l_video_informations.first_scan_line
			last_scan_line := l_video_informations.last_scan_line
			is_pal:=l_video_informations.is_pal
			on_video_change.call (l_video_informations)
		end

	window:GAME_WINDOW_SURFACED

	surface:GAME_SURFACE

feature {NONE} -- Implementation

	configuration:CONFIGURATION

	emulator: FCEUX_EMULATOR

	first_scan_line, last_scan_line:INTEGER

	is_pal:BOOLEAN

	optimied_surface:GAME_SURFACE

	ratio_destination_x, ratio_destination_y:INTEGER

	ratio_destination_width, ratio_destination_height:INTEGER

	ratio_old_window_width, ratio_old_window_height:INTEGER


end
