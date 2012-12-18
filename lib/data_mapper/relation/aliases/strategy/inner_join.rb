module DataMapper
  module Relation
    class Aliases
      class Strategy

        class InnerJoin < self

          private

          def joined_entries(index, join_definition)
            super.
              update(clashing_entries(index, join_definition)).
              update(entries)
          end

        end # class InnerJoin

      end # class Strategy
    end # class Aliases
  end # module Relation
end # module DataMapper
