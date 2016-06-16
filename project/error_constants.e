note
	description: "Constants use in error management."
	author: "Louis Marchand"
	date: "Thu, 16 Jun 2016 20:07:02 +0000"
	revision: "0.1"

deferred class
	ERROR_CONSTANTS

feature {NONE} -- Constants

	No_Error:INTEGER = 0
			-- Indicate that no error has been found

	General_Error:INTEGER = 1
			-- Indicate that an unknown error has been found

	Game_file_not_valid:INTEGER = 2
			-- Indicate that the Game file to open does not exist or is not a readable ROM file

	Cannot_Found_Display:INTEGER = 3
			-- The system seems to have no screen.

end
