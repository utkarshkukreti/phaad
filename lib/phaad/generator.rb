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
      @indent_level = 0
      @indent_with = "  "
      process_statements @sexp.last, :indent => false
      @emitted.chomp!
    end

    def process_statements(array, options = {})
      indent unless options[:indent] == false
      array.each do |sexp|
        process(sexp)
        should_not_be = [ [:bodystmt, [[:void_stmt]], nil, nil, nil] ]
        first_should_not_be = [:void_stmt, :def, :bodystmt, :if, :else, :elsif,
          :unless, :while, :until, :while_mod, :until_mod, :if_mod, :unless_mod,
          :massign, :class, :for]
        emit ";\n" if !should_not_be.include?(sexp) && !first_should_not_be.include?(sexp.first)
      end
      outdent unless options[:indent] == false
    end

    def indent
      @indent_level += 1
    end

    def outdent
      @indent_level -= 1
    end

    def emit(*strings)
      strings.each do |string|
        @emitted << @indent_with * @indent_level if @emitted[-1] == "\n"
        @emitted << string
      end
    end

    def process(sexp)
      case sexp.first
      when :void_stmt
      when :@int, :@float
        emit sexp[1]
      when :@tstring_content
        emit "\"#{sexp[1].gsub('"', '\"')}\""
      when :string_content 
        if sexp.size > 1
          sexp[1..-1].each_with_index do |exp, i|
            unless exp[0] == :string_embexpr && exp[1][0][0] == :void_stmt
              process exp
              emit " . " if i < sexp.size - 2
            end
          end
        else
          emit '""'
        end
      when :string_literal
        process(sexp[1])
      when :string_embexpr
        process sexp[1][0]
      when :regexp_literal
        emit '"/'
        emit sexp[1][0][1]
        process sexp[2]
        emit '"'
      when :@regexp_end
        emit sexp[1]
      when :symbol_literal
        emit sexp[1][1][1].inspect
      when :dyna_symbol
        process(sexp[1][0])
      when :assign
        process(sexp[1])
        emit " = "
        process(sexp[2])
      when :massign
        lhs = sexp[1]
        rhs = sexp[2]

        # hack, no idea why is the sexp like this.
        rhs.shift if rhs.first == :mrhs_new_from_args
        rhs = rhs[0] + [rhs[1]]
        unless lhs.size == rhs.size
          raise NotImplementedError, sexp.inspect
        end

        lhs.zip(rhs).each do |l, r|
          process l
          emit " = "
          process r
          emit ";\n"
        end
      when :return
        emit "return "
        process sexp[1]
      when :var_field
        process(sexp[1])
      when :@ident
        no_dollar = ["__NAMESPACE__", "__DIR__", "__METHOD__", "__CLASS__", "__FUNCTION__"]
        emit "$" unless no_dollar.include?(sexp[1])
        emit sexp[1]
      when :@ivar
        emit "$this->"
        emit sexp[1][1..-1]
      when :@const
        emit sexp[1]
      when :method_add_arg
        if sexp[1][0] == :fcall && sexp[1][1][0] == :@ident
          emit sexp[1][1][1]
          emit "("
          process sexp[2][1] if sexp[2][1]
          emit ")"
        elsif sexp[1][0] == :call 
          process sexp[1]
          emit "("
          process sexp[2][1] if sexp[2][1]
          emit ")"
        else
          raise NotImplementedError, sexp.inspect
        end
      when :ifop
        process sexp[1]
        emit " ? "
        process sexp[2]
        emit " : "
        process sexp[3]
      when :command
        if sexp[1][0] == :@ident
          no_brackets = %w{global echo}
          emit sexp[1][1]
          emit no_brackets.include?(sexp[1][1]) ? " " : "("
          if sexp[2][0] == :args_add_block
            process sexp[2]
          else
            sexp[2].each(&method(:process))
          end
          emit ")" unless no_brackets.include?(sexp[1][1])
        else
          raise NotImplementedError, sexp.inspect
        end
      when :args_add_block
        sexp[1].each do |s|
          process s
          emit ", " unless s == sexp[1].last
        end
      when :call
        process sexp[1]
        emit "->"
        emit sexp[3][1]
      when :command_call
        if sexp[1][0] == :var_ref && sexp[1][1][0] == :@ident && sexp[2] == :"." && 
          sexp[3][0] == :@ident && sexp[4][0] == :args_add_block
          process sexp[1]
          emit "->"
          emit sexp[3][1]
          emit "("
          process sexp[4]
          emit ")"
        else
          raise NotImplementedError, sexp.inspect
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
      when :for
        if !sexp[1][0].is_a?(Array) && sexp[2][0] == :dot2 || sexp[2][0] == :dot3
          emit "for("
          process sexp[1]
          emit " = "
          process sexp[2][1]
          emit "; "
          process sexp[1]
          emit sexp[2][0] == :dot2 ? " <= " : " < "
          process sexp[2][2]
          emit "; "
          process sexp[1]
          emit "++"
        else
          emit "foreach("
          process sexp[2]
          emit " as "
          if !sexp[1][0].is_a?(Array)
            process sexp[1]
          elsif sexp[1][0].is_a?(Array) && sexp[1].size == 2
            process sexp[1][0]
            emit " => "
            process sexp[1][1]
          else
            raise NotImplementedError, sexp.inspect
          end
        end
        emit ") {\n"
        process_statements sexp[3]
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
      when :class
        if sexp[1][1][0] != :@const || (sexp[2] && sexp[2][1][0] != :@const)
          raise NotImplementedError, sexp.inspect
        end
        emit "class "
        emit sexp[1][1][1]
        emit " extends #{sexp[2][1][1]}" if sexp[2]
        emit " {\n"
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
      when :array, :hash
        emit "array("
        if sexp[1]
          if sexp[1][0] == :assoclist_from_args
            process sexp[1]
          else
            sexp[1].each_with_index do |param, i|
              process param
              emit ", " if i < sexp[1].size - 1
            end
          end
        end
        emit ")"
      when :assoclist_from_args
        sexp[1].each_with_index do |param, i|
          process param
          emit ", " if i < sexp[1].size - 1
        end
      when :assoc_new
        process sexp[1]
        emit " => "
        process sexp[2]
      when :bodystmt
        process_statements(sexp[1], :indent => false)
        # skip rescue and ensure
      when :paren
        emit "("
        if sexp[1].size == 1
          process sexp[1][0]
        else
          raise NotImplementedError, sexp.inspect
        end
        emit ")"
      when :aref_field
        process sexp[1]
        emit "["
        process sexp[2] if sexp[2]
        emit "]"
      when :aref
        process sexp[1]
        emit "["
        if sexp[2][1].size == 1
          process sexp[2] if sexp[2][1][0]
        else
          raise NotImplementedError, sexp.inspect
        end
        emit "]"
      when :unary
        case sexp[1]
        when :+@, :-@, :~, :'!'
          emit sexp[1].to_s[0]
          process sexp[2]
        else
          raise NotImplementedError, sexp.inspect
        end
      when :binary
        case sexp[2]
        when :+, :-, :*, :/, :%, :|, :&, :^, :'&&', :'||', :==, :'!=', :>, :<,
            :>=, :<=, :===
          process(sexp[1])
          emit " #{sexp[2]} "
          process(sexp[3])
        when :and
          process(sexp[1])
          emit " && "
          process(sexp[3])
        when :or
          process(sexp[1])
          emit " || "
          process(sexp[3])
        when :<<
          process(sexp[1])
          emit " . "
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
        # probably need to remove this
        if sexp[1][0] == :@kw
          case sexp[1][1]
          when 'false', 'true'
            emit sexp[1][1].upcase
          when 'nil'
            emit 'NULL'
          when '__FILE__', '__LINE__'
            emit sexp[1][1]
          else
            raise NotImplementedError, sexp.inspect
          end
        elsif sexp[1][0] == :@ident
          process sexp[1]
        elsif sexp[1][0] == :@ivar
          process sexp[1]
        elsif sexp[1][0] == :@const
          process sexp[1]
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
