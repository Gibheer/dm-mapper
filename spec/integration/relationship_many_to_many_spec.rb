require 'spec_helper'

describe 'Relationship - Many To Many' do
  before(:all) do
    setup_db

    insert_song 1, 'foo'
    insert_song 2, 'bar'

    insert_tag 1, 'good'
    insert_tag 2, 'bad'

    insert_song_tag 1, 2, 1
    insert_song_tag 2, 1, 2

    song_tags_base_relation = Veritas::Relation::Base.new(:song_tags,
      [ [ :song_id, Integer ], [ :tag_id, Integer ] ])

    DataMapper.relation_registry << song_tags_base_relation

    SONG_TAGS_RELATION = Veritas::Relation::Gateway.new(
      DATABASE_ADAPTER, DataMapper.relation_registry[:song_tags])

    class Song
      attr_reader :id, :title, :tags

      def initialize(attributes)
        @id, @title, @tags = attributes.values_at(:id, :title, :tags)
      end
    end

    class Tag
      attr_reader :id, :name

      def initialize(attributes)
        @id, @name, = attributes.values_at(:id, :name)
      end
    end

    class TagMapper < DataMapper::Mapper::VeritasMapper
      map :id,   :type => Integer, :to => :tag_id, :key => true
      map :name, :type => String

      model         Tag
      relation_name :tags
      repository    :postgres
    end

    class SongTagMapper < DataMapper::Mapper::VeritasMapper
      map :id,    :type => Integer, :to => :song_id, :key => true
      map :title, :type => String
      map :tags,  :type => Tag, :collection => true

      model Song
    end

    class SongMapper < DataMapper::Mapper::VeritasMapper
      map :id,    :type => Integer, :key => true
      map :title, :type => String

      has_many :tags, :mapper => SongTagMapper, :through => :song_tags do |tags|
        # TODO: add a global gateway registry so we can access song_tags easily
        rename(:id => :song_id).join(SONG_TAGS_RELATION).join(tags)
      end

      model         Song
      relation_name :songs
      repository    :postgres
    end
  end

  it 'loads associated object' do
    mapper = DataMapper[Song]
    songs = mapper.include(:tags).to_a

    songs.should have(2).items

    song1, song2 = songs

    song1.title.should eql('bar')
    song1.tags.should have(1).item
    song1.tags.first.name.should eql('good')

    song2.title.should eql('foo')
    song2.tags.should have(1).item
    song2.tags.first.name.should eql('bad')
  end
end
