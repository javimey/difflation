require 'spec_helper'

describe Difflation::Transdifflation do
  before :each do
    @test_file = { :en => { :door => "door", :nested => {:another => "Call for simbolize", :one_more => "Hi World"}, :other => "Look ma"}}
    @dest_file = { :es => { :door => "**NOT TRANSLATED** door", :nested => {:another => "**NOT TRANSLATED** Call for simbolize", :one_more => "**NOT TRANSLATED** Hi World"}, :other => "**NOT TRANSLATED** Look ma"}}
    @new_translation = Difflation::Transdifflation.new(@test_file, :en, :es)
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
end
