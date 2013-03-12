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

DEFAULT_CONF_PATH = ENV['HOME'] + "/.syncconfrc"

DIRECTORY_LOCATION = "directory_location"
REPOSITORY_TYPE = "repository_type"

# This class reads and writes configuration data. In reality, there's only one
# data to store: the checkout location. Is an acceptable thing that we have only
# one configuration to encapsulate other configurations.
class OpenConf
    attr_accessor :dir, :type

public
    def initialize
        @dir = ""
        @type = ""

        if File.exists?(DEFAULT_CONF_PATH) then
            File.open(DEFAULT_CONF_PATH, "r") { |fd|
                while line = fd.gets
                    str_arr = line.split("=")

                    if str_arr.length > 0 then
                        item = str_arr[0].strip
                        value = str_arr[1].strip

                        if item.casecmp(DIRECTORY_LOCATION) then
                            @dir = value
                        elsif item.casecmp(REPOSITORY_TYPE) then
                            @type = value
                        end
                    end
                end
            }
        else
            File.open(DEFAULT_CONF_PATH, "w+") { |fd|
                fd << "<empty>\n"
            }
        end
    end

    def flush
        File.open(DEFAULT_CONF_PATH, "w+") { |fd|
            fd << DIRECTORY_LOCATION + " = #{@dir}\n"
            fd << REPOSITORY_TYPE + " = #{@type}\n"
        }
    end
end

