require File.dirname(__FILE__) + "/../helpers"

class ProjectTest < Test::Unit::TestCase
  before(:all) do
    @token = Token.generate
    @activated_project = Project.generate(:token_id => @token.id)
  end
  
  before(:each) do
    stub(Lighthouse).get_project{
      {
        "project" => {
          "name" => "RemoteFoo",
          "id" => "42"
        }
      }
    }
    
    stub(Lighthouse).get_projects{
      {
        "projects" => [
          { "name" => "RemoteFoo",   "id" => "42" },
          { "name" => "RemoteFoo22", "id" => "22" },
          { "name" => "RemoteFoo33", "id" => "33" },
          { "name" => @activated_project.name, "id" => @activated_project.remote_id.to_s }
        ]
      }
    }
    
    stub(Lighthouse).get_milestones{
      {
        "milestones" => [
          {"name" => "FooMilestone",        "id" => "11"},
          {"name" => "FooBarMilestone",     "id" => "22"},
          {"name" => "FooBarBazMilestone",  "id" => "33"}
        ]
      }
    }
  end
  
  it "activates a project via a token" do
    p = nil
    lambda do
      p = Project.activate_remote(42, @token)
      p.name.should == "RemoteFoo"
      p.remote_id.should == 42
      p.should be_active
    end.should change(Project, :count).by(1)
    p.destroy
  end
  
  it "finds activated projects in the mix with Project.for_token" do
    projects = Project.for_token(@token)
    projects.size.should == 4
    projects.include?(@activated_project).should == true
  end
  
end