# CustomCopsGenerator

A generator of RuboCop's custom cops gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'custom_cops_generator'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install custom_cops_generator

## Usage

```
$ custom_cops_generator rubocop-foobar
Creating gem 'rubocop-foobar'...
      create  rubocop-foobar/Gemfile
      create  rubocop-foobar/lib/rubocop/foobar.rb
      create  rubocop-foobar/lib/rubocop/foobar/version.rb
      create  rubocop-foobar/rubocop-foobar.gemspec
      create  rubocop-foobar/Rakefile
      create  rubocop-foobar/README.md
      create  rubocop-foobar/bin/console
      create  rubocop-foobar/bin/setup
      create  rubocop-foobar/.gitignore
Initializing git repo in /tmp/tmp.Gu7G94wX00/rubocop-foobar
Gem 'rubocop-foobar' was successfully created. For more information on making a RubyGem visit https://bundler.io/guides/creating_gem.html
create rubocop-foobar/lib/rubocop-foobar.rb
create rubocop-foobar/lib/rubocop/foobar/inject.rb
create rubocop-foobar/lib/rubocop/cop/foobar_cops.rb
create rubocop-foobar/config/default.yml
create rubocop-foobar/spec/spec_helper.rb
create rubocop-foobar/.rspec
update lib/rubocop/foobar.rb
update lib/rubocop/foobar.rb
update lib/rubocop/foobar/version.rb
update rubocop-foobar.gemspec
update rubocop-foobar.gemspec
update Rakefile
update Gemfile

It's done! You can start developing a new extension of RuboCop in rubocop-foobar.
For the next step, you can use the cop generator.

  $ bundle exec rake 'new_cop[Foobar/SuperCoolCopName]'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/custom_cops_generator.

