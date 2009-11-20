include DataMapper::Sweatshop::Unique

Burndown::Project.fixture do
  { 
    :name =>        unique { /\w+/.gen },
    :remote_id =>   unique { /\d{1,5}/.gen }
  }
  
end