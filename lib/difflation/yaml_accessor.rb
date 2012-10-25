module Difflation
  class YamlAccessor

    def self.get_destination_yaml(source_file, language)
      file = Hash.new
      file[language] = ''
      file
    end

    private

    #The folder is created if doesn't exist
    def destination_folder
      FileUtils.mkdir_p(File.join(Rails.root, "config/locales/#{to_locale}")) if !File.directory?("config/locales/#{to_locale}")
    end
  end
end
