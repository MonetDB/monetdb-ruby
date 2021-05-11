# MonetDB-Ruby

Ruby driver for MonetDB

## Installation

First build a gem file starting from the given gemspec:

```bash
$ gem build ruby-monetdb-sql.gemspec
```

Then install the resulting gem with the command:

```bash
$ gem install --local ruby-monetdb-sql-1.2.gem
```

## Example
```ruby
require_relative 'MonetDB'

conn = MonetDB.new
conn.connect(user = "monetdb", passwd = "monetdb", lang = "sql", host="127.0.0.1", port = 50000, database_connection_name = "demo", auth_type = "SHA1")

result =conn.query("SELECT 1")

result.each_record do |record|
  puts record
end
```

A more extensive example can be found in /lib/example.rb
