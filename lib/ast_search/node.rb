module AstSearch
  class Node
    def initialize(ast)
      @ast = ast
    end

    attr_reader :ast

    def const?
      type == :const
    end

    def class?
      type == :class
    end

    def module?
      type == :module
    end

    def name
      return unless ast.loc.respond_to?(:name)
      ast.loc.name.source
    end

    def source
      ast.loc.expression.source
    end

    def children
      return [] unless ast.respond_to?(:children)
      ast.children
    end

    private

    def type
      return nil unless ast.respond_to?(:type)
      ast.type
    end
  end
end
