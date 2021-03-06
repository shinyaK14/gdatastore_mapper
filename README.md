# GdatastoreMapper
[![CircleCI](https://circleci.com/gh/shinyaK14/gdatastore_mapper/tree/master.svg?style=svg)](https://circleci.com/gh/shinyaK14/gdatastore_mapper/tree/master)  [![Gem Version](https://badge.fury.io/rb/gdatastore_mapper.svg)](https://badge.fury.io/rb/gdatastore_mapper)

GdatastoreMapper is a mapper framework for Google Cloud Datastore in Ruby / Ruby on Rails.
Once you install GdatastoreMapper you can use Google Cloud Datastore like ActiveRecord.

## Table of Contents
- [Demo](#demo)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Model Setting](#model-setting)
- [Persistence Methods](#persistence-methods)
- [Scoping Methods](#scoping-methods)
- [Timestamp](#timestamp)
- [Associations](#associations)
  - [One to Many](#one-to-many)
  - [Method Chaining](#method-chaining)
- [Callbacks](#callbacks)
- [Validations](#validations)
- [Contact](#contact)
- [Development](#development)

## Demo

Here is [demo](https://gdatastore-mapper.herokuapp.com/). The demo works with Google Cloud Datastore.

Source code is [here](https://github.com/shinyaK14/gdatastore_mapper/tree/master/rails_example).

## Requirements

GdatastoreMapper requires Rails version >= 5


## Installation

Execute rails new with --skip-active-record
```
$ rails new your_project --skip-active-record
```

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

new record

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

update

```
book.update(title: 'Harry Potter 2')
```

delete

```
book.delete
```
```
Book.delete_all
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
=> #<Book:0x00 @title="Harry Potter" ....
```
```
Book.order(title: :asc)
=> [#<Book:0x00 @title="Harry Potter" .... ]
```

```
Book.first
=> #<Book:0x00 @title="Harry Potter" ....
```
```
Book.last
=> #<Book:0x00 @title="Harry Potter" ....
```
```
Book.count
=> 100
```
```
Book.all
=> [#<Book:0x00 @title="Harry Potter" .... ]
```

## Timestamp

All records have created_at and updated_at. They will be updated automatically.

## Associations

### One to Many
Associations can be set the same as Active Record.

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
rowling = Author.create(name: 'J. K. Rowling')
harry_poter = rolling.books.create(title: 'Harry Poter')
harry_poter2 = rolling.books.create(title: 'Harry Poter 2')
```
books
```
rowling.books
=> [#<Book:0x00 @title="Harry Potter" .... ]
```

books.count
```
rowling.books.count
=> 2
```
```
harry_poter.author
=> [#<Author:0x00 @name="J. K. Rowling" .... ]
```
### Method Chaining

```
rowling.books.order(created_at: :desc).limit(3)
=> [#<Book:0x00 @title="Harry Potter" .... ]
```
```
rowling.books.where(series: 'Harry Potter').order(published_at: :asc).limit(3)
=> [#<Book:0x00 @title="Harry Potter" .... ]
```

## Callbacks

```ruby
class Book
  include GdatastoreMapper::Base

  before_save :something_before_save

  private
  def something_before_save
    something that you want
  end

end
```

## Validations

```ruby
class Author
  include GdatastoreMapper::Base

  attr_accessor :email

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :email, length: { in: 3..20 }
  validates_uniqueness_of :email
end
```


## Contact

Please shoot me an e-mail if you find any issues, ideas and comments. shinya.kitamura.14@gmail.com
Thanks!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shinyaK14/gdatastore_mapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

