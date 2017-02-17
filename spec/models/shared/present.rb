RSpec.shared_examples :present do |model, field|
  it "validates the #{field} is present" do
    expect(FactoryGirl.build(model, field => nil)).not_to be_valid
  end
end
