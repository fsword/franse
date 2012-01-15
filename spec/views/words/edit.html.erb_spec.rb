require 'spec_helper'

describe "words/edit" do
  before(:each) do
    @word = assign(:word, stub_model(Word,
      :foreign_lang => "MyString",
      :native_lang => "MyString",
      :can_foreign => false,
      :can_native => false
    ))
  end

  it "renders the edit word form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => words_path(@word), :method => "post" do
      assert_select "input#word_foreign_lang", :name => "word[foreign_lang]"
      assert_select "input#word_native_lang", :name => "word[native_lang]"
      assert_select "input#word_can_foreign", :name => "word[can_foreign]"
      assert_select "input#word_can_native", :name => "word[can_native]"
    end
  end
end
