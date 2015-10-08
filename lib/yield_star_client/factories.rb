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

  factory(:yield_star_client_available_floor_plan, {
    class: YieldStarClient::AvailableFloorPlan,
  }) do
    external_property_id "321809"
    floor_plan_name "1B1B-SM*"
    effective_date "2015-02-08".to_date
    square_feet 82
    bedrooms 1
    bathrooms 1
    units []
  end

  factory(:yield_star_client_available_unit, {
    class: YieldStarClient::AvailableUnit,
  }) do
    building "2999"
    unit_type "2x1.5"
    unit_number "201"
    status :vacant
    date_available "2015-08-01".to_date
    base_market_rent 2000
    base_concession 100
    base_final_rent 1900
    best_lease_term 12
    best_market_rent 2500
    best_concession 150
    best_final_rent 2350
  end

end
