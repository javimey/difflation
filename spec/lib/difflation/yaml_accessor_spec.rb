require 'spec_helper'

describe Difflation::YamlAccessor do
  context :get_destination_yaml do

    before :each do
      class ::Rails
      end
      Rails.stub(:root).and_return("./spec/test_files")
      @file_name = './spec/test_files/config/locales/es/gem/file.yml'
    end

    it "creates a new destination file if it does not exist" do
      File.delete(@file_name) {|f| f.write(@existant_yaml.to_yaml) } if File.exists?(@file_name)
      Difflation::YamlAccessor.get_destination_yaml('/path/to/gem/config/locales/file.yml', :es).should == {}
    end

    it "should open an existing file" do
      @existant_yaml = {'es' => {'address' => 'direccion'}}
      File.open(@file_name, 'w+') {|f| f.write(@existant_yaml.to_yaml) }
      Difflation::YamlAccessor.get_destination_yaml('/path/to/gem/config/locales/file.yml', :es).should == {'address' => 'direccion'}
    end
  end
end
