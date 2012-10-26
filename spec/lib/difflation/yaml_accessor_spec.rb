require 'spec_helper'

describe Difflation::YamlAccessor do
  context :get_destination_yaml do
    before :each do
    end
    it "generates destination file from a gem" do
      Difflation::YamlAccessor.get_destination_yaml('/path/to/gem', :locale).should == {:locale => {} }
    end
  end
end
