note
	description: "Manage every emulated video frame and the video system"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	VIDEO_MANAGER

inherit
	FCEUX_VIDEO_MANAGER
	GAME_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make(a_configuration:CONFIGURATION; a_emulator: FCEUX_EMULATOR)
			-- Initialization of `Current' using `a_configuration' as `configuration'
			-- and `a_emulator' as `emulator'
		local
			l_window_builder:GAME_WINDOW_RENDERED_BUILDER
			l_pixel_format:GAME_PIXEL_FORMAT
		do
			create {ARRAYED_LIST[GAME_COLOR]}color_palette.make (256)
			across 1 |..| 256 as la_index loop
				color_palette.extend(create {GAME_COLOR}.make_rgb (0, 0, 0))
			end
			emulator := a_emulator
			configuration := a_configuration
			l_window_builder.set_dimension (configuration.window_width.to_integer_32, configuration.window_height.to_integer_32)
			l_window_builder.enable_resizable
			window := l_window_builder.generate_window
			create l_pixel_format.default_create
			l_pixel_format.set_rgb888
			create texture.make (window.renderer, l_pixel_format, 256, 240)
			create on_video_change
			first_scan_line := configuration.first_scan_line
			last_scan_line := configuration.last_scan_line
			if not configuration.must_stretch then
				window.renderer.set_logical_size (256, 240)
			end
		end


feature -- Access

	on_video_change:ACTION_SEQUENCE[TUPLE[is_pal:BOOLEAN; first_scan_line, last_scan_line:INTEGER]]
			-- Actions to be launched when the internal video system has been modified

	set_palette(a_index, a_red, a_green, a_blue:NATURAL_8)
			-- <Precursor>
		local
			l_color:GAME_COLOR
			l_index:INTEGER
		do
			l_index := a_index.to_integer_32 + 1
			check color_palette.valid_index (l_index) end
			create l_color.make_rgb (a_red, a_green, a_blue)
			color_palette.put_i_th (l_color, l_index)
		end

	get_palette(a_index:NATURAL_8):TUPLE[red, green, blue:NATURAL_8]
			-- <Precursor>
		local
			l_color:GAME_COLOR
			l_index:INTEGER
		do
			l_index := a_index.to_integer_32 + 1
			if color_palette.valid_index (l_index) then
				l_color := color_palette.at (l_index)
			else
				create l_color.make_rgb (0, 0, 0)
			end

			Result := [l_color.red, l_color.green, l_color.blue]
		end

	draw_next_frame(a_buffer:POINTER)
			-- <Precursor>
		local
			l_managed_buffer:MANAGED_POINTER
		do
			window.renderer.clear
			create l_managed_buffer.share_from_pointer (a_buffer, 256*240)
			texture.lock
			across first_scan_line |..| last_scan_line as la_line loop
				across 0 |..| 255 as la_column loop
					texture.pixels.set_pixel (color_palette.at (l_managed_buffer.read_natural_8 (la_column.item + (la_line.item * 256)).to_integer_32 + 1), la_line.item + 1, la_column.item + 1)
				end
			end
			texture.unlock
			if configuration.must_stretch then
				window.renderer.draw_sub_texture_with_scale (texture, 0, 0, 256, 240, 0, 0, window.renderer.output_size.width, window.renderer.output_size.height)
			else
				window.renderer.draw_texture (texture, 0, 0)
			end

			window.update
		end

	video_has_changed
			-- <Precursor>
		local
			l_video_informations:TUPLE[is_pal:BOOLEAN; first_scan_line, last_scan_line:INTEGER]
		do
			l_video_informations := emulator.video_information
			first_scan_line := l_video_informations.first_scan_line
			last_scan_line := l_video_informations.last_scan_line
			is_pal:=l_video_informations.is_pal
			on_video_change.call (l_video_informations)
		end

	window:GAME_WINDOW_RENDERED
			-- The {GAME_WINDOW} to draw the scene

	texture:GAME_TEXTURE_STREAMING
			-- The source texture

	color_palette:LIST[GAME_COLOR]
			-- The palette used to draw video frames

feature {NONE} -- Implementation

	configuration:CONFIGURATION
			-- Every configurations of the system

	emulator: FCEUX_EMULATOR
			-- The NES emulator backend

	first_scan_line, last_scan_line:INTEGER
			-- The range of lines to draw in the `window'

	is_pal:BOOLEAN
			-- Is `Current' in the PAL (`True') format or NTSC (`False')

invariant

note
	license: "[
		    Copyright (C) 2016 Louis Marchand

		    This program is free software: you can redistribute it and/or modify
		    it under the terms of the GNU General Public License as published by
		    the Free Software Foundation, either version 3 of the License, or
		    (at your option) any later version.

		    This program is distributed in the hope that it will be useful,
		    but WITHOUT ANY WARRANTY; without even the implied warranty of
		    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		    GNU General Public License for more details.

		    You should have received a copy of the GNU General Public License
		    along with this program.  If not, see <http://www.gnu.org/licenses/>.
		]"
end
