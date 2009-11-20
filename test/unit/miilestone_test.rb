require File.dirname(__FILE__) + "/../helpers"

class MiilestoneTest < Test::Unit::TestCase
  before(:all) do
    @token = Token.generate
    @activated_project = Project.generate(:token_id => @token.id)
    @milestone = @activated_project.milestones.create(:name => "TestMilestone", :remote_id => 42, :activated_at => DateTime.new(2001, 01, 01))
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
  
  it "sets up existing milestones when activating a project" do
    lambda do
      p = Project.activate_remote(42, @token)
    end.should change(Milestone, :count).by(3)
  end
  
  it "returns the start date as activated_at" do
    @milestone.start_date.to_s.should == "2001-01-01T00:00:00+00:00"
  end
  
  it "knows the end date when a milestone has been closed" do
    m = Milestone.make(:closed_at => DateTime.new(2008, 05, 06), :due_on => DateTime.new(2008, 04, 06))
    m.end_date.should == DateTime.new(2008, 05, 06)
  end
  
  it "knows the end date when a milestone is due" do
    m = Milestone.make(:closed_at => DateTime.new(2008, 04, 06), :due_on => DateTime.new(2008, 05, 06))
    m.end_date.strftime("%m/%d/%y").should == DateTime.new(2008, 05, 06).strftime("%m/%d/%y")
  end
  
  it "knows the end date when not much is known" do
    m = Milestone.make(:closed_at => nil, :due_on => nil)
    m.end_date.strftime("%m/%d/%y").should == Time.now.to_datetime.strftime("%m/%d/%y")
  end
  
  it "is marked active when there are open tickets and it has previously been closed" do
    m = Milestone.make(:open_tickets_count => 5, :closed_at => DateTime.new(2008, 04, 06))
    m.should be_active
  end
  
  it "is marked active when there are open tickets has the due date has been passed" do
    m = Milestone.make(:open_tickets_count => 5, :due_on => DateTime.new(2008, 04, 06))
    m.should be_active
  end
  
  it "is marked active if all tickets are closed and it's due at a later time" do
    m = Milestone.make(:open_tickets_count => 0, :due_on => DateTime.new(2020, 04, 06))
    m.should be_active
  end
  
  it "is marked inactive if all tickets are closed" do
    m = Milestone.make(:open_tickets_count => 0, :due_on => DateTime.new(2008, 04, 06))
    m.should_not be_active
    
    m2 = Milestone.make(:open_tickets_count => 0, :due_on => nil)
    m2.should_not be_active
  end
  
  context "lighthouse syncing" do
    
    before(:each) do
      @existing = Milestone.generate(:remote_id => 42, :tickets_count => 20, :open_tickets_count => 10, :name => "ExistingMilestone", :due_on => DateTime.new(2006, 06, 06), :project_id => @activated_project.id)
      
      @milestone_update_hash = {
        "title" => "ExistingMilestoneUpdated",
        "id" => "42",
        "tickets_count" => "30",
        "open_tickets_count" => "5",
        "due_on" => "2007-07-07T20:00:00Z"
      }
      stub(Lighthouse).get_milestone{
        {
          "milestone" => @milestone_update_hash
        }
      }
    end
    
    it "updates the name, open ticket count, ticket count, and due_on" do
      @existing.name.should == "ExistingMilestone"
      @existing.open_tickets_count.should == 10
      @existing.tickets_count.should == 20
      @existing.due_on.strftime("%m/%d/%y").should == "06/06/06"
      
      @existing.sync_with_lighthouse
      
      @existing.name.should == "ExistingMilestoneUpdated"
      @existing.open_tickets_count.should == 5
      @existing.tickets_count.should == 30
      @existing.due_on.strftime("%m/%d/%y").should == "07/07/07"
    end
    
    it "closes the milstone if all open tickets have been closed and the due date is past" do
      stub(Lighthouse).get_milestone{
        { "milestone" => @milestone_update_hash.merge({"open_tickets_count" => 0}) }
      }
      @existing.should be_active
      @existing.closed_at.should be_nil
      
      @existing.sync_with_lighthouse
      
      @existing.should_not be_active
      @existing.closed_at.should_not be_nil
    end
    
    it "reopenes the milestone if there are open tickets" do
      closed = Milestone.generate(:remote_id => 42, :tickets_count => 20, :open_tickets_count => 0, :name => "ClosedMilestone", :due_on => DateTime.new(2006, 06, 06), :project_id => @activated_project.id, :closed_at => DateTime.new(2006, 07, 07))
      closed.should_not be_active
      closed.closed_at.should_not be_nil
      
      closed.sync_with_lighthouse
      
      closed.should be_active
      closed.closed_at.should be_nil
    end
  end
  
end