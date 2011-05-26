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
      @sexp.last.each(&method(:process))
    end

    def emit(str)
      @emitted << str
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
      when :var_ref
        if sexp[1][0] == :@kw
           case sexp[1][1]
           when 'false', 'true'
             emit sexp[1][1].upcase
           when 'nil'
             emit 'NULL'
           else
             raise NotImplementedError, sexp
           end
        else
          # later
          raise NotImplementedError, sexp
        end
      else
        raise NotImplementedError, sexp.inspect
      end
    end
  end
end
