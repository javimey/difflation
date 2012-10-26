require 'spec_helper'

describe Difflation::Compare do
  describe :generate_diff do
    it "returns a yaml with differences from origin and an empty destination" do
      origin = { :en => { :home => "home", :door => "door", :nested => {:another => "Call for simbolize"}}}
      result = { :en => { :home => "**NOT TRANSLATED** home", :door => "**NOT TRANSLATED** door", :nested => {:another => "**NOT TRANSLATED** Call for simbolize"}}}
      Difflation::Compare.generate_diff(origin, {}).should == result
    end
  end
  
  describe :coverage_rate do
    it "should return 0.0 if nothing is translated" do
      origin = { :en => { :home => "home", :door => "door", :nested => {:another => "Call for simbolize"}}}
      result = { :en => { :home => "**NOT TRANSLATED** home", :door => "**NOT TRANSLATED** door", :nested => {:another => "**NOT TRANSLATED** Call for simbolize"}}}
    end

    it 'should return a message when hash_from_locale is an nil hash' do
    end
    it 'should return a message when hash_to_locale is an nil hash' do
    end

    it 'should return 100% when hash_from_locale is empty' do
    end

    it 'should return 100% when hash_from_locale is empty, even if there is something at hash_to_locale' do
      origin = {}
      result  = {:home => "hogar"}
    end

    it 'should return 0% when theres all to translate' do
      origine = {:home => "home"}
      result  = {}
    end

    it 'should return 100% when you have everything translated (5/5)' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five" }
      result =   { :one => "uno", :two => "dos", :three => "tres", :four => "cuatro", :five => "cinco" }
    end

    it 'should return 80% when you have 8/10 terms translated' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight", :nine => "nine", :ten => "ten" }
      result =   { :one => "uno", :two => "dos", :three => "tres", :four => "cuatro", :five => "cinco", :six => "**NOT TRANSLATED** six", :seven => "**NOT TRANSLATED** seven", :eight => "ocho", :nine => "nueve", :ten => "diez" }
    end

    it 'should return 70% when you have 7/10 terms translated, but you dont have a term, even in the hash and 2 of them are not translated' do
      hash_from_locale = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight", :nine => "nine", :ten => "ten" }
      result =   { :one => "uno", :two => "dos", :three => "tres", :four => "cuatro", :five => "cinco", :six => "**NOT TRANSLATED** six", :seven => "**NOT TRANSLATED** seven", :eight => "ocho", :nine => "nueve" }
    end

    it 'should return 62.50% when you have 5/8 terms translated' do
      hash_from_locale = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight" }
      result =   { :one => "uno", :two => "**NOT TRANSLATED** two", :three => "tres", :four => "cuatro", :five => "cinco", :six => "**NOT TRANSLATED** six", :seven => "**NOT TRANSLATED** seven", :eight => "ocho"}
    end

    it 'should return 62.50% when you have 5/8 terms translated, having extra terms at the hash_to_locale hash' do
      hash_from_locale = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight" }
      result =   { :one => "uno", :two => "**NOT TRANSLATED** two", :three => "tres", :four => "cuatro", :five => "cinco", :six => "**NOT TRANSLATED** six", :seven => "**NOT TRANSLATED** seven", :eight => "ocho", :puerta => "Puerta"}
      token = "**NOT TRANSLATED**"
    end

    it 'should return 100.00% in nested hash' do
      hash_from_locale = { :house => "house", :street => {:street_name => "street name", :postal => "postal code"}}
      result = { :house => "casa", :street => {:street_name => "Nombre de la calle", :postal => "codigo postal"}}
    end

    it 'should return 3 entries, 2 translations found' do
      origin = { :house => "house", :street => {:street_name => "street name", :postal => "postal code"}}
      result = { :house => "casa", :street => {:street_name => "**NOT TRANSLATED** Nombre de la calle", :postal => "codigo postal"}}
    end

    it 'should return 0.00% in nested hash' do
      origin = { :street => {:street_name => "**NOT TRANSLATED** Nombre de la calle", :postal => "codigo postal", :number => { :one => "one", :two => "two", :three => "tree"}}}
      result =   { :one => "uno"}
    end

    it 'should return 10.00% in nested hash' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight", :nine => "nine", :ten => "ten", :street => {:street_name => "**NOT TRANSLATED** Nombre de la calle", :postal => "codigo postal"}}
      result =   { :one => "uno"}
    end

    it 'should return 8.33% in nested hash with only one term' do
      origin = { :one => "one", :two => "two", :three => "tree", :four => "four", :five => "five", :six => "six", :seven => "seven", :eight => "eight", :nine => "nine", :ten => "ten", :street => {:street_name => "Nombre de la calle", :postal => "codigo postal"}}
      result =   { :one => "uno"}
    end
  end
end
