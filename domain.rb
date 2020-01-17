class Domain
    def initialize(name,url, expiration_date='')
        @url = url
        @expiration_date = expiration_date
        @name = name
    end

    def url
        @url
    end

    def expiration_date=(expiration_date)
        @expiration_date = expiration_date
    end

    def name
        @name
    end

    def expiration_date
        @expiration_date
    end
end