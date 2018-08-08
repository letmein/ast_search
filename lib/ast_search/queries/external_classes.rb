module AstSearch
  module Queries
    # A class is considered external when it is defined outside of the parsed class.
    class ExternalClasses
      def initialize
        @find_constants = ConstOccurrences.new
        @find_classes   = ClassDefs.new
      end

      def call(ast)
        (referred_constant_names(ast) - internal_class_names(ast))
          .map(&:constantize).compact.uniq.select { |const| const.is_a?(Class) }
      end

      private

      attr_reader :find_constants, :find_classes

      def referred_constant_names(ast)
        find_constants.call(ast).map { |name| to_path(name) }
      end

      def internal_class_names(ast)
        find_classes.call(ast).flatten.slice(1..-1).map { |name| to_path(name).shift }
      end

      def to_path(str)
        NamePath.from_string(str)
      end
    end
  end
end
