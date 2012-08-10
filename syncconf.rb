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
require 'optparse'

VERSION = 0.1

# Declaration of constants to use with the saved data.
ADDRESS_OPTION = "server_address"
USERNAME_OPTION = "username"
NAME_OPTION = "name"
SAVED_FILE_OPTION = "saved_file"

# Stores and manipulates useful info for the tool. This class creates the a
# file located at the user HOME directory.
class SavedData
    def initialize ()
        home = %x[echo $HOME]
        home.chomp!
        @file = "#{home}/.syncconfrc"
    end

    # This function will create a brand new file for storing informations
    # about the user. NOTE: this will ERASE the current file and CREATE a
    # new one. This was done purposedly!
    def create (addr, user, name)
        fd = File.new(@file, "w+")
        fd << ADDRESS_OPTION + " = #{addr}\n"
        fd << USERNAME_OPTION + " = #{user}\n"
        fd << NAME_OPTION + " = #{name}\n"
        fd.close
    end
end


# A class encapsulating the methods to fetch, send and add files to
# SyncConf.
class ProcessCommand
    def initialize (cmd)
        @command = cmd

        @sd = SavedData.new

        @user = "default"
        @addr = "my-addr"
        @name = "my-things"

        @options = nil
    end

    def user= (u)
        @user = u
    end

    def addr= (a)
        @addr = a
    end

    def name= (n)
        @name = n
    end

    def options= (opts)
        @options = opts
    end

    # Straight forward: prints the help text for the tool.
    def print_help ()
        puts @options
    end

    # Uses algorithms to get the stored data.
    def fetch_conf ()
        %[scp #{@user}@#{@addr}:~/#{@name}/file]
    end

    # Executes a configured command.
    def execute ()
        case @command
            when "help"
                print_help
            when "start"
                @sd.create(@addr, @user, @name)
            when "fetch"
                fetch_conf
            else
                puts "Unknown/Invalid command: \"#{@command}\"!"
                puts ""
                print_help
        end
    end
end

# === MAIN ===

# The first argument *MUST BE* the command to execute.
if ARGV.length > 0 and not ARGV[0] =~ /^-/ then
    cmd = ARGV[0]
    arguments = ARGV[1..ARGV.length - 1] # Exclude the first argument.
else
    puts "Missing command!"
    cmd = "help"
    arguments = ARGV
end

pc = ProcessCommand.new(cmd)

opts = OptionParser.new do |opts|
    opts.banner = "This is SyncConf, version #{VERSION}!\n\n"
    opts.banner << "Usage: syncconf <command> [options]\n\n"
    opts.banner << "Commands available:\n"
    opts.banner << "    start\tStart synchronizing configurations.\n"
    opts.banner << "    fetch\tFetch remote configuration files.\n"
    opts.banner << "    send\tSend configuration to a remote repository.\n"
    opts.banner << "    add \tAdd a configuration file to the backup system.\n"

    opts.separator ""
    opts.separator "Options available:"

    opts.on("-u", "--user USERNAME", "Username of the remote directory.") do |user|
        pc.user = user
    end

    opts.on("-a", "--addr ADDRESS", "Address where to save configurations.") do |addr|
        pc.addr = addr
    end

    opts.on("-n", "--name NAME", "The label for the configurations saved.") do |name|
        pc.name = name
    end

    opts.on_tail("-h", "--help", "Prints this help!") do
        pc.print_help
        exit
    end
end

opts.parse!(arguments)

pc.options = opts

pc.execute

