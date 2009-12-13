module Watchtower
  module Views
    class Poll < Mustache
      include Watchtower::Helpers

      def beams
        format_beams(@results || [])
      end

    end
  end
end