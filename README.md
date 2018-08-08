# AstSearch

Ruby code analyzer powered by [parser](https://github.com/whitequark/parser) and [ast](https://github.com/whitequark/ast).

So far the public API is limited to a single function:
```ruby
AstSearch.find_external_classes(ruby_source)
```

It finds references to classes defined outside of the parsed source code, e.g.:
```
irb(main):001:0> class Foo
irb(main):002:1> end
=> nil
irb(main):003:0> AstSearch.find_external_classes <<-SRC
irb(main):004:0" class Bar
irb(main):005:0"   Foo.hello
irb(main):006:0" end
irb(main):007:0" SRC
=> [Foo]
```

### Hm, so how can it be useful?

You can build a rake task that scans database migrations for occurrences of model classes.
In case of a Rails app it would be something like this:
```ruby
task find_models_in_migrations: :environment do
  Dir[Rails.root.join("db/migrate/*.rb")].each do |path|
    models = AstSearch.find_external_classes(IO.read(path)).select do |klass|
      kalss != ActiveRecord::Base && klass.ancestors.include?(ActiveRecord::Base)
    end

    if models.any?
      puts path
      models.each { |model| puts model }
    end
  end
end
```

Though, the idea of looking something up in code is not limited to migrations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ast_search'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ast_search

## Usage

```ruby
require "ast_search"

source = IO.read("path/to/source_code.rb")

AstSearch.find_external_classes(source)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/letmein/ast_search.
