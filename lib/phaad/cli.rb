module Phaad
  class CLI
    def initialize(argv)
      repl
    end

    ##
    # A very primitive repl. Only handles one lines.
    def repl
      puts "Type exit to exit."
      print "> "
      while (input = gets.chomp) != "exit"
        begin
          puts Phaad::Generator.new(input).emitted
        rescue Exception => e
          puts e
          p e.message
          puts e.backtrace
        end
        print "> "
      end
    end
  end
end
