# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0.  If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright 1997 - July 2008 CWI, August 2008 - 2020 MonetDB B.V.

require_relative 'MonetDBConnection'
require_relative 'MonetDBData'
require_relative 'MonetDBExceptions'

class MonetDB
	DEFAULT_USERNAME = "monetdb"
	DEFAULT_PASSWORD = "monetdb"
	DEFAULT_LANG     = MonetDBConnection::LANG_SQL
	DEFAULT_HOST     = "127.0.0.1"
	DEFAULT_PORT     = 50000
	DEFAULT_DATABASE = "test"
	DEFAULT_AUTHTYPE = "SHA1"
	DEFAULT_MIN_POOLS     = 1
	DEFAULT_MAX_POOLS     = 20

	@@CONNECTION_POOL = []

	def initialize(min_pools=DEFAULT_MIN_POOLS, max_pools=DEFAULT_MAX_POOLS)
		@min_pools = min_pools
		@max_pools = max_pools

		if min_pools < DEFAULT_MIN_POOLS
			min_pools = DEFAULT_MIN_POOLS
        elsif max_pools < min_pools
			raise "Max Pools cannot be less than min pools"
		end

		@connection = nil

        @@CONNECTION_POOL = Array.new(max_pools)
	end

	# Establish a new connection.
	#                * username: username (default is monetdb)
	#                * password: password (default is monetdb)
	#                * lang: language (default is sql)
	#                * host: server hostname or ip  (default is localhost)
	#                * port: server port (default is 50000)
	#                * db_name: name of the database to connect to
	#                * auth_type: hashing function to use during authentication (default is SHA1)
	def connect(username=DEFAULT_USERNAME, password=DEFAULT_PASSWORD, lang=DEFAULT_LANG, host=DEFAULT_HOST, port=DEFAULT_PORT, db_name=DEFAULT_DATABASE, auth_type=DEFAULT_AUTHTYPE)

		@username = username
		@password = password
		@lang = lang
		@host = host
		@port = port
		@db_name = db_name
		@auth_type = auth_type

		@connection = MonetDBConnection.new(user = @username, passwd = @password, lang = @lang, host = @host, port = @port)
		@connection.connect(@db_name, @auth_type)

		# FIXME: Ruby resizes the array.
		@@CONNECTION_POOL.append(@connection)
	end

	# Establish a new connection using named parameters.
	#                * user: username (default is monetdb)
	#                * passwd: password (default is monetdb)
	#                * language: lang (default is sql)
	#                * host: host to connect to  (default is localhost)
	#                * port: port to connect to (default is 50000)
	#                * database: name of the database to connect to
	#                * auth_type: hashing function to use during authentication (default is SHA1)
	#
	# Conventionally named parameters are passed as an hash.
	#
	# Ruby 1.8:
	# MonetDB::conn({ :user => "username", :passwd => "password", :database => "database"})
	#
	# Ruby 1.9:
	# MonetDB::conn(user: "username", passwd: "password", database: "database")
	def conn(options)
		user        = options[:user] || DEFAULT_USERNAME
		passwd      = options[:passwd] || DEFAULT_PASSWORD
		language    = options[:language] || DEFAULT_LANG
		host        = options[:host] || DEFAULT_HOST
		port        = options[:port] || DEFAULT_PORT
		database    = options[:database] || DEFAULT_DATABASE
		auth_type   = options[:auth_type] || DEFAULT_AUTHTYPE

		connect(user, passwd, language, host, port, database, auth_type)
	end

	# Send a <b> user submitted </b> query to the server and store the response.
	# Returns and instance of MonetDBData.
	def query(q="")
		if  @connection != nil
			@data = MonetDBData.new(@connection)
			@data.execute(q)
		end
		return @data
	end

	# Return true if there exists a "connection" object
	def is_connected?
		if @connection == nil
			return false
		else
			return true
		end
	end

	# Reconnect to the server
	def reconnect
		if @connection != nil
			self.close

			@connection = MonetDBConnection.new(user = @username, passwd = @password, lang = @lang, host = @host, port = @port)
			@connection.connect(db_name = @db_name, auth_type = @auth_type)
		end
	end

	# Turn auto commit on/off
	def auto_commit(flag=true)
		@connection.set_auto_commit(flag)
	end

	# Returns the current auto commit  (on/off) settings.
	def auto_commit?
		@connection.auto_commit?
	end

	# Returns the name of the last savepoint in a transactions pool
	def transactions
		@connection.savepoint
	end

	# Create a new savepoint ID
	def save
		@connection.transactions.save
	end

	# Release a savepoint ID
	def release
		@connection.transactions.release
	end

	# Close an active connection
	def close()
		@connection.disconnect
		@connection = nil
	end
end
