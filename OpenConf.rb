# Copyright 2013    Bryan Garber da Silva   <spellcasterbryan@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

DEFAULT_CONF_PATH = "~/.syncconfrc"

# This class reads and writes configuration data. In reality, there's only one
# data to store: the checkout location. Is an acceptable thing that we have only
# one configuration to encapsulate other configurations.
class OpenConf
public
    def initialize
        @file = DEFAULT_CONF_PATH
    end

    def file= (f)
        @file = f
    end

    def read
        fd = File.new(@file, "r")
        dir = fd.gets
        fd.close
        return dir
    end

    def write (dir)
        fd = File.new(@file, "w")
        fd << "#{dir}\n"
        fd.close
    end
end

