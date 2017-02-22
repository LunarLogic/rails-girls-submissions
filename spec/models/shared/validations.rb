RSpec.shared_examples :positive_present_integer do |model, field|
  it "validates the #{field} is present and positive integer" do
    expect(FactoryGirl.build(model, field => -1)).not_to be_valid
    expect(FactoryGirl.build(model, field => "a")).not_to be_valid
    expect(FactoryGirl.build(model, field => 4.32)).not_to be_valid
  end
end

RSpec.shared_examples :present do |model, field|
  it "validates the #{field} is present" do
    expect(FactoryGirl.build(model, field => nil)).not_to be_valid
  end
end
