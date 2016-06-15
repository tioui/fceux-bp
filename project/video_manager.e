note
	description: "Manage every emulated video frame and the video system"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	VIDEO_MANAGER

inherit
	GAME_LIBRARY_SHARED
	ERROR_CONSTANTS
		export
			{NONE} all
		end
	PLATFORM
		export
			{NONE} all
		end
	GAME_SDL_ANY
		rename
			has_error as has_sdl_error
		export
			{NONE} all
		end

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
			create l_window_builder
			error_index := No_error
			create color_palette.make (256 * 3)
			across 0 |..| 255 as la_index loop
				set_palette(la_index.item.to_natural_8, 0, 0, 0)
			end
			emulator := a_emulator
			configuration := a_configuration
			l_window_builder.set_dimension (configuration.window_width.to_integer_32, configuration.window_height.to_integer_32)
			l_window_builder.enable_resizable
			window := l_window_builder.generate_window
			if configuration.full_screen then
				window.set_display_mode (fullscreen_display_mode)
				window.set_fullscreen
			end
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

	fullscreen_display_mode:GAME_DISPLAY_MODE
		local
			l_mode:GAME_DISPLAY_MODE
			l_displays: LIST [GAME_DISPLAY]
			l_display:GAME_DISPLAY
		do
			l_displays := game_library.displays
			if l_displays.valid_index (1) then
				if l_displays.valid_index (configuration.full_screen_display_index) then
					l_display := l_displays.at (configuration.full_screen_display_index)
				else
					l_display := l_displays.at (1)
				end
				if configuration.full_screen_width = 0 or configuration.full_screen_height = 0 then
					Result := l_display.current_mode
				else
					create l_mode.make (configuration.full_screen_width.to_integer_32, configuration.full_screen_height.to_integer_32)
					Result := l_display.closest_mode (l_mode)
				end
			else
				create Result.make (configuration.full_screen_width.to_integer_32, configuration.full_screen_height.to_integer_32)
				error_index := Cannot_Found_Display
			end
		end


feature -- Access

	has_error:BOOLEAN
			-- An error occured
		do
			Result := error_index /= No_error
		end

	error_index:INTEGER
			-- A error index to indicate the error type (0 for No Error)

	on_video_change:ACTION_SEQUENCE[TUPLE[is_pal:BOOLEAN; first_scan_line, last_scan_line:INTEGER]]
			-- Actions to be launched when the internal video system has been modified

	set_palette(a_index, a_red, a_green, a_blue:NATURAL_8)
			-- <Precursor>
		do
			if a_index = 128 then
				print("")
			end
			color_palette.put_natural_8 (a_red, a_index.to_integer_32 * 3)
			color_palette.put_natural_8 (a_green, (a_index.to_integer_32 * 3) + 1)
			color_palette.put_natural_8 (a_blue, (a_index.to_integer_32 * 3) + 2)
		end

	get_palette(a_index:NATURAL_8):TUPLE[red, green, blue:NATURAL_8]
			-- <Precursor>
		local
			l_red, l_green, l_blue:NATURAL_8
		do
			l_red := color_palette.read_natural_8 (a_index.to_integer_32 * 3)
			l_green := color_palette.read_natural_8 ((a_index.to_integer_32 * 3) + 1)
			l_blue := color_palette.read_natural_8 ((a_index.to_integer_32 * 3) + 2)
			Result := [l_red, l_green, l_blue]
		end

	draw_next_frame(a_buffer:POINTER)
			-- <Precursor>
		local
		do
			window.renderer.clear
			texture.lock
			update_texture (first_scan_line, last_scan_line, color_palette.item, a_buffer, texture.pixels.item, texture.pixels.pitch, texture.pixels.pixel_format.item, is_little_endian)
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

	color_palette:MANAGED_POINTER
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

feature {NONE} -- Externals

	update_texture(a_first_line, a_last_line:INTEGER; a_color_palette, a_buffer, a_texture_buffer:POINTER
					a_texture_buffer_pitch:INTEGER; a_pixel_format:POINTER; a_is_little_endian:BOOLEAN)
			-- A C routine use to optimize the update of the `texture' when the `draw_next_frame' is used
			-- Update only the line between `a_first_line' and `a_last_line'. Use the colors in `a_color_palette'.
			-- Get the colors index from the `a_buffer' an draw them in the `a_texture_buffer'. The `texture' use
			-- `a_texture_buffer_pitch' and `a_pixel_format' internally. If `a_is_little_endian' is set, the current
			-- machine used Littel endian internal representation.
		external
			"C inline use <SDL.h>"
		alias
			"[
				int l_line, l_column;
				const SDL_PixelFormat* l_pixel_format = (const SDL_PixelFormat*)$a_pixel_format;
				Uint8* l_color_palette = (Uint8*)$a_color_palette;
				Uint8* l_buffer = (Uint8*)$a_buffer;
				Uint8* l_texture_buffer = (Uint8*)$a_texture_buffer;
				int l_bytes_per_pixel = l_pixel_format->BytesPerPixel;
				Uint8* l_pixel;
				for (l_line = $a_first_line; l_line <= $a_last_line; l_line = l_line + 1)
				{
					for (l_column = 0; l_column < 256; l_column = l_column + 1)
					{
						int l_color_index = l_buffer[(l_line * 256) + l_column];
						Uint32 l_color = SDL_MapRGB(l_pixel_format, 
								l_color_palette[l_color_index * 3],
								l_color_palette[(l_color_index * 3) + 1],
								l_color_palette[(l_color_index * 3) + 2]);
						l_pixel = l_texture_buffer + (l_line * $a_texture_buffer_pitch) + (l_column * l_bytes_per_pixel);
						switch(l_bytes_per_pixel)
						{
						case 1:
							*l_pixel = l_color;
							break;
						case 2:
							*(Uint16 *)l_pixel = l_color;
							break;
						case 3:
							if ($a_is_little_endian)
							{
								l_pixel[0] = l_color & 0xff;
								l_pixel[1] = (l_color >> 8) & 0xff;
								l_pixel[2] = (l_color >> 16) & 0xff;
							}
							else
							{
								l_pixel[0] = (l_color >> 16) & 0xff;
								l_pixel[1] = (l_color >> 8) & 0xff;
								l_pixel[2] = l_color & 0xff;
							}
							break;
						case 4:
							*(Uint32 *)l_pixel = l_color;
							break;
						}
					}
				}

		]"
		end


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
