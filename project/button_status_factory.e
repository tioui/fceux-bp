note
	description: "Generate the {BUTTON_STATUS} object"
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

class
	BUTTON_STATUS_FACTORY

inherit
	BUTTON_STATUS_CONSTANTS

feature -- Access

	translate_manifest(a_button_manifest:READABLE_STRING_GENERAL):detachable BUTTON_STATUS
			-- Translate `a_button_manifest' to a {BUTTON_STATUS} object
			-- Return `Void' if not a valid `a_button_manifest'
		local
			l_button_manifest:STRING_32
		do
			l_button_manifest := a_button_manifest.as_string_32
			if l_button_manifest.as_string_32.as_lower.starts_with (manifest_keyboard.as_lower) then
				Result :=translate_keyboard_manifest(l_button_manifest)
			elseif l_button_manifest.as_lower.starts_with (Manifest_joystick.as_lower) then
				Result :=translate_joystick_manifest(l_button_manifest)
			end
		end

feature {NONE} -- Implementation

	translate_keyboard_manifest(a_button_manifest:STRING_32):detachable KEYBOARD_STATUS
			-- Translate `a_button_manifest' to a {KEYBOARD_STATUS} object
			-- Return `Void' if not a valid `a_button_manifest'
		require
			Is_Keyboard_Manifest: a_button_manifest.as_lower.starts_with (Manifest_keyboard.as_lower)
		local
			l_manifest:STRING_32
		do
			l_manifest := a_button_manifest.substring (Manifest_keyboard.count + 1, a_button_manifest.count)
			if l_manifest.as_lower.starts_with (Manifest_keyboard_physical.as_lower) then
				Result := translate_keyboard_physical_manifest(l_manifest)
			elseif l_manifest.as_lower.starts_with (manifest_keyboard_name.as_lower) then
				Result := translate_keyboard_virtual_manifest(l_manifest)
			end
		end

	translate_keyboard_physical_manifest(a_button_manifest:STRING_32):detachable KEYBOARD_PHYSICAL_STATUS
			-- Translate `a_button_manifest' to a {KEYBOARD_PHYSICAL_STATUS} object
			-- Return `Void' if not a valid `a_button_manifest'
		require
			Is_Keyboard_Physical_Manifest: a_button_manifest.as_lower.starts_with (Manifest_keyboard_physical.as_lower)
		local
			l_manifest:STRING_32
		do
			l_manifest := a_button_manifest.substring (Manifest_keyboard_physical.count + 1, a_button_manifest.count)
			if l_manifest.is_integer then
				create Result.make (l_manifest.to_integer)
			end
		end

	translate_keyboard_virtual_manifest(a_button_manifest:READABLE_STRING_GENERAL):detachable KEYBOARD_VIRTUAL_STATUS
			-- Translate `a_button_manifest' to a {KEYBOARD_VIRTUAL_STATUS} object
			-- Return `Void' if not a valid `a_button_manifest'
		require
			Is_Keyboard_Virtual_Manifest: a_button_manifest.as_lower.starts_with (manifest_keyboard_name.as_lower)
		local
			l_manifest:READABLE_STRING_GENERAL
		do
			l_manifest := a_button_manifest.substring (manifest_keyboard_name.count + 1, a_button_manifest.count)
			create Result.make_with_name(l_manifest)
		end

	translate_joystick_manifest(a_joystick_manifest:READABLE_STRING_GENERAL):detachable JOYSTICK_STATUS
			-- Translate `a_joystick_manifest' to a {JOYSTICK_STATUS} object
			-- Return `Void' if not a valid `a_joystick_manifest'
		require
			Is_Joystick_Manifest: a_joystick_manifest.as_lower.starts_with (Manifest_joystick.as_lower)
		local
			l_manifest:READABLE_STRING_GENERAL
		do
			l_manifest := a_joystick_manifest.substring (Manifest_joystick.count + 1, a_joystick_manifest.count)
			if l_manifest.has_substring (Manifest_joystick_button) then
				if attached extract_joystick_index(l_manifest, Manifest_joystick_button) as la_index then
					Result := translate_joystick_button_manifest(la_index.new_manifest, la_index.joystick_index)
				end
			end
		end

	extract_joystick_index(a_current_manifest, a_next_namifest:READABLE_STRING_GENERAL):detachable TUPLE[joystick_index:INTEGER; new_manifest:READABLE_STRING_GENERAL]
			-- Extract the joystick index preceeding `a_next_namifest' in `a_current_manifest'. Return the index found and
			-- a new {READABLE_STRING_GENERAL} containing `a_current_manifest' without the joystick index.
		require
			Manifest_Valid: a_current_manifest.has_substring (a_next_namifest)
		local
			l_manifest, l_joystick_index_string:READABLE_STRING_GENERAL
			l_manifest_position, l_joystick_index:INTEGER
		do
			l_manifest_position := a_current_manifest.substring_index (a_next_namifest, 1)
			l_joystick_index_string := a_current_manifest.substring (1, l_manifest_position - 1)
			if l_joystick_index_string.is_integer then
				l_joystick_index := l_joystick_index_string.to_integer
				l_manifest := a_current_manifest.substring (l_manifest_position, a_current_manifest.count)
				Result := [l_joystick_index, l_manifest]
			end
		end

	translate_joystick_button_manifest(a_joystick_manifest:READABLE_STRING_GENERAL; a_joystick_index:INTEGER):detachable JOYSTICK_BUTTON_STATUS
			-- Translate `a_joystick_manifest' to a {JOYSTICK_BUTTON_STATUS} object
			-- Return `Void' if not a valid `a_joystick_manifest'
		require
			Is_Joystick_Manifest: a_joystick_manifest.as_lower.starts_with (Manifest_joystick_button.as_lower)
		local
			l_manifest:READABLE_STRING_GENERAL
		do
			l_manifest := a_joystick_manifest.substring (Manifest_joystick_button.count + 1, a_joystick_manifest.count)
			if l_manifest.is_integer then
				create Result.make (a_joystick_index, l_manifest.to_integer)
			end
		end


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
