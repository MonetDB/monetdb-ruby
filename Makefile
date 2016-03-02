VERSION = 1.0

monetdb-sql-$(VERSION).gem: monetdb-sql.gemspec \
		lib/MonetDB.rb lib/MonetDBConnection.rb \
		lib/MonetDBData.rb lib/MonetDBExceptions.rb lib/hasher.rb
	gem build $<

clean:
	rm -f *.gem
