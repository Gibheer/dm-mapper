require 'spec_helper_integration'

describe "Using Arel engine" do
  include_context 'Models and Mappers'

  before(:all) do
    setup_db

    insert_user 1, 'John',  18
    insert_user 2, 'Jane',  21
    insert_user 3, 'Piotr', 29

    user_mapper
  end

  let(:user_mapper) {
    DM_ENV.build(user_model, :postgres) do
      relation_name :users

      map :id,   Integer, :key => true, :coercion_method => :to_integer
      map :name, String,  :to  => :username
      map :age,  Integer, :coercion_method => :to_integer
    end
  }

  it "returns all users ordered by name" do
    users = DM_ENV[user_model].order(:name).all

    users.should have(3).items

    user1, user2, user3 = users

    user1.id.should be(2)
    user1.name.should eql('Jane')
    user1.age.should be(21)

    user2.id.should be(1)
    user2.name.should eql('John')
    user2.age.should be(18)

    user3.id.should be(3)
    user3.name.should eql('Piotr')
    user3.age.should be(29)
  end

  it "returns all users with given limit and offset" do
    users = DM_ENV[user_model].limit(1).offset(2).all

    users.should have(1).items

    user = users.first

    user.name.should eql('Piotr')
    user.age.should be(29)
  end
end
