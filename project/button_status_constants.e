note
	description: "Constants used in buttons configuration manifests."
	author: "Louis Marchand"
	date: "Sat, 14 May 2016 01:07:03 +0000"
	revision: "0.1"

deferred class
	BUTTON_STATUS_CONSTANTS

feature {NONE} -- Constants

	manifest_keyboard_name:STRING_32
			-- The prefix of the manifest text for keyboard name
		once
			Result := {STRING_32}"Keyboard_Name_"
		end

	manifest_keyboard_virtual:STRING_32
			-- The prefix of the manifest text for virtual keyboard code
		once
			Result := {STRING_32}"Keyboard_Virtual_"
		end

	Manifest_keyboard_physical:STRING_32
			-- The prefix of the manifest text for physical keyboard code
		once
			Result := {STRING_32}"Keyboard_Physical_"
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
