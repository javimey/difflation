module Difflation
  class Transdifflation
    attr_reader :source_file, :from_language, :to_language
    def initialize(source_file, from_language, to_language)
      @source_file   = source_file
      @from_language = from_language
      @to_language   = to_language
    end

    def translate
      require 'pry';binding.pry
      Compare.generate_diff(origin, destination)
    end

    private

    def destination
      YamlAccessor.get_destination_yaml(@source_file, @to_language)
    end

    def origin
      YamlAccessor.get_origin_yaml(@source_file, @from_language)
    end
  end
end
