require 'spec_helper'

module YieldStarClient
  describe Client do
    let(:client) do
      described_class.new(CONFIG.merge(
        debug: true,
        logger: Logger.new("tmp/test.log"),
      ))
    end

    describe "#get_units", vcr: {record: :once} do
      it "returns unit information" do
        property = client.get_properties.first
        units = client.get_units(property.external_property_id)
        expect(units.first).to be_a Unit
      end

      it "passes the building to the request class" do
        expected_hash = {
          external_property_id: "external_property_id",
          floor_plan_name: "floor_plan_name",
        }

        response = double

        expect(GetUnits::Request).to receive(:execute).
          with(hash_including(expected_hash)).
          and_return(response)

        parsed_response = double(units: [])

        allow(GetUnits::Response).to receive(:new).
          with(response).and_return(parsed_response)

        client.get_units(
          "external_property_id",
          "floor_plan_name",
        )
      end
    end
  end
end

describe "unit methods" do
  subject { test_object }

  let(:test_object) do
    YieldStarClient::Client.new(
      endpoint: 'http://rmsws.mpfyieldstar.com/rmsws/AppExchange',
      client_name: client_name,
    )
  end

  let(:client_name) { 'my_client_name' }
  let(:external_property_id) { 'my_prop_id' }

  it { should respond_to(:get_unit) }
  it { should respond_to(:get_units) }

  describe "#get_unit" do
    before { savon.stubs(:get_unit).returns(nil) }

    subject { unit }
    let(:unit) { test_object.get_unit(external_property_id, unit_name) }
    let(:unit_name) { 'my_unit_name' }
    let(:soap_body) { {:client_name => client_name, :external_property_id => external_property_id, :name => unit_name}}

    context "without a building name" do
      it "should retrieve the data from the service" do
        savon.expects(:get_unit).with(:request => soap_body).returns(:simple_unit)
        subject.should be
      end
    end

    context "with a building name" do
      let(:unit) { test_object.get_unit(external_property_id, unit_name, building_name) }
      let(:building_name) { 'my_building' }

      it "should retrieve the data from the service" do
        savon.expects(:get_unit).with(:request => soap_body.merge(:building => building_name)).returns(:simple_unit)
        subject.should be
      end
    end

    context "for a minimal unit" do
      before { savon.stubs(:get_unit).returns(:simple_unit) }

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq '42'
        expect(subject.floor_plan_name).to eq 'Economy'
        expect(subject.name).to eq '1A'
        expect(subject.availability_status).to eq :occupied_on_notice
      end
    end

    context "for a fully populated unit" do
      before { savon.stubs(:get_unit).returns(:full_unit) }

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq '42'
        expect(subject.floor_plan_name).to eq 'Luxury'
        expect(subject.name).to eq 'Unit 6'
        expect(subject.availability_status).to eq :vacant
        expect(subject.building).to eq '99'
        expect(subject.bedrooms).to eq 6.0
        expect(subject.bathrooms).to eq 5.3
        expect(subject.square_feet).to eq 5555
        expect(subject.unit_type).to eq 'foo'
        expect(subject.make_ready_date).to eq Date.new(2011,03,10)
      end
    end

    # Validation
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'
    it_should_behave_like 'a required string validator', :unit_name

    # Error handling
    it_should_behave_like "a fault handler", :get_unit
  end
end
