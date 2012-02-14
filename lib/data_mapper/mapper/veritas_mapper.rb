module DataMapper
  class Mapper

    # VeritasMapper
    #
    # @api public
    class VeritasMapper < Mapper

      # @api public
      def self.base_relation
        @base_relation ||= Veritas::Relation::Base.new(name, attributes.header)
      end

      # @api private
      attr_reader :relation

      # @api private
      attr_reader :model

      # @api private
      attr_reader :attributes

      private :relation, :model, :attributes

      # Initialize a veritas mapper instance
      #
      # @param [Veritas::Relation]
      #
      # @return [undefined]
      #
      # @api public
      def initialize(relation)
        @relation   = relation
        @attributes = self.class.attributes
        @model      = self.class.model
      end

      # @api public
      def each
        return to_enum unless block_given?
        relation.each { |tuple| yield load(tuple) }
        self
      end

      # @api private
      def load(tuple)
        model.new(attributes.map(tuple))
      end

    end # class VeritasMapper
  end # class Mapper
end # module DataMapper
