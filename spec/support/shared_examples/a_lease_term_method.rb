RSpec.shared_examples 'a lease term method' do
  it "passes on any extra options" do
    external_property_id = "external_property_id"
    unit_number = "unit_number"
    opts = {
      extra: "args"
    }

    expected_args = {
      external_property_id: "external_property_id",
      unit_number: "unit_number",
      extra: "args"
    }

    response = double
    parsed_response = double(response_accessor => [])

    expect(request_class).to receive(:execute).
      with(hash_including(expected_args)).and_return(response)
    allow(response_class).to receive(:new).
      with(response).and_return(parsed_response)

    client.send(
      method,
      external_property_id,
      unit_number,
      opts,
    )
  end
end
