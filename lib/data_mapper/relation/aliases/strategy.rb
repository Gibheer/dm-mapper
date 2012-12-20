module DataMapper
  module Relation
    class Aliases

      class Strategy

        include AbstractType

        # Initialize a new instance
        #
        # @param [Index] index
        #   the index used by this instance
        #
        # @return [undefined]
        #
        # @api private
        def initialize(index)
          @index   = index
          @entries = @index.entries
        end

        # Join two {Index} instances
        #
        # @param [Index] index
        #   the index to join with the instance's own index
        #
        # @param [Relationship::JoinDefinition] join_definition
        #   the attributes to use for joining
        #
        # @return [Index]
        #
        # @api private
        def join(index, join_definition, relation_aliases)
          new_index(joined_entries(index, join_definition.to_hash, relation_aliases))
        end

        private

        attr_reader :entries

        def joined_entries(index, _join_definition, relation_aliases)
          index.entries.dup
        end

        def join_key_entries(index, join_definition, relation_aliases)
          with_index_entries(index) { |key, name, new_entries|
            join_definition.each do |left_key, right_key|
              if name.field == right_key
                new_entries[key] = Attribute.build(left_key, name.prefix)
              end
            end
          }
        end

        def clashing_entries(index, join_definition, relation_aliases)
          with_index_entries(index) { |key, name, new_entries|
            if clashing?(name, join_definition)
              new_entries[key] = Attribute.build(key.field, key.prefix, true)
            end
          }
        end

        def clashing?(name, _join_definition)
          @index.field?(name.field)
        end

        def with_index_entries(index)
          index.entries.each_with_object({}) { |(key, name), new_entries|
            yield(key, name, new_entries)
          }
        end

        def new_index(new_entries)
          @index.class.new(new_entries, self.class)
        end

      end # class Strategy

    end # class Aliases
  end # module Relation
end # module DataMapper
