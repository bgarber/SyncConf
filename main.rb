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
require './OpenConf.rb'

CHECKOUT_TYPE_GIT = "git"
CHECKOUT_TYPE_SVN = "svn"

conf = OpenConf.new

do_conf_flush = false

opts = OptionParser.new do |opts|
    opts.banner = "This is SyncConf, a configuration manager!\n\n"
    opts.banner << "Usage: syncconf [options]\n"

    opts.on("-d", "--directory DIR", "Change the checkout directory.") do |d|
        conf.dir = d
        do_conf_flush = true
    end

    opts.on("-t", "--type TYPE", "Type of the checkout: git or svn.") do |t|
        if t.casecmp(CHECKOUT_TYPE_GIT) == 0 or t.casecmp(CHECKOUT_TYPE_SVN) == 0
            conf.type = t
            do_conf_flush = true
        else
            puts "Type not recognized: #{t}"
            exit
        end
    end

    opts.on_tail("-h", "--help", "Prints this help!") do
        puts opts
        exit
    end
end

opts.parse!(ARGV)

if do_conf_flush then
    conf.flush
end

if conf.dir == "" or conf.type == "" then
    puts "Could not identify any directory or checkout type!"
    puts "Configured directory: #{conf.dir}"
    puts "Configured repository type: #{conf.type}"
    puts "Try calling SyncConf with \"-d\" and/or \"-c\" parameters."
    puts "For more information, type:"
    puts "\tsyncconf -h"
    exit
end

