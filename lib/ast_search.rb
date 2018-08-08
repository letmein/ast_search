require "pry"
require "parser/current"

require "ast_search/version"
require "ast_search/name_path"
require "ast_search/node"
require "ast_search/queries/class_defs"
require "ast_search/queries/const_occurrences"
require "ast_search/queries/external_classes"

module AstSearch
  def self.parse(src)
    Parser::CurrentRuby.parse(src)
  end

  #
  # Public API
  #

  def self.find_external_classes(src)
    ast = parse(src)
    AstSearch::Queries::ExternalClasses.new.call(ast)
  end
end
