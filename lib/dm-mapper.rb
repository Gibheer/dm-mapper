require 'data_mapper/relation_registry'
require 'data_mapper/mapper'
require 'data_mapper/mapper/veritas_mapper'
require 'data_mapper/mapper/attribute_set'
require 'data_mapper/mapper/attribute_set/attribute'
require 'data_mapper/mapper/relationship_set'
require 'data_mapper/mapper/relationship_set/relationship'

module DataMapper

  # @api public
  def self.setup(name, uri)
    adapters[name.to_sym] = Veritas::Adapter::DataObjects.new(uri)
  end

  # @api public
  def self.adapters
    @adapters ||= {}
  end

  # @api public
  def self.relation_registry
    @_relation_registry ||= RelationRegistry.new
  end

end # module DataMapper
