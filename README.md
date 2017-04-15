# GdatastoreMapper

GdatastoreMapper is a mapper framework for Google Cloud Datastore in Ruby / Ruby on Rails.
Once you install GdatastoreMapper you can use Google Cloud Datastore like ActiveRecord.

## Table of Contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Model Setting](#model-setting)
- [Persistence Methods](#persistence-methods)
- [Scoping Methods](#scoping-methods)
- [Timestamp](#timestamp)
- [Associations](#associations)
  - [One to Many](#one-to-many)
- [Development](#development)

## Requirements

GdatastoreMapper requires Rails version >= 4.2 (of course it's working for Rails 5)

google-cloud >= 0.27


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gdatastore_mapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gdatastore_mapper

## Configuration

GdatastoreMapper configuration can be done through a database.yml. The simplest configuration is as follows, which sets the emulator_host to "localhost:8444" and dataset_id.

```
# config/database.yml
production:
  dataset_id: your-google-cloud-platform-project-id

staging:
  dataset_id: your-google-cloud-platform-project-id

development:
  dataset_id: your-google-cloud-platform-project-id
  emulator_host: localhost:8444

test:
  dataset_id: your-google-cloud-platform-project-id
  emulator_host: localhost:8444
```

## Model Setting

Only 2 things you need to do.

1. To include GdatastoreMapper
2. To set attr_accessor as column

That's it! No need to db:migrate.

```ruby
class Book
  include GdatastoreMapper::Base

  attr_accessor :title, :author
end
```

## Persistence Methods

```
book = Book.new
book.title = 'Harry Potter'
book.save
```
```
book = Book.new(title: 'Harry Potter')
book.save
```
```
Book.create(title: 'Harry Potter')
```
```
book.update(title: 'Harry Potter 2')
```
```
book.delete
```

## Scoping Methods

```
Book.where(title: 'Harry Potter')
=> [#<Book:0x00 @created_at=2017-04-08 21:22:31 +0200, @title="Harry Potter",
    @id=70, @updated_at=2017-04-08 21:22:31 +0200>]
```
```
Book.find(12)
=> #<Book:0x00 @created_at=2017-04-07 10:03:54 +0200, @title="Harry Potter",
    @id=12, @updated_at=2017-04-07 22:57:57 +0200>
```
```
Book.find_by(title: 'Harry Potter')
=> #<Book:0x00 @created_at ....
```
```
Book.order(title: :asc)
=> [#<Book:0x00 @created_at .... ]
```

```
Book.first
=> #<Book:0x00 @created_at ....
```
```
Book.last
=> #<Book:0x00 @created_at ....
```
```
Book.count
=> 100
```
```
Book.all
=> [#<Book:0x00 @created_at .... ]
```

## Timestamp

All records have created_at and updated_at. They will be updated automatically.

## Associations

### One to Many

example of one to many relationship

```ruby
class Book
  include GdatastoreMapper::Base

  attr_accessor :title

  belongs_to :author
end
```

```ruby
class Author
  include GdatastoreMapper::Base

  attr_accessor :name

  has_many :books
end
```

books.create
```
rolling = Author.create(name: 'J K Rolling')
harry_poter = rolling.books.create(title: 'Harry Poter')
harry_poter2 = rolling.books.create(title: 'Harry Poter 2')
```
books
```
rolling.books
=> [#<Book:0x00 @created_at .... ]
```

books.count
```
rolling.books.count
=> 2
```
```
harry_poter.author
=> [#<Author:0x00 @created_at .... ]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shinyaK14/gdatastore_mapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

