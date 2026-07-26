SELECT count(*) FROM Documents	cre_Doc_Template_Mgt
SELECT count(*) FROM Documents	cre_Doc_Template_Mgt
SELECT document_id ,  document_name ,  document_description FROM Documents	cre_Doc_Template_Mgt
SELECT document_id ,  document_name ,  document_description FROM Documents	cre_Doc_Template_Mgt
SELECT document_name ,  template_id FROM Documents WHERE Document_Description LIKE "%w%"	cre_Doc_Template_Mgt
SELECT document_name ,  template_id FROM Documents WHERE Document_Description LIKE "%w%"	cre_Doc_Template_Mgt
SELECT document_id ,  template_id ,  Document_Description FROM Documents WHERE document_name  =  "Robbin CV"	cre_Doc_Template_Mgt
SELECT document_id ,  template_id ,  Document_Description FROM Documents WHERE document_name  =  "Robbin CV"	cre_Doc_Template_Mgt
SELECT count(DISTINCT template_id) FROM Documents	cre_Doc_Template_Mgt
SELECT count(DISTINCT template_id) FROM Documents	cre_Doc_Template_Mgt
SELECT count(*) FROM Documents AS T1 JOIN Templates AS T2 ON T1.Template_ID  =  T2.Template_ID WHERE T2.Template_Type_Code  =  'PPT'	cre_Doc_Template_Mgt
SELECT count(*) FROM Documents AS T1 JOIN Templates AS T2 ON T1.Template_ID  =  T2.Template_ID WHERE T2.Template_Type_Code  =  'PPT'	cre_Doc_Template_Mgt
SELECT template_id ,  count(*) FROM Documents GROUP BY template_id	cre_Doc_Template_Mgt
SELECT template_id ,  count(*) FROM Documents GROUP BY template_id	cre_Doc_Template_Mgt
SELECT T1.template_id ,  T2.Template_Type_Code FROM Documents AS T1 JOIN Templates AS T2 ON T1.template_id  =  T2.template_id GROUP BY T1.template_id ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT T1.template_id ,  T2.Template_Type_Code FROM Documents AS T1 JOIN Templates AS T2 ON T1.template_id  =  T2.template_id GROUP BY T1.template_id ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT template_id FROM Documents GROUP BY template_id HAVING count(*)  >  1	cre_Doc_Template_Mgt
SELECT template_id FROM Documents GROUP BY template_id HAVING count(*)  >  1	cre_Doc_Template_Mgt
SELECT template_id FROM Templates EXCEPT SELECT template_id FROM Documents	cre_Doc_Template_Mgt
SELECT template_id FROM Templates EXCEPT SELECT template_id FROM Documents	cre_Doc_Template_Mgt
SELECT count(*) FROM Templates	cre_Doc_Template_Mgt
SELECT count(*) FROM Templates	cre_Doc_Template_Mgt
SELECT template_id ,  version_number ,  template_type_code FROM Templates	cre_Doc_Template_Mgt
SELECT template_id ,  version_number ,  template_type_code FROM Templates	cre_Doc_Template_Mgt
SELECT DISTINCT template_type_code FROM Templates	cre_Doc_Template_Mgt
SELECT DISTINCT template_type_code FROM Templates	cre_Doc_Template_Mgt
SELECT template_id FROM Templates WHERE template_type_code  =  "PP" OR template_type_code  =  "PPT"	cre_Doc_Template_Mgt
SELECT template_id FROM Templates WHERE template_type_code  =  "PP" OR template_type_code  =  "PPT"	cre_Doc_Template_Mgt
SELECT count(*) FROM Templates WHERE template_type_code  =  "CV"	cre_Doc_Template_Mgt
SELECT count(*) FROM Templates WHERE template_type_code  =  "CV"	cre_Doc_Template_Mgt
SELECT version_number ,  template_type_code FROM Templates WHERE version_number  >  5	cre_Doc_Template_Mgt
SELECT version_number ,  template_type_code FROM Templates WHERE version_number  >  5	cre_Doc_Template_Mgt
SELECT template_type_code ,  count(*) FROM Templates GROUP BY template_type_code	cre_Doc_Template_Mgt
SELECT template_type_code ,  count(*) FROM Templates GROUP BY template_type_code	cre_Doc_Template_Mgt
SELECT template_type_code FROM Templates GROUP BY template_type_code ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT template_type_code FROM Templates GROUP BY template_type_code ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT template_type_code FROM Templates GROUP BY template_type_code HAVING count(*)  <  3	cre_Doc_Template_Mgt
SELECT template_type_code FROM Templates GROUP BY template_type_code HAVING count(*)  <  3	cre_Doc_Template_Mgt
SELECT min(Version_Number) ,  template_type_code FROM Templates	cre_Doc_Template_Mgt
SELECT min(Version_Number) ,  template_type_code FROM Templates	cre_Doc_Template_Mgt
SELECT T1.template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id WHERE T2.document_name  =  "Data base"	cre_Doc_Template_Mgt
SELECT T1.template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id WHERE T2.document_name  =  "Data base"	cre_Doc_Template_Mgt
SELECT T2.document_name FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id WHERE T1.template_type_code  =  "BK"	cre_Doc_Template_Mgt
SELECT T2.document_name FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id WHERE T1.template_type_code  =  "BK"	cre_Doc_Template_Mgt
SELECT T1.template_type_code ,  count(*) FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id GROUP BY T1.template_type_code	cre_Doc_Template_Mgt
SELECT T1.template_type_code ,  count(*) FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id GROUP BY T1.template_type_code	cre_Doc_Template_Mgt
SELECT T1.template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id GROUP BY T1.template_type_code ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT T1.template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id GROUP BY T1.template_type_code ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT template_type_code FROM Templates EXCEPT SELECT template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id	cre_Doc_Template_Mgt
SELECT template_type_code FROM Templates EXCEPT SELECT template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id	cre_Doc_Template_Mgt
SELECT template_type_code ,  template_type_description FROM Ref_template_types	cre_Doc_Template_Mgt
SELECT template_type_code ,  template_type_description FROM Ref_template_types	cre_Doc_Template_Mgt
SELECT template_type_description FROM Ref_template_types WHERE template_type_code  =  "AD"	cre_Doc_Template_Mgt
SELECT template_type_description FROM Ref_template_types WHERE template_type_code  =  "AD"	cre_Doc_Template_Mgt
SELECT template_type_code FROM Ref_template_types WHERE template_type_description  =  "Book"	cre_Doc_Template_Mgt
SELECT template_type_code FROM Ref_template_types WHERE template_type_description  =  "Book"	cre_Doc_Template_Mgt
SELECT DISTINCT T1.template_type_description FROM Ref_template_types AS T1 JOIN Templates AS T2 ON T1.template_type_code  = T2.template_type_code JOIN Documents AS T3 ON T2.Template_ID  =  T3.template_ID	cre_Doc_Template_Mgt
SELECT DISTINCT T1.template_type_description FROM Ref_template_types AS T1 JOIN Templates AS T2 ON T1.template_type_code  = T2.template_type_code JOIN Documents AS T3 ON T2.Template_ID  =  T3.template_ID	cre_Doc_Template_Mgt
SELECT T2.template_id FROM Ref_template_types AS T1 JOIN Templates AS T2 ON T1.template_type_code  = T2.template_type_code WHERE T1.template_type_description  =  "Presentation"	cre_Doc_Template_Mgt
SELECT T2.template_id FROM Ref_template_types AS T1 JOIN Templates AS T2 ON T1.template_type_code  = T2.template_type_code WHERE T1.template_type_description  =  "Presentation"	cre_Doc_Template_Mgt
SELECT count(*) FROM Paragraphs	cre_Doc_Template_Mgt
SELECT count(*) FROM Paragraphs	cre_Doc_Template_Mgt
SELECT count(*) FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_ID  =  T2.document_ID WHERE T2.document_name  =  'Summer Show'	cre_Doc_Template_Mgt
SELECT count(*) FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_ID  =  T2.document_ID WHERE T2.document_name  =  'Summer Show'	cre_Doc_Template_Mgt
select other_details from paragraphs where paragraph_text like 'korea'	cre_Doc_Template_Mgt
select other_details from paragraphs where paragraph_text like 'korea'	cre_Doc_Template_Mgt
SELECT T1.paragraph_id ,   T1.paragraph_text FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id WHERE T2.Document_Name  =  'Welcome to NY'	cre_Doc_Template_Mgt
SELECT T1.paragraph_id ,   T1.paragraph_text FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id WHERE T2.Document_Name  =  'Welcome to NY'	cre_Doc_Template_Mgt
SELECT T1.paragraph_text FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id WHERE T2.document_name  =  "Customer reviews"	cre_Doc_Template_Mgt
SELECT T1.paragraph_text FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id WHERE T2.document_name  =  "Customer reviews"	cre_Doc_Template_Mgt
SELECT document_id ,  count(*) FROM Paragraphs GROUP BY document_id ORDER BY document_id	cre_Doc_Template_Mgt
SELECT document_id ,  count(*) FROM Paragraphs GROUP BY document_id ORDER BY document_id	cre_Doc_Template_Mgt
SELECT T1.document_id ,  T2.document_name ,  count(*) FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id GROUP BY T1.document_id	cre_Doc_Template_Mgt
SELECT T1.document_id ,  T2.document_name ,  count(*) FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id GROUP BY T1.document_id	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*)  >=  2	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*)  >=  2	cre_Doc_Template_Mgt
SELECT T1.document_id ,  T2.document_name FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id GROUP BY T1.document_id ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT T1.document_id ,  T2.document_name FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id GROUP BY T1.document_id ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id ORDER BY count(*) ASC LIMIT 1	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id ORDER BY count(*) ASC LIMIT 1	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) BETWEEN 1 AND 2	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) BETWEEN 1 AND 2	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Brazil' INTERSECT SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Ireland'	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Brazil' INTERSECT SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Ireland'	cre_Doc_Template_Mgt
