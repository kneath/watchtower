module Watchtower
  module Beam
    class Twitter
      def initialize
        @tweets_document = Nokogiri::HTML(open('http://search.twitter.com/search.atom?q=github'))

        @results = self.find_github_tweets
      end

      def find_github_tweets
        tweets = []
        @tweets_document.css('entry').each do |entry|
          body = entry.css('title').first.content
          author_url = entry.css('author uri').first.content
          author = author_url.match(/twitter.com\/(.*?)$/)[1]
          tweet_url = entry.css('link').first['href']
          tweets << {
            'unique' => Digest::SHA1.hexdigest(tweet_url),
            'service' => 'Twitter',
            'body' => body,
            'author' => '@' + author,
            'author_url' => author_url,
            'tweet_url' => tweet_url
          }
        end
        tweets
      end

      def results
        @results || []
      end
    end
  end
end