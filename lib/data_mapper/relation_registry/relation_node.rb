module DataMapper
  class RelationRegistry

    class RelationNode < Graph::Node
      attr_reader :relation

      attr_reader :aliases

      def initialize(name, relation, aliases = nil)
        super(name)
        @relation = relation
        @aliases  = aliases || AliasSet.new(name)
      end

      def for_relationship(relationship)
        clone(aliases.merge(aliases_for_relationship(relationship)))
      end

      def clone(aliases = nil)
        self.class.new(name, relation, aliases)
      end

      def join(other, relationship)
        relation.rename(aliases).join(other.relation_for_join(relationship)).optimize
      end

      def relation_for_join(relationship)
        relation.rename(aliases_for_relationship(relationship)).optimize
      end

      def aliases_for_relationship(relationship)
        aliases.exclude(relationship.target_key)
      end

    end # class RelationNode

  end # class RelationRegistry
end # module DataMapper
