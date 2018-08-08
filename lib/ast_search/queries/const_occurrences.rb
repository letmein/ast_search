module AstSearch
  module Queries
    class ConstOccurrences
      def call(ast)
        traverse(ast, []).compact.uniq
      end

      private

      def traverse(ast, result)
        result + process_node(Node.new(ast), result)
      end

      def process_node(node, result)
        if node.const?
          [node.source]
        else
          traverse_children(node, result)
        end
      end

      def traverse_children(node, result)
        node.children.map { |child| traverse(child, result) }.flatten
      end
    end
  end
end
