Fceux-bp
========

Note: Please note that this program is only in pre-alpha stage and is not ready for usage.

This is a NES emulator based on Fceux where you can do every configuration and management directly in
the game window. In other word, the system does not have any widget window menus, etc. This program
is done to facilitate the usage of Fceux on a controller only system (like a Steam Big Picture machine).

Installation
------------

Note: The program is only compatible with Linux at this time.

	- Clone the projet
	- Set an environment variable named FCEUX_BP_SRC that point to the clone directory
	- Download Fceux source and put the .tar.gz file in $FCEUX_BP_SRC (the version 2.2.2 has been tested)
	- Use the Makefile:
		# cd $FCEUX_BP_SRC
		# make
	- If a compilation error occured, it is probably a missing C library. Install the missing library and re-execute 'make'.
	- Start the $FCEUX_BP_SRC/project/fceux-bp.ecf in EiffelStudio

License
-------

Copyright (C) 2016  Louis Marchand

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
