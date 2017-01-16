# Copyright (C) 2015  Jim Turner <casket@turner.link>
#
# This file is part of Casket.
#
# Casket is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Casket is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Casket. If not, see <http://www.gnu.org/licenses/>.

SHELL = /bin/bash

.PHONY: default
default:

.PHONY: install
install:
	install -m 755 casket -t "$(DESTDIR)/usr/bin/"
	install -d "$(DESTDIR)/usr/share/doc/casket/"
	install -m 644 README.rst -t "$(DESTDIR)/usr/share/doc/casket/"
