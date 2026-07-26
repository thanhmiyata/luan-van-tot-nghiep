select count(feature_id) from Other_Available_Features	real_estate_properties
select T1.feature_type_name from Ref_Feature_Types as T1 join Other_Available_Features as T2 on T1.feature_type_code = T2.feature_type_code where T2.feature_name = "AirCon"	real_estate_properties
select Ref_Property_Types.property_type_description from Ref_Property_Types join Properties on Ref_Property_Types.property_type_code = Properties.property_type_code where Properties.property_type_code = "that code"	real_estate_properties
select P.property_name from Properties as P join Ref_Property_Types as R on P.property_type_code = R.property_type_code where P.room_count > 1 and R.property_type_description in ("House", "Apartment")	real_estate_properties
