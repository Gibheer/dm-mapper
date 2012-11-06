require 'spec_helper'

describe Finalizer::DependentRelationshipSet, '#each' do
  let(:object)         { described_class.new(song_tag_model, mappers) }
  let(:songs)          { mock('songs',     :name => :songs,     :target_model => song_model,     :target_key => :song_id, :via => :song_tags) }
  let(:song_tags)      { mock('song_tags', :name => :song_tags, :target_model => song_tag_model, :via => nil) }
  let(:tags)           { mock('tags',      :name => :tags,      :target_model => tag_model,      :target_key => :tag_id, :via => :song_tags) }
  let(:song_model)     { mock_model(:Song) }
  let(:song_tag_model) { mock_model(:SongTag) }
  let(:tag_model)      { mock_model(:Tag) }

  let(:song_mapper)     { mock_mapper(song_model) }
  let(:song_tag_mapper) { mock_mapper(song_tag_model) }
  let(:tag_mapper)      { mock_mapper(tag_model) }

  let(:mappers) { [ song_mapper, song_tag_mapper, tag_mapper ] }

  let(:relationships)  { [ song_tags ] }

  before do
    song_mapper.relationships << song_tags << tags
    tag_mapper.relationships  << song_tags << songs
  end

  context "with a block" do
    it "iterates over dependent relationship" do
      songs.should_receive(:name).once()
      tags.should_receive(:name).once()
      song_tags.should_receive(:name).once()

      object.each { |relationship| relationship.name }
    end
  end

  context "without a block" do
    subject { object.each }

    it { should be_instance_of(Enumerator) }
  end
end
