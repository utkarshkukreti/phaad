module Phaad
  class CLI
    def initialize(argv)
      repl
    end

    ##
    # A very primitive repl. Only handles one lines.
    def repl
      require 'readline'

      puts "Type exit or press Ctrl-D to exit."
      lines = ""
      loop do
        prompt = lines.size == 0 ? '> ' : '>> '
        line = Readline::readline(prompt)

        exit if line.nil? || line == "exit" && lines.size == 0

        lines << line + "\n"
        Readline::HISTORY.push line

        if valid_expression?(lines)
          begin
            puts Phaad::Generator.new(lines).emitted
          rescue Exception => e
            puts e
            p e.message
            puts e.backtrace
          ensure
            lines = ""
          end
        end
      end
    end

    def valid_expression?(lines)
      !!Ripper.sexp(lines)
    end
  end
end
