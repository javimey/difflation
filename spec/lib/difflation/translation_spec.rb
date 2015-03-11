require 'spec_helper'

describe Difflation::Transdifflation do
  before :each do
    @dest_file = { :door => "**NOT TRANSLATED** door", :nested => {:another => "**NOT TRANSLATED** Call for simbolize", :one_more => "**NOT TRANSLATED** Hi World"}, :other => "**NOT TRANSLATED** Look ma"}
    @test_file = { :en => { :door => "door", :nested => {:another => "Call for simbolize", :one_more => "Hi World"}, :other => "Look ma"}}
    @cover_rate = 0.0
    @new_translation = Difflation::Transdifflation.new(@test_file, :en, :es)
    @new_translation.stub(:origin).and_return({ :door => "door", :nested => {:another => "Call for simbolize", :one_more => "Hi World"}, :other => "Look ma"})
    @new_translation.stub(:destination).and_return({})
  end

  context :initialize do
    it "assings a value to source_file" do
      @new_translation.source_file.should == @test_file
    end
    it "assings a value to from_language" do
      @new_translation.from_language.should == :en
    end
    it "assings a value to to_language" do
      @new_translation.to_language.should == :es
    end
  end

  it "generates a translated file" do
    @new_translation.translate.should == @dest_file
  end
  
  it "returns a coverage rate" do
    @new_translation.coverage.should == @cover_rate
  end
end
