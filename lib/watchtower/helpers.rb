module Watchtower
  module Helpers
    include Rack::Utils
    alias :h :escape_html

    def show(template, options = {})
      @title = options[:title]
      mustache template
    end

    def link_to(title, url)
      %(<a href="#{url}">#{h(title)}</a>)
    end

    def page_info(options={})
      @title = options[:title]
      @breadcrumb = options[:breadcrumb]
      @page_id = options[:id]
    end
  end
end