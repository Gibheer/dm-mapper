module DataMapper
  class RelationRegistry
    class RelationConnector < Graph::Edge

      class Builder

        def self.call(mappers, relations, relationship)
          left_mapper  = mappers[relationship.source_model]
          right_mapper = mappers[relationship.target_model]

          left_node =
            if relationship.via
              via_relationship = left_mapper.relationships[relationship.via]
              via_name         = :"#{left_mapper.relation.name}_#{via_relationship.name}"

              via_relation =
                if relations[via_name]
                  relations[via_name]
                else
                  call(mappers, relations, via_relationship).for_relationship(relationship)
                end.relation

              relations.new_node(via_name, via_relation).nodes.to_a.last
            else
              relations.node_for(left_mapper.relation)
            end

          right_node =
            if via_relationship
              relations.node_for(right_mapper.relation).for_relationship(via_relationship)
            else
              relations.node_for(right_mapper.relation)
            end

          unless left_node && right_node
            raise ArgumentError, "Missing left and/or right nodes for #{relationship.inspect}"
          end

          relations.new_edge(
            relationship, left_node, right_node, relationship.operation
          ).edges.to_a.last
        end

      end # class Builder

    end # class RelationConnector
  end # class RelationRegistry
end # module DataMapper
