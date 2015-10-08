FactoryGirl.define do

  factory :yield_star_client_floor_plan, class: YieldStarClient::FloorPlan do
    external_property_id "321809"
    name "1B1B-SM*"
    description "1B1B"
    square_feet 82
    unit_count 10
    bedrooms 1
    bathrooms 1
  end

  factory :yield_star_client_unit, class: YieldStarClient::Unit do
    external_property_id "321809"
    floor_plan_name "1B1B-SM*"
    name "Unit 104"
    availablity_status :occupied
    building "123"
    bedrooms 1.0
    bathrooms 1.0
    square_feet 82
    unit_type "1x1"
    make_ready_date "2015-01-02".to_date
  end

end
