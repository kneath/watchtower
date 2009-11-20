include DataMapper::Sweatshop::Unique

Burndown::Token.fixture do
  { 
    :account =>        unique { /\w+/.gen },
    :token =>          Digest::SHA1.hexdigest(unique { /\w+/.gen })
  }
  
end