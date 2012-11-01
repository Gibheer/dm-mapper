module DataMapper
  class Relationship

    class OneToMany < self

      module Iterator

        # @api public
        #
        # TODO: refactor this and add support for multi-include
        def each
          return to_enum unless block_given?

          tuples     = @relation.to_a
          parent_key = @attributes.key
          name       = @attributes.detect { |attribute|
            attribute.kind_of?(Mapper::Attribute::EmbeddedCollection)
          }.name

          parents = tuples.each_with_object({}) do |tuple, hash|
            key = parent_key.map { |attribute| tuple[attribute.field] }
            hash[key] = @attributes.primitives.each_with_object({}) { |attribute, parent|
              parent[attribute.field] = tuple[attribute.field]
            }
          end

          parents.each do |key, parent|
            parent[name] = tuples.map do |tuple|
              current_key = parent_key.map { |attribute| tuple[attribute.field] }
              if key == current_key
                tuple
              end
            end.compact
          end

          parents.each_value { |parent| yield(load(parent)) }
          self
        end
      end # module Iterator

      # TODO: add spec
      def collection_target?
        true
      end

      # @see Options#default_source_key
      #
      def default_source_key
        :id
      end

      # @see Options#default_target_key
      #
      def default_target_key
        self.class.foreign_key_name(source_model.name)
      end
    end # class OneToMany
  end # class Relationship
end # module DataMapper
