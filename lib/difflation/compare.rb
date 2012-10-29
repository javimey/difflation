module Difflation
  class Compare
    def self.generate_diff(origin, destination)
      compare_hash(origin, destination)
    end

    # Get Coverage rate from two hashes, depending on the number of keys that have a given token
    #
    # @param [Hash] origin I18n source translation to compare
    # @param [Hash] destination I18n target translation to compare
    # @param [String] token The string you want to compare. example: **NOT TRANSLATED**
    def self.coverage(origin, destination, token = "**NOT TRANSLATED**")
      words = 0
      found = 0
      return "100.00% #{found}/#{words} entries translated"  if origin.nil?
      destination = {} if destination.nil?
      return "100.00% #{found}/#{words} entries translated"  if origin.empty?

      words, found = rate_from_branch(origin,destination, token, words, found)
      percent = (found.to_f/words.to_f) * 100
      truncate = "%.2f" % percent
      return "#{truncate}% #{found}/#{words} entries translated"
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

    def self.rate_from_branch(origin, destination, token, words, found)
      origin.each_pair{ |key, value|
        if origin[key.to_sym].instance_of? Hash
          if destination[key.to_sym]
            words, found = rate_from_branch(origin[key.to_sym], destination[key.to_sym], token, words, found)
          else
            # Sum other words
            # could have nested branches, so we call it with origin[key.to_sym] to count the number of words, returning the found to a temporal var
            words, temp = rate_from_branch(origin[key.to_sym], origin[key.to_sym], token, words, found)
          end
        else
          words += 1
          if destination[key.to_sym]
            found += 1 if !destination[key.to_sym].to_s.include?(token)
          end
        end
      }
      return words, found
    end
  end
end
