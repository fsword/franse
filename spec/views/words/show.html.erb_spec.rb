require 'spec_helper'

describe "words/show" do
  before(:each) do
    @word = assign(:word, stub_model(Word,
      :foreign_lang => "Foreign Lang",
      :native_lang => "Native Lang",
      :can_foreign => false,
      :can_native => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Foreign Lang/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Native Lang/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
