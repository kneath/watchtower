module Watchtower
  module Views
    class Layout < Mustache
      include Watchtower::Helpers

      def tweet_beams_count
        Beam.count_today(:service => 'Twitter')
      end

      def hn_beams_count
        Beam.count_today(:service => 'Hacker News')
      end

      def beam_total_count
        tweet_beams_count + hn_beams_count
      end
    end
  end
end
