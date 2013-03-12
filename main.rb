#!/usr/bin/ruby

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

require 'optparse'

conf = OpenConf.new

opts = OptionParser.new do |opts|
    opts.banner = "This is SyncConf, a configuration manager!\n\n"
    opts.banner << "Usage: syncconf [options]\n\n"

    opts.on("-c", "--conf FILE", "Change the default SyncConf configuration file.") do |conf|
        conf.file = conf
    end

    opts.on("-d", "--directory DIR", "Change the checkout directory.") do |dir|
        conf.write(dir)
    end

    opts.on_tail("-h", "--help", "Prints this help!") do
        puts opts
        exit
    end
end

opts.parse!(ARGV)


