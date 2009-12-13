module Watchtower
  module Beam
    class HackerNews
      def initialize
        @stories_document = Nokogiri::HTML(open('http://news.ycombinator.com'))

        @results = self.find_github_stories
      end

      def find_github_stories
        stories = []
        @stories_document.css('tr').each do |row|
          link = row.css('td.title a').first
          if link && (link['href'].downcase =~ (/github/) || link.content.downcase =~ (/github/))
            author, author_url, comments, hn_url, points = "?"

            meta_row = row.next
            meta_row.css('td.subtext span').each do |span|
              points = span.content.match(/(.*?) points/)[1] if span.content =~ /(.*?) point/
            end
            meta_row.css('td.subtext a').each do |inner_link|
              if inner_link['href'] =~ /^user(.*)/
                author = inner_link.content
                author_url = 'http://news.ycombinator.com' + inner_link['href']
              end
              if inner_link.content.downcase =~ /(.*?) comment/
                comments = inner_link.content.downcase.match(/(.*?) comment/)[1]
                hn_url = 'http://news.ycombinator.com' + inner_link['href']
              end
            end

            stories << {
              'unique' => Digest::SHA1.hexdigest(link['href']),
              'service' => 'Hacker News',
              'body' => link.content,
              'story_url' => link['href'],
              'author' => author,
              'author_url' => author_url,
              'comments' => comments,
              'points' => points
            }
          end
        end
        stories
      end

      def results
        @results || []
      end
    end
  end
end