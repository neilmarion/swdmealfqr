require 'spec_helper'

describe YieldStarClient::Client do
  let(:client) do
    described_class.new(CONFIG.merge(
      debug: true,
      logger: Logger.new("tmp/test.log"),
    ))
  end

  describe "#get_properties", vcr: {record: :once} do
    it "returns properties" do
      properties = client.get_properties
      expect(properties).to_not be_empty
    end
  end

  describe "#get_property", vcr: {record: :once} do
    it "returns the property matching the id" do
      properties = client.get_properties
      external_property_id = properties.last.external_property_id
      property = client.get_property(external_property_id)
      expect(property.external_property_id).to eq external_property_id
    end
  end

  describe "#get_property_parameters", vcr: {record: :once} do
    it "returns the property parameters of the property matching the id" do
      properties = client.get_properties
      external_property_id = properties.first.external_property_id
      property_parameters = client.
        get_property_parameters(external_property_id)
      expect(property_parameters.external_property_id).
        to eq external_property_id
    end
  end
end
