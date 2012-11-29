module DataMapper
  class RelationRegistry
    class RelationEdge < Graph::Edge

      class VeritasEdge < self

        def initialize(*)
          super

          @target_aliases = target_node.aliases
          @source_aliases = source_node.aliases.join(@target_aliases, join_definition)

          @source_relation = source_node.relation.rename(@source_aliases)
          @target_relation = target_node.relation.rename(@target_aliases)

          @aliases = @source_aliases
        end

        # Builds a joined relation from source and target nodes
        #
        # @return [RelationNode::VeritasRelation]
        #
        # @api private
        def node(relationship, operation = relationship.operation)
          node_class.new(name, join_relation(operation), @aliases)
        end

        private

        def join_relation(operation)
          relation = @source_relation.join(@target_relation)
          if operation
            relation = relation.instance_eval(&operation)
          end
          relation
        end

        def node_class
          RelationNode::VeritasRelation
        end
      end # class VeritasEdge
    end # class RelationEdge
  end # class RelationRegistry
end # module DataMapper
