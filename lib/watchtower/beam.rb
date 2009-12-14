module Watchtower
  module Beam
    def self.poll(beam)
      results = []
      beam.new.results.each do |result|
        existing = BEAMS.find('unique' => result['unique'])
        if existing.count == 0
          self.save(result)
          results << result
        end
      end
      results
    end

    def self.poll_all
      self.poll(Beam::HackerNews)
      self.poll(Beam::Twitter)
    end

    def self.save(object)
      BEAMS.insert(object.merge({ 'created_at' => Time.now}))
    end

    # Returns all Beams. Can be passed an options hash
    #   :sort  - An array of [ field, order ] pairs
    #   :limit - How many results to return
    def self.all(options = {})
      default_options = {
        :sort  => [['created_at', 'descending']],
        :limit => 100
      }

      BEAMS.find({}, default_options.merge(options))
    end

    def self.count_today(options = {})
      BEAMS.find(options.merge({
        :created_at => {'$gt' => Time.now - 60*60*24}
      })).count()
    end
  end
end
