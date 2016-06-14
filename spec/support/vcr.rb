VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<USERNAME>') { CONFIG[:username] }
  c.filter_sensitive_data('<PASSWORD>') { CONFIG[:password] }
  c.filter_sensitive_data('<ENDPOINT>') { CONFIG[:endpoint]}
  c.filter_sensitive_data('<CLIENT_NAME>') { CONFIG[:client_name]}
end
