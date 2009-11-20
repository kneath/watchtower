require File.dirname(__FILE__) + "/../helpers"

class TokenTest < Test::Unit::TestCase
  before(:all) do
    @token = Token.generate
  end
  
  it "creates a token without errors" do
    lambda do
      Token.create(:account => "Foo", :token => "bar")
    end.should change(Token, :count).by(1)
  end
  
  context "validates" do
    it "doesn't allow duplicate tokens with the same account" do
      token_1 = Token.create(:account => "foo", :token => "barbaz")
      token_2 = Token.new(:account => "foo", :token => "barbaz")
      token_1.should be_valid
      token_2.should_not be_valid
    end
    
    it "allows duplicate tokens with different accounts" do
      token_1 = Token.create(:account => "foo", :token => "barbarbaz")
      token_2 = Token.new(:account => "bar", :token => "barbarbaz")
      token_1.should be_valid
      token_2.should be_valid
    end
  end
end