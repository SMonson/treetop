module Treetop
  module Compiler    
    class Terminal < AtomicExpression
      def compile(address, builder, parent_expression = nil)
        super
        assign_result "parse_terminal(#{text_value}, #{node_class_name}#{optional_arg(inline_module_name)})"
      end
    end
 end
end