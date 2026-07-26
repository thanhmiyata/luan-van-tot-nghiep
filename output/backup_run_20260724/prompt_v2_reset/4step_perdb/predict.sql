select count(feature_id) from Other_Available_Features	real_estate_properties
select Ref_Feature_Types.feature_type_name from Ref_Feature_Types join Other_Available_Features on Ref_Feature_Types.feature_type_code = Other_Available_Features.feature_type_code where Other_Available_Features.feature_name = "AirCon"	real_estate_properties
select T1.property_type_description from Ref_Property_Types as T1 join Properties as T2 on T1.property_type_code = T2.property_type_code where T2.property_type_code = "specific_code"	real_estate_properties
select property_name from Properties where room_count > 1 and property_type_code in ("House", "Apartment")	real_estate_properties
