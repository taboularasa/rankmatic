# Rankmatic

## Problem scenario

You are running a contest with judged submissions.
Each submission is evaluated by three judges.
Judges evaluate submissions using a rubric with several factors.
You need to average the judges scores and then rank the list of submissions by their average scores.
You are also too lazy to deal with it.

*Rankmatic* to the rescue!!

Given `example.csv`:
```csv
email,funny,friendly,cool
foo@example.com,3,2,1
foo@example.com,1,2,1
foo@example.com,3,2,1
bar@example.com,10,20,30
bar@example.com,22,20,40
bar@example.com,30,40,90
baz@example.com,7,8,9
baz@example.com,1,2,3
baz@example.com,4,5,6
```

Run the following command

```shell
$ rank --group_by=email --csv_path=./example.csv

bar@example.com
baz@example.com
foo@example.com
```

You can also rank by just one column:

```ruby
$ rank --group_by=email --rank_by=friendly --csv_path=./example.csv
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rankmatic'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rankmatic

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rankmatic.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
