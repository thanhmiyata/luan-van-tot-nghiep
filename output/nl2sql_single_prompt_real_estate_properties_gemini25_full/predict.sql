select count(feature_id) from Other_Available_Features	real_estate_properties
select T1.feature_type_name from Ref_Feature_Types as T1 inner join Other_Available_Features as T2 on T1.feature_type_code = T2.feature_type_code where T2.feature_name = "AirCon"	real_estate_properties
select distinct T1.property_type_description from Ref_Property_Types as T1 join Properties as T2 on T1.property_type_code = T2.property_type_code	real_estate_properties
select T1.property_name from Properties as T1 inner join Ref_Property_Types as T2 on T1.property_type_code = T2.property_type_code where T2.property_type_description in ("House", "Apartment") and T1.room_count > 1	real_estate_properties
