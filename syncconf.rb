# Copyright            2012        Bryan Garber da Silva

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

# Inserting command line processing.
require 'commandline/optionparser'
include CommandLine

VERSION = 0.1

# Declaration of constants to use with the saved data.
HOST_OPTION = "host"
USERNAME_OPTION = "username"
NAME_OPTION = "name"
SAVED_FILE_OPTION = "saved_file"

class SavedData
    def initialize ()
        home_dir = %[echo $HOME]
        @file = "#{home_dir}/.syncconfrc"
    end

    def create (host, user, name)
        fd = File.new(@file, "w+") # This will truncate the file
        fd << HOST_OPTION + " = #{host}")
        fd << USERNAME_OPTION + " = #{user}")
        fd << NAME_OPTION + " = #{name}")
        fd.close
    end
end

class ProcessCommand
    def initialize ()
        @command = "help"
        @options = Array.new #Start an empty array for the command options

        @sd = SavedData.new

        @user = "default"
        @host = "my-host"
        @name = "my-things"
    end

    def print_help ()
        puts "This is SyncConf, version #{VERSION}!"
        puts ""
        puts "Usage: syncconf <command> [options]"
        puts ""
        puts "    help\tPrint this help guide."
        puts "    start\tStart synchronizing configurations."
        puts "    fetch\tFetch remote configuration files."
        puts "    send\tSend configuration to a remote repository."
        puts "    add\tAdd a configuration file to the backup system."
    end

    def command= (cmd)
        @command = cmd
    end

    def fetch_conf ()
        %[scp #{@user}@#{@host}:~/#{@name}/file]
    end

    def execute ()
        case @command
            when "help"
                print_help
            when "start"
                @sd.create
            when "fetch"
                fetch_conf
            else
                puts "Unknown/Invalid command!"
                puts ""
                print_help
        end
    end
end

pc = ProcessCommand.new()

if ARGV.length == 0 then
    pc.print_help
end

# Process the command line argumens; this can improve.
ARGV.length.times { |i|
    if i == 0 then # The first one is the command
        pc.command = ARGV[i]
    end
}


pc.execute

