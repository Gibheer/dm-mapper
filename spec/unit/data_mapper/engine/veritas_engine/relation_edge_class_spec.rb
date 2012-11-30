require 'spec_helper'

describe Engine::VeritasEngine, '#relation_edge_class' do
  subject { object.relation_edge_class }

  let(:object) { described_class.new('postgres://localhost/test') }

  it { should be(RelationRegistry::Veritas::Edge) }
end
