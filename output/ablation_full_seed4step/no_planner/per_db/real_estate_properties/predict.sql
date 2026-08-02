SELECT COUNT(feature_id) FROM Other_Available_Features
SELECT Ref_Feature_Types.feature_type_name FROM Ref_Feature_Types JOIN Other_Available_Features ON Ref_Feature_Types.feature_type_code = Other_Available_Features.feature_type_code WHERE Other_Available_Features.feature_name = 'AirCon'
SELECT Ref_Property_Types.property_type_description FROM Ref_Property_Types JOIN Properties ON Ref_Property_Types.property_type_code = Properties.property_type_code WHERE Properties.property_type_code = 'that code'
SELECT P.property_name FROM Properties AS P JOIN Ref_Property_Types AS R ON P.property_type_code = R.property_type_code WHERE P.room_count > 1 AND R.property_type_description IN ('House', 'Apartment')
