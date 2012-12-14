module DataMapper
  module Relation
    class Graph

      # Represents a relation in the registry graph
      #
      class Node
        include Enumerable, Equalizer.new(:name)

        def self.aliases(relation_name, attribute_set)
          entries = attribute_set.aliased_field_map(relation_name)
          index   = Aliases::Index.new(entries, aliasing_strategy)

          Aliases.new(index)
        end

        def self.aliasing_strategy
          Aliases::Strategy::NaturalJoin
        end

        private_class_method :aliasing_strategy

        # The node name
        #
        # @example
        #
        #   node = Node.new(:name)
        #   node.name
        #
        # @return [Symbol]
        #
        # @api public
        attr_reader :name

        # Instance of the engine's relation class
        #
        # @return [Object]
        #
        # @api private
        attr_reader :relation

        # Aliases for this relation
        #
        # @return [AliasSet]
        #
        # @api private
        attr_reader :aliases

        # Initializes a relation node instance
        #
        # @param [#to_sym] name
        #   the name for the node
        #
        # @param [Object] relation
        #   an instance of the engine's relation class
        #
        # @param [Aliases] aliases
        #   the aliases to use for this node
        #
        # @return [undefined]
        #
        # @api private
        def initialize(name, relation, aliases = {})
          @name     = name.to_sym
          @relation = relation
          @aliases  = aliases
        end

        # Iterate on relation
        #
        # @example
        #
        #   DataMapper.engines[:default].relations[:people].each do |tuple|
        #     puts tuple.inspect
        #   end
        #
        # @return [self, Enumerator]
        #
        # @yield [Object]
        #
        # @api public
        def each(&block)
          return to_enum unless block_given?
          @relation.each(&block)
          self
        end

        # Adds new object to the relation
        #
        # @example
        #
        #   tuple = { :name => 'John' }
        #   DataMapper.engines[:postgres].relations[:people].insert(tuple)
        #
        # @param [Object]
        #
        # @api public
        def insert(tuple)
          @relation.insert(tuple)
        end
        alias_method :<<, :insert

        # Updates an object identified with the given key from the relation
        #
        # @example
        #
        #   DataMapper.engines[:postgres].relations[:people].update(1, name: 'John')
        #
        # @param [Object] key attribute
        # @param [Object] tuple
        #
        # @api public
        def update(key, tuple)
          @relation.update(key, tuple)
        end

        # Deletes an object identified with the given key from the relation
        #
        # @example
        #
        #   DataMapper.engines[:postgres].relations[:people].delete(1)
        #
        # @param [Object] key attribute
        #
        # @api public
        def delete(key)
          @relation.delete(key)
        end

      end # class Node

    end # class Graph
  end # module Relation
end # module DataMapper
