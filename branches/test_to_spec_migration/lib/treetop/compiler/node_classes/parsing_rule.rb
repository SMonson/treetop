module Treetop
  module Compiler
    class ParsingRule < Runtime::SyntaxNode

      def compile(builder)
        compile_inline_module_declarations(builder)
        generate_method_definition(builder)
      end
      
      def compile_inline_module_declarations(builder)
        parsing_expression.inline_modules.each_with_index do |inline_module, i|
          inline_module.compile(i, self, builder)
          builder.newline
        end
      end
      
      def generate_method_definition(builder)
        builder.reset_addresses
        expression_address = builder.next_address
        result_var = "r#{expression_address}"
        
        builder.method_declaration(method_name) do
          builder.assign 'start_index', 'index'
          generate_cache_lookup(builder)
          builder.newline
          parsing_expression.compile(expression_address, builder)
          builder.newline
          generate_cache_storage(builder, result_var)
          builder.newline          
          builder << "return #{result_var}"
        end
      end
      
      def generate_cache_lookup(builder)
        builder.assign 'cached', "node_cache[:#{name}][index]"
        builder.if_ 'cached' do
          builder << '@index = cached.interval.end'
          builder << 'return cached'
        end
      end
      
      def generate_cache_storage(builder, result_var)
        builder.assign "node_cache[:#{name}][start_index]", result_var
      end
      
      def method_name
        "_nt_#{name}"
      end
      
      def name
        nonterminal.text_value
      end
    end
  end
end