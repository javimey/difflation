require 'spec_helper'

describe Difflation::Compare do
  describe :generate_diff do
    describe "when destiny is empy" do
      it "returns a yaml with differences from origin and an empty destination" do
        origin = { :en => { :home => "home", :door => "door", :nested => {:another => "Call for simbolize"}}}
        result = { :en => { :home => "**NOT TRANSLATED** home", :door => "**NOT TRANSLATED** door", :nested => {:another => "**NOT TRANSLATED** Call for simbolize"}}}
        Difflation::Compare.generate_diff(origin, {}).should == result
      end
    end
    describe "when destiny has data" do
      it "returns differences when origin has more keys than destination" do
        origin = { :en => { :home => "home", :door => "door", :nested => {:another => "Call for simbolize"}}}
        dest   = { :en => { :home => "hogar", :nested => {:another => "Texto traducido"}}}
        result = { :en => { :home => "hogar", :door => "**NOT TRANSLATED** door", :nested => {:another => "Texto traducido"}}}
        Difflation::Compare.generate_diff(origin, dest).should == result
      end
      it "returns differences when dest has more keys than origin and you have all translated" do
        origin = { :en => { :home => "home", :door => "door", :nested => {:another => "Call for simbolize"}}}
        dest   = { :en => { :home => "hogar", :door => "puerta", :stair => "escalera", :nested => {:another => "Texto traducido"}}}
        result = { :en => { :home => "hogar", :door => "puerta", :stair => "escalera", :nested => {:another => "Texto traducido"}}}
        Difflation::Compare.generate_diff(origin, dest).should == result
      end
      it "returns differences when dest has more keys than origin and you dont have all translated" do
        origin = { :en => { :home => "home", :door => "door", :nested => {:another => "Call for simbolize"}}}
        dest   = { :en => { :home => "hogar", :stair => "escalera", :nested => {:another => "Texto traducido"}}}
        result = { :en => { :home => "hogar", :door => "**NOT TRANSLATED** door", :stair => "escalera", :nested => {:another => "Texto traducido"}}}
        Difflation::Compare.generate_diff(origin, dest).should == result
      end
      it "returns differences when dest has nested keys than origin and you dont have all translated" do
        origin = { :en => { :home => "home", :five => 5, :door => "door", :nested => {:another => "Call for simbolize"}}}
        dest   = { :en => { :home => "hogar", :stair => "escalera", :nested => {:another => "Texto traducido", :something => "Algo"}}}
        result = { :en => { :home => "hogar", :five => "**NOT TRANSLATED** 5", :door => "**NOT TRANSLATED** door", :stair => "escalera", :nested => {:another => "Texto traducido", :something => "Algo"}}}
        Difflation::Compare.generate_diff(origin, dest).should == result
      end
    end
  end
end
