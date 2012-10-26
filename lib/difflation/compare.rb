module Difflation
  class Compare
    def self.generate_diff(origin, destination)
      compare_hash(origin, destination)
    end

    private
    def self.compare_hash(origin, destination={})
      origin.each_pair do |key, value|
        if value.is_a? Hash
          if destination.has_key? key
            if value.is_a? Hash
              destination[key] = compare_hash(value, destination[key])
            end
          else
            destination[key] = compare_hash(value)
          end
        else
          destination[key] = "**NOT TRANSLATED** #{value}" unless destination.has_key? key
        end
      end
      destination
    end
  end
end
