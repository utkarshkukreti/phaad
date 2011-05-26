module Phaad
  NotImplementedError = Class.new(StandardError)

  class Generator
    attr_reader :emitted, :sexp

    def initialize(str_or_sexp, &blk)
      if block_given?
        raise NotImplementedError, "blocks aren't implemented yet"
      elsif str_or_sexp.is_a?(Array)
        @sexp = str_or_sexp
      else
        @sexp = Ripper.sexp(str_or_sexp)
      end

      @emitted = ""
      process_statements @sexp.last
    end

    def process_statements(array)
      array.each do |sexp|
        process(sexp)
        emit ";\n"
      end
    end

    def emit(*strings)
      strings.each do |string|
        @emitted << string
      end
    end

    def process(sexp)
      case sexp.first
      when :void_stmt
      when :@int, :@float
        emit sexp[1]
      when :@tstring_content
        "\"#{sexp[1]}\""
      when :string_content 
        process sexp[1]
      when :string_literal
        emit process(sexp[1])
      when :regexp_literal
        emit "\"/#{sexp[1][0][1]}#{process(sexp[2])}\""
      when :@regexp_end
        sexp[1]
      when :symbol_literal
        emit sexp[1][1][1].inspect
      when :dyna_symbol
        emit process(sexp[1][0])
      when :assign
        process(sexp[1])
        emit " = "
        process(sexp[2])
      when :var_field
        process(sexp[1])
      when :@ident
        emit "$"
        emit sexp[1]
      when :method_add_arg
        if sexp[1][0] == :fcall && sexp[1][1][0] == :@ident
          emit sexp[1][1][1]
          emit "("
          process sexp[2][1] if sexp[2][1]
          emit ")"
        else
          raise NotImplementedError, sexp.inspect
        end
      when :command
        if sexp[1][0] == :@ident
          emit sexp[1][1]
          emit "("
          if sexp[2][0] == :args_add_block
            process sexp[2]
          else
            sexp[2].each(&method(:process))
          end
          emit ")"
        else
          raise NotImplementedError, sexp.inspect
        end
      when :args_add_block
        sexp[1].each do |s|
          process s
          emit ", " unless s == sexp[1].last
        end
      when :if, :elsif, :unless
        if sexp.first == :if
          emit "if("
        elsif sexp.first == :unless
          emit "if(!("
        else
          emit "elseif("
        end
        process sexp[1]
        emit ")" if sexp.first == :unless
        emit ") {\n"
        process_statements(sexp[2])
        emit "}"
        if sexp[3]
          emit " "
          process sexp[3]
        else
          emit "\n"
        end
      when :else
        emit "else {\n"
        process_statements(sexp[1]) if sexp[1]
        emit "}\n"
        process sexp[3] if sexp[3]
      when :if_mod, :unless_mod
        emit "if("
        emit "!(" if sexp.first == :unless_mod
        process sexp[1]
        emit ")" if sexp.first == :unless_mod
        emit ") {\n"
        process_statements [sexp[2]]
        emit "}\n"
      when :while, :until
        emit "while("
        emit "!(" if sexp.first == :until
        process sexp[1]
        emit ")" if sexp.first == :until
        emit ") {\n"
        process_statements sexp[2]
        emit "}\n"
      when :while_mod, :until_mod
        emit "while("
        emit "!(" if sexp.first == :until_mod
        process sexp[1]
        emit ")" if sexp.first == :until_mod
        emit ") {\n"
        process_statements [sexp[2]]
        emit "}\n"
      when :def
        raise NotImplementedError, sexp.inspect unless sexp[1][0] == :@ident
        emit "function "
        emit sexp[1][1]
        emit "("
        if sexp[2][0] == :params
          process sexp[2] # params
        elsif sexp[2][0] == :paren && sexp[2][1][0] == :params
          process sexp[2][1]
        else
          raise NotImplementedError, sexp.inspect
        end
        emit ") {\n"
        process_statements [sexp[3]]
        emit "}\n"
      when :params
        first = true
        if sexp[1]
          sexp[1].each do |param|
            emit ", " unless first
            first = false

            process param
          end
        end

        if sexp[2]
          sexp[2].each do |param|
            emit ", " unless first
            first = false

            process param[0]
            emit " = "
            process param[1]
          end
        end
      when :bodystmt
        process_statements(sexp[1])
        # skip rescue and ensure
      when :paren
        emit "("
        if sexp[1].size == 1
          process sexp[1][0]
        else
          raise NotImplementedError, sexp.inspect
        end
        emit ")"
      when :binary
        case sexp[2]
        when :+, :-, :*, :/, :%, :|, :&, :^, :'&&', :'||', :==, :'!=', :>, :<,
            :>=, :<=, :===
          process(sexp[1])
          emit " #{sexp[2]} "
          process(sexp[3])
        when :**
          emit "pow("
          process(sexp[1])
          emit ", "
          process(sexp[3])
          emit ")"
        when :=~
          emit "preg_match("
          process(sexp[3])
          emit ", "
          process(sexp[1])
          emit ")"
        when :'!~'
          emit "!preg_match("
          process(sexp[3])
          emit ", "
          process(sexp[1])
          emit ")"
        else
          raise NotImplementedError, sexp.inspect
        end
      when :var_ref
        if sexp[1][0] == :@kw
          case sexp[1][1]
          when 'false', 'true'
            emit sexp[1][1].upcase
          when 'nil'
            emit 'NULL'
          else
            raise NotImplementedError, sexp.inspect
          end
        elsif sexp[1][0] == :@ident
          emit "$", sexp[1][1]
        else
          # later
          raise NotImplementedError, sexp.inspect
        end
      else
        raise NotImplementedError, sexp.inspect
      end
    end
  end
end
