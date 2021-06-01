class ConnectionPool
	DEFAULT_MAX_POOLS     = 20

	@@POOL = []

    def initialize(max_pool = DEFAULT_MAX_POOLS)
        @@POOL = Array.new(max_pool)
    end

    def add(conn)
        @@POOL.push(conn)
    end

    def free(conn) 
        @@POOL.delete(conn)
    end

    def size()
        return @@POOL.length()
    end


end