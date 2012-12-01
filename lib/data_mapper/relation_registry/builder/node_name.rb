module DataMapper
  class RelationRegistry
    class Builder

      # Represents a joined relation node name
      #
      class NodeName

        include Equalizer.new(:left, :right, :relationship)

        # Separator used to split left/right sides
        SEPARATOR = '_X_'.freeze

        # The left relation name used to construct the name
        #
        # @return [#to_sym]
        #
        # @api private
        attr_reader :left

        # The right relation name used to construct the name
        #
        # @return [#to_sym]
        #
        # @api private
        attr_reader :right

        # The relationship used to construct the name
        #
        # @return [Relationship]
        #
        # @api private
        attr_reader :relationship

        # The operation attached to {#relationship}
        #
        # @see Relationship#operation
        #
        # @return [Proc]
        #
        # @api private
        attr_reader :operation

        # The {#relationship}'s target model
        #
        # @see Relationship#target_model
        #
        # @return [Class]
        #
        # @api private
        attr_reader :target_model

        # Initialize a node name
        #
        # @param [#to_sym] left
        #   the left relation name used to construct the name
        #
        # @param [#to_sym] right
        #   the right relation name used to construct the name
        #
        # @param [Relationship] relationship
        #   the relationship used to construct the name
        #
        # @return [undefined]
        #
        # @api private
        def initialize(left, right, relationship)
          @left         = left
          @right        = right
          @relationship = relationship
          @operation    = @relationship.operation
          @target_model = @relationship.target_model
        end

        # Coerce the name to a string
        #
        # @return [String]
        #
        # @api private
        def to_s
          to_a.join(SEPARATOR)
        end

        # Coerce the name to a symbol
        #
        # @return [Symbol]
        #
        # @api private
        def to_sym
          to_s.to_sym
        end

        # Coerce the name to an array
        #
        # @return [Array]
        #
        # @api private
        def to_a
          [ left.to_sym, right.to_sym ]
        end
      end # class NodeName
    end # class Builder
  end # class RelationRegistry
end # module DataMapper
