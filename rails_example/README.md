# Gdatastore Mapper Rails example

Source code of Gdatastore Mapper Rails example. 

Here is [demo](https://gdatastore-mapper-sample.appspot.com/)

## Versions

Ruby 2.3.3

Rails 5.0.2

google-cloud 0.28.0

# Model Association

In the application containing authors and books, the author model has many books. The book belongs to author.


```ruby
# app/models/author.rb
class Author
  include GdatastoreMapper::Base

  attr_accessor :name

  has_many :books

  validates :name, presence: true
end
```

```ruby
class Book
  include GdatastoreMapper::Base

  attr_accessor :title, :description

  belongs_to :author

  validates :title, presence: true
end
```

![has_many](https://cloud.githubusercontent.com/assets/9897663/25094991/e71472b4-2399-11e7-9b3d-d612b6f1e742.png)
