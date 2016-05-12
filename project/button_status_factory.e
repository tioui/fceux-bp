note
	description: "Summary description for {BUTTON_STATUS_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BUTTON_STATUS_FACTORY

inherit
	BUTTON_STATUS_CONSTANTS

feature -- Access

	translate_manifest(a_button_manifest:READABLE_STRING_GENERAL):detachable BUTTON_STATUS
		local
			l_button_manifest:STRING_32
		do
			l_button_manifest := a_button_manifest.as_string_32
			if l_button_manifest.as_string_32.as_lower.starts_with (manifest_keyboard_virtual.as_lower) then
				Result :=translate_keyboard_virtual_manifest(l_button_manifest)
			elseif l_button_manifest.as_lower.starts_with (Manifest_keyboard_physical.as_lower) then
				Result :=translate_keyboard_physical_manifest(l_button_manifest)
			end
		end

feature {NONE} -- Implementation

	translate_keyboard_physical_manifest(a_button_manifest:STRING_32):detachable BUTTON_STATUS
		require
			Is_Keyboard_Physical_Manifest: a_button_manifest.as_lower.starts_with (Manifest_keyboard_physical.as_lower)
		local
			l_manifest:STRING_32
		do
			l_manifest := a_button_manifest.substring (Manifest_keyboard_physical.count + 1, a_button_manifest.count)
			if l_manifest.is_integer then
				create {KEYBOARD_HARDWARE_STATUS} Result.make (l_manifest.to_integer)
			end
		end

	translate_keyboard_virtual_manifest(a_button_manifest:READABLE_STRING_GENERAL):detachable BUTTON_STATUS
		require
			Is_Keyboard_Virtual_Manifest: a_button_manifest.as_lower.starts_with (manifest_keyboard_virtual.as_lower)
		local
			l_manifest:READABLE_STRING_GENERAL
		do
			l_manifest := a_button_manifest.substring (manifest_keyboard_virtual.count + 1, a_button_manifest.count)
			create {KEYBOARD_VIRTUAL_STATUS} Result.make(l_manifest)
		end

end
