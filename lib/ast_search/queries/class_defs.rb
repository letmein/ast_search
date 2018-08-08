module AstSearch
  module Queries
    class ClassDefs
      def call(ast)
        traverse(ast, [], NamePath.new).flatten.map(&:to_s)
      end

      private

      def traverse(ast, result, path)
        result + process_node(Node.new(ast), result, path)
      end

      def process_node(node, result, path)
        if node.module?
          traverse_children(node, result, path + node.name)
        elsif node.class?
          new_path = path + node.name
          [new_path] + traverse_children(node, result, new_path)
        else
          traverse_children(node, result, path)
        end
      end

      def traverse_children(node, result, path)
        node.children.map { |child| traverse(child, result, path) }.flatten
      end
    end
  end
end
