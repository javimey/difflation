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

  describe :coverage_rate do
    it "should return 0.0 if nothing is translated" do
      origin = { :en => { :home => "home", :door => "door", :nested => {:another => "Call for simbolize"}}}
      result = { :en => { :home => "**NOT TRANSLATED** home", :door => "**NOT TRANSLATED** door", :nested => {:another => "**NOT TRANSLATED** Call for simbolize"}}}
      Difflation::Compare.coverage(origin, result).should == "0.00% 0/3 entries translated"
    end

    it 'should return 100% if origin is empty' do
      origin = {}
      result = { :home => "**NOT TRANSLATED** home", :door => "**NOT TRANSLATED** door", :nested => {:another => "**NOT TRANSLATED** Call for simbolize"}}
      Difflation::Compare.coverage(origin, result).should == "100.00% 0/0 entries translated"
    end
    it 'should return 100.0 if origin is nil' do
      origin = nil
      result = { :home => "**NOT TRANSLATED** home", :door => "**NOT TRANSLATED** door", :nested => {:another => "**NOT TRANSLATED** Call for simbolize"}}
      Difflation::Compare.coverage(origin, result).should == "100.00% 0/0 entries translated"
    end

    it 'should return 0.0 if destination is nil' do
      origin = { :home => "home", :door => "door", :nested => {:another => "Call for simbolize"}}
      result = nil
      Difflation::Compare.coverage(origin, result).should == "0.00% 0/3 entries translated"
    end

    it 'should return 100% when origin is empty, even if there is something at destination' do
      origin = {}
      result  = {:home => "hogar"}
      Difflation::Compare.coverage(origin, result).should == "100.00% 0/0 entries translated"
    end

    it 'should return 0% destination is an empty hash' do
      origin = {:home => "home"}
      result  = {}
      Difflation::Compare.coverage(origin, result).should == "0.00% 0/1 entries translated"
    end

    it 'should return 100% when you have everything translated (5/5)' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five" }
      result =   { :one => "uno", :two => "dos", :three => "tres", :four => "cuatro", :five => "cinco" }
      Difflation::Compare.coverage(origin, result).should == "100.00% 5/5 entries translated"
    end

    it 'should return 80% when you have 8/10 terms translated' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight", :nine => "nine", :ten => "ten" }
      result =   { :one => "uno", :two => "dos", :three => "tres", :four => "cuatro", :five => "cinco", :six => "**NOT TRANSLATED** six", :seven => "**NOT TRANSLATED** seven", :eight => "ocho", :nine => "nueve", :ten => "diez" }
      Difflation::Compare.coverage(origin, result).should == "80.00% 8/10 entries translated"
    end

    it 'should return 70% when you have 7/10 terms translated, but you dont have a term, even in the hash and 2 of them are not translated' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight", :nine => "nine", :ten => "ten" }
      result =   { :one => "uno", :two => "dos", :three => "tres", :four => "cuatro", :five => "cinco", :six => "**NOT TRANSLATED** six", :seven => "**NOT TRANSLATED** seven", :eight => "ocho", :nine => "nueve" }
      Difflation::Compare.coverage(origin, result).should == "70.00% 7/10 entries translated"
    end

    it 'should return 62.50% when you have 5/8 terms translated' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight" }
      result =   { :one => "uno", :two => "**NOT TRANSLATED** two", :three => "tres", :four => "cuatro", :five => "cinco", :six => "**NOT TRANSLATED** six", :seven => "**NOT TRANSLATED** seven", :eight => "ocho"}
      Difflation::Compare.coverage(origin, result).should == "62.50% 5/8 entries translated"
    end

    it 'should return 62.50% when you have 5/8 terms translated, having extra terms at destination' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight" }
      result =   { :one => "uno", :two => "**NOT TRANSLATED** two", :three => "tres", :four => "cuatro", :five => "cinco", :six => "**NOT TRANSLATED** six", :seven => "**NOT TRANSLATED** seven", :eight => "ocho", :puerta => "Puerta"}
      token = "**NOT TRANSLATED**"
      Difflation::Compare.coverage(origin, result, token).should == "62.50% 5/8 entries translated"
    end

    it 'should return 62.50% when you have 7/8 terms translated, using a custom token' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight" }
      result =   { :one => "**SIN TRADUCIR** uno", :two => "**NOT TRANSLATED** two", :three => "tres", :four => "cuatro", :five => "cinco", :six => "**NOT TRANSLATED** six", :seven => "**NOT TRANSLATED** seven", :eight => "ocho", :puerta => "Puerta"}
      token = "**SIN TRADUCIR**"
      Difflation::Compare.coverage(origin, result, token).should == "87.50% 7/8 entries translated"
    end

    it 'should return 100.00% in nested hash' do
      origin = { :house => "house", :street => {:street_name => "street name", :postal => "postal code"}}
      result = { :house => "casa", :street => {:street_name => "Nombre de la calle", :postal => "codigo postal"}}
      Difflation::Compare.coverage(origin, result).should == "100.00% 3/3 entries translated"
    end

    it 'should return 2 of 3 translations found' do
      origin = { :house => "house", :street => {:street_name => "street name", :postal => "postal code"}}
      result = { :house => "casa", :street => {:street_name => "**NOT TRANSLATED** Nombre de la calle", :postal => "codigo postal"}}
      Difflation::Compare.coverage(origin, result).should == "66.67% 2/3 entries translated"
    end

    it 'should return 0.00% in nested hash' do
      origin = { :street => {:street_name => "**NOT TRANSLATED** Nombre de la calle", :postal => "codigo postal", :number => { :one => "one", :two => "two", :three => "tree"}}}
      result = { :one => "uno"}
      Difflation::Compare.coverage(origin, result).should == "0.00% 0/5 entries translated"
    end

    it 'should return 8.33% in nested hash' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight", :nine => "nine", :ten => "ten", :street => {:street_name => "**NOT TRANSLATED** Nombre de la calle", :postal => "codigo postal"}}
      result =   { :one => "uno"}
      Difflation::Compare.coverage(origin, result).should == "8.33% 1/12 entries translated"
    end

    it 'should return 8.33% in nested hash with only one term' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight", :nine => "nine", :ten => "ten", :street => {:street_name => "Nombre de la calle", :postal => "codigo postal"}}
      result =   { :one => "uno"}
      Difflation::Compare.coverage(origin, result).should == "8.33% 1/12 entries translated"
    end
  end
end
