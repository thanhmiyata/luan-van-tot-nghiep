select count(*) from Other_Available_Features	real_estate_properties
select Ref_Feature_Types.feature_type_name from Ref_Feature_Types join Other_Available_Features on Other_Available_Features.feature_type_code = Ref_Feature_Types.feature_type_code where Other_Available_Features.feature_name = "AirCon"	real_estate_properties
select property_type_description from Ref_Property_Types	real_estate_properties
select property_name from Properties where property_type_code in ("House", "Apartment") and room_count > 1	real_estate_properties
