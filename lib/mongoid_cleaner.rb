require 'mongoid_cleaner/version'

# MongoidCleaner base module
module MongoidCleaner
  # strategy is unknown
  class UnknownStrategySpecified < ArgumentError; end

  class << self
    attr_reader :strategy

    def available_strategies
      @available_strategies ||= %w(truncate drop)
    end

    # @arg args strategy String
    # @arg args options Hash
    def strategy=(*options)
      strategy = options.flatten.shift.to_s
      @options = options.flatten.last if options.flatten.last.is_a? Hash
      if available_strategies.include? strategy
        @strategy = strategy
      else
        fail UnknownStrategySpecified
      end
    end

    def client
      @client ||= Mongoid.default_client
    end

    # @return Array mongoid collections
    def collections
      client.command(
        listCollections: 1,
        filter: {
          name:
          { '$not' => /.?system\.|\$/ }
        }
      ).first[:cursor][:firstBatch].map { |c| c['name'] }
    end

    def collections_with_options
      return collections unless @options
      return collections if @options.empty?
      if @options[:only]
        collections.select { |c| @options[:only].include? c }
      elsif @options[:except]
        collections.select { |c| !@options[:except].include? c }
      end
    end

    # @return Boolean
    def drop
      collections_with_options.each { |c| client[c].drop }
      true
    end

    # @return Boolean
    def truncate
      collections_with_options.each { |c| client[c].find.delete_many }
      true
    end

    # call truncate or drop method
    def clean
      public_send strategy
    end

    def cleaning
      clean
      yield if block_given?
    end
  end
end
