require 'spec_helper'

describe Difflation::Compare do
  describe :generate_diff do
    it "returns a yaml with differences from origin and an empty destination" do
      origin = { :en => { :home => "home", :door => "door", :nested => {:another => "Call for simbolize"}}}
      result = { :en => { :home => "**NOT TRANSLATED** home", :door => "**NOT TRANSLATED** door", :nested => {:another => "**NOT TRANSLATED** Call for simbolize"}}}
      Difflation::Compare.generate_diff(origin, {}).should == result
    end
  end
end
