require 'mongoid_cleaner/version'

# MongoidCleaner base module
module MongoidCleaner
  # strategy is unknown
  class UnknownStrategySpecified < ArgumentError; end

  class << self
    attr_reader :strategy

    def mongoid_version
      @mongoid_version ||= Mongoid::VERSION.split('.').first.to_i
    end

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

    def session
      @session ||= if mongoid_version > 4
                     Mongoid.default_client
                   else
                     Mongoid.default_session
                   end
    end

    # return with mongoid 5 `Mongo::Operation::Result`
    # return with mongoid 4 `BSON::Document`
    def collections_filter
      session.command(
        listCollections: 1,
        filter: {
          name:
          { '$not' => /.?system\.|\$/ }
        })
    end

    # @return Array mongoid collections names
    def collections
      if mongoid_version > 4
        collections_filter.first[:cursor][:firstBatch].map { |c| c['name'] }
      else
        collections_filter['cursor']['firstBatch'].map { |c| c['name'] }
      end
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
      collections_with_options.each { |c| session[c].drop }
      true
    end

    # @return Boolean
    def truncate
      if mongoid_version > 4
        collections_with_options.each { |c| session[c].find.delete_many }
      else
        collections_with_options.each { |c| session[c].find.remove_all }
      end
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
