select count(*) from Other_Available_Features	real_estate_properties
select rft.feature_type_name from Ref_Feature_Types as rft join Other_Available_Features as oaf on rft.feature_type_code = oaf.feature_type_code where oaf.feature_name = "AirCon"	real_estate_properties
select T1.property_type_description from Ref_Property_Types as T1 inner join Properties as T2 on T1.property_type_code = T2.property_type_code where T2.property_type_code = "House"	real_estate_properties
select Properties.property_name from Properties join Ref_Property_Types on Properties.property_type_code = Ref_Property_Types.property_type_code where Properties.room_count > 1 and Ref_Property_Types.property_type_description in ("House, Bungalow, etc.","Apartment, Flat, Condo, etc.")	real_estate_properties
