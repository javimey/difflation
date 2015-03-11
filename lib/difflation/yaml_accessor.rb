module Difflation
  class YamlAccessor

    def self.get_destination_yaml(source_file, language)
      source_dir, file_name  = File.split(source_file)
      dest_dir               = get_destination_dir(source_dir, language)
      dest_file              = get_destination_file(dest_dir, file_name, language)
      dest_file[language.to_s].nil? ? {} : dest_file[language.to_s].to_hash
    end

    def self.get_origin_yaml(source_file, language)
      YAML.load_file(source_file)[language]
    end

    private

    # get the destination directory
    def self.get_destination_dir(source_dir, language)
      # get base name from dir
      # /path/to/my_gem/config/locale/en/views  returns my_gem
      base_name = source_dir[/.*\/(.*)\/config\/locales/, 1]
      # get destination directory
      # /path/to/my_gem/config/locale/en/views  returns en/views
      dest_dir  = source_dir[/.*config\/locales\/(.*)/, 1]
      destination_directory("#{language}/#{base_name}/#{dest_dir}")
      "config/locales/#{language}/#{base_name}/#{dest_dir}"
    end

    # get the destination file
    def self.get_destination_file(dest_dir, file_name, language)
      dest_file = "#{::Rails.root}/#{dest_dir}#{file_name}"
      unless File.exists?(dest_file)
        layout       = {language => {}}
        File.open(dest_file, 'w') {|f| f.write(layout.to_yaml) }
      end
      YAML.load_file(dest_file)
    end

    # Creates a directory if it doesn't exist
    def self.destination_directory(dest_dir)
      FileUtils.mkdir_p(File.join(::Rails.root, "config/locales/#{dest_dir}")) unless Dir.exists?("config/locales/#{dest_dir}")
    end
  end
end
