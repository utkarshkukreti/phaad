module Phaad
  class CLI
    def initialize(argv)
      repl
    end

    ##
    # A very primitive repl. Only handles one lines.
    def repl
      require 'readline'

      puts "Type exit to exit."
      while (line = Readline::readline('> ')) != "exit"
        begin
          Readline::HISTORY.push line
          puts Phaad::Generator.new(line).emitted
        rescue Exception => e
          puts e
          p e.message
          puts e.backtrace
        end
      end
    end
  end
end
