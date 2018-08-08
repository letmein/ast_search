# frozen_string_literal: true

module AstSearch
  class NamePath
    SEPARATOR = "::"

    def self.from_string(str)
      new(str.split(SEPARATOR))
    end

    def initialize(path = [])
      @path = path
    end

    def +(path_element)
      new_path = path.dup.push(path_element)
      NamePath.new(new_path)
    end

    def eql?(other)
      to_a == other.to_a
    end

    def hash
      path.hash
    end

    def shift
      NamePath.new(path[1..-1])
    end

    def blank?
      path.size.zero?
    end

    def to_a
      path
    end

    def to_s
      @_to_s ||= path.join(SEPARATOR)
    end

    def constantize
      if to_s.respond_to?(:constantize)
        # NOTE: ActiveSupport's `constantize` behaves slightly different from `Object.const_get`
        to_s.constantize
      else
        Object.const_get(to_s)
      end
    rescue NameError
      nil
    end

    private

    attr_reader :path
  end
end
