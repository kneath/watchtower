module Watchtower
  module Helpers
    include Rack::Utils
    alias :h :escape_html

    def show(template, options = {})
      @title = options[:title]
      mustache template, options
    end

    def link_to(title, url)
      %(<a href="#{url}">#{h(title)}</a>)
    end

    def page_info(options={})
      @title = options[:title]
      @breadcrumb = options[:breadcrumb]
      @page_id = options[:id]
    end

    # Taken from rails
    AUTO_LINK_RE = %r{
                ( https?:// | www\. )
                [^\s<]+
              }x unless const_defined?(:AUTO_LINK_RE)
    BRACKETS = { ']' => '[', ')' => '(', '}' => '{' }
    def auto_link(text, html_options = {})
      text.gsub(AUTO_LINK_RE) do
        href = $&
        punctuation = ''
        left, right = $`, $'
        # detect already linked URLs and URLs in the middle of a tag
        if left =~ /<[^>]+$/ && right =~ /^[^>]*>/
          # do not change string; URL is alreay linked
          href
        else
          # don't include trailing punctuation character as part of the URL
          if href.sub!(/[^\w\/-]$/, '') and punctuation = $& and opening = BRACKETS[punctuation]
            if href.scan(opening).size > href.scan(punctuation).size
              href << punctuation
              punctuation = ''
            end
          end

          link_text = block_given?? yield(href) : href
          href = 'http://' + href unless href.index('http') == 0

          "<a href=\"#{href}\">#{h(link_text)}</a>" + punctuation
        end
      end
    end

    def format_beams(beams)
      beams.collect do |beam|
        actions = []
        case beam['service']
        when 'Twitter'
          actions << {'url' => beam['tweet_url'], 'name' => 'View Tweet'}
        when 'Hacker News'
          actions << {'url' => beam['story_url'], 'name' => 'View Story'}
        end
        {
          'body' => auto_link(beam['body']),
          'author_url' => beam['author_url'],
          'author' => beam['author'],
          'service_short' => (beam['service'] || "unknown").downcase.gsub(/\s/, ''),
          'created_at' => beam['created_at'] || Time.now.utc,
          'actions' => actions
        }
      end
    end

  end
end