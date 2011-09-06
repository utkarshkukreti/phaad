module Phaad
  class CLI
    def initialize(argv)
      @options = Slop.parse! argv, :help => true  do
        banner "Usage: phaad [options] [file]"
        on :c, :compile,      "Compile to PHP, and save as .php files"
        on :i, :interactive,  "Run an interactive Phaad REPL"
        on :s, :stdio,        "Fetch, compile, and print a Phaad script over stdio"
        on :e, :eval,         "Compile a string from command line", true
        on :w, :watch,        "Watch a Phaad file for changes, and autocompile"
        on :v, :version,      "Print Phaad version" do
          puts Phaad::VERSION
          exit
        end
      end

      if @options.interactive?
        repl
      elsif @options.eval?
        puts compile(@options[:eval])
      elsif @options.stdio?
        puts "<?php\n"
        puts compile(STDIN.readlines.join("\n"))
      elsif @options.compile?
        input_file = argv.shift
        output_file = input_file.sub(/\..*?$/, '.php')
        File.open(output_file, 'w') do |f|
          f << "<?php\n"
          f << compile(File.read(input_file))
        end
      elsif @options.watch?
        require 'fssm'

        input_file = argv.shift
        output_file = input_file.sub(/\..*?$/, '.php')
        FSSM.monitor(File.dirname(input_file), File.basename(input_file)) do
          update do
            puts ">>> Detected changes in #{input_file}"
            File.open(output_file, 'w') do |f|
              f << "<?php\n"
              begin
                f << Phaad::Generator.new(File.read(input_file)).emitted
                puts ">>> Compiled!"
              rescue Exception => e
                puts ">>> Error #{e}"
              end
            end
          end
        end
      else
        repl
      end
    end

    def compile(input)
      Phaad::Generator.new(input).emitted
    end

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
