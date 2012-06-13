require "rubygems/command"

module Gem
  module Commands
    class ExefyCommand < Gem::Command
      def initialize
        super 'exefy', "Replaces Gem's batch file with executable file (RubyInstaller installation only)"
        add_option('-b', '--backup-batch-files', 
               'Keep backup of old batch files') do |value, options|
          options[:backup_batch_files] = value
        end
      end

      def arguments
        "GEMNAME       name of gem to exefy"
      end

      def usage # :nodoc:
        "#{program_name} GEMNAME"
      end

      def execute
        begin
          require 'exefy'
        rescue ::LoadError => load_error
          say "You must have DevKit installed in order to exefy gems"
          return
        end

        unless RUBY_PLATFORM =~ /mingw/
          say "This command can be executed only on RubyInstaller Windows OS installation"
          return
        end

        get_all_gem_names.each do |name|
          begin
            cur_gem = Gem::Specification.find_by_name(name)
            Exefy.process_existing_gem(cur_gem,options)
          rescue Gem::LoadError => e
            say "Cannot exefy. Gem #{name} not found"
          end
        end
      end
    end
  end
end
