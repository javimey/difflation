module Difflation
  class Transdifflation
    attr_reader :source_file, :from_language, :to_language
    def initialize(source_file, from_language, to_language)
      @source_file   = source_file
      @from_language = from_language
      @to_language   = to_language
    end

    def translate
      result = Hash.new
      result[to_language] = Compare.generate_diff(
        @source_file[@from_language],
        YamlAccessor.get_destination_yaml(@source_file, @to_language)[@to_language]
      )
      result
    end

    def coverage
      Compare.coverage.tap
    end
  end
end
