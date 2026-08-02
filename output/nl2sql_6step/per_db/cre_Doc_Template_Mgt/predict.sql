select count(*) from Documents	cre_Doc_Template_Mgt
select count(*) from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select count(distinct Template_ID) from Documents	cre_Doc_Template_Mgt
select count(distinct Templates.Template_ID) from Documents join Templates on Documents.Template_ID = Templates.Template_ID	cre_Doc_Template_Mgt
select count(*) from Documents join Templates on Documents.Template_ID = Templates.Template_ID where Templates.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select count(*) from Documents join Templates on Documents.Template_ID = Templates.Template_ID where Templates.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select Templates.Template_ID, count(*) from Templates join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID	cre_Doc_Template_Mgt
select T1.Template_ID, count(*) from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_ID	cre_Doc_Template_Mgt
select Templates.Template_ID, Templates.Template_Type_Code from Templates join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID order by count(*) desc limit 1	cre_Doc_Template_Mgt
select T.Template_ID, T.Template_Type_Code from Templates as T join Documents as D on T.Template_ID = D.Template_ID group by T.Template_ID, T.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Templates.Template_ID from Templates inner join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID having count(*) > 1	cre_Doc_Template_Mgt
select Template_ID from Documents group by Template_ID having count(*) > 1	cre_Doc_Template_Mgt
SELECT template_id FROM Templates EXCEPT SELECT template_id FROM Documents	cre_Doc_Template_Mgt
SELECT template_id FROM Templates EXCEPT SELECT template_id FROM Documents	cre_Doc_Template_Mgt
select count(*) from Templates	cre_Doc_Template_Mgt
select count(*) from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select distinct Template_Type_Code from Ref_Template_Types	cre_Doc_Template_Mgt
select distinct Template_Type_Code from Ref_Template_Types	cre_Doc_Template_Mgt
SELECT template_id FROM Templates WHERE template_type_code  =  "PP" OR template_type_code  =  "PPT"	cre_Doc_Template_Mgt
SELECT template_id FROM Templates WHERE template_type_code  =  "PP" OR template_type_code  =  "PPT"	cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code group by Ref_Template_Types.Template_Type_Code	cre_Doc_Template_Mgt
select Template_Type_Code, count(*) from Templates group by Template_Type_Code	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Templates.Template_Type_Code from Templates group by Templates.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Ref_Template_Types as T1 join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code group by T1.Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
SELECT min(Version_Number) ,  template_type_code FROM Templates	cre_Doc_Template_Mgt
SELECT min(Version_Number) ,  template_type_code FROM Templates	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Documents as T1 join Templates as T2 on T1.Template_ID = T2.Template_ID where T1.Document_Name = "Data base"	cre_Doc_Template_Mgt
SELECT T1.template_type_code FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id WHERE T2.document_name  =  "Data base"	cre_Doc_Template_Mgt
select T1.Document_Name from Documents as T1 join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select T1.Document_Name from Documents as T1 join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID group by Ref_Template_Types.Template_Type_Code	cre_Doc_Template_Mgt
SELECT T1.template_type_code ,  count(*) FROM Templates AS T1 JOIN Documents AS T2 ON T1.template_id  =  T2.template_id GROUP BY T1.template_type_code	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code from Documents join Templates on Documents.Template_ID = Templates.Template_ID join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code group by Ref_Template_Types.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Templates.Template_Type_Code from Documents join Templates on Documents.Template_ID = Templates.Template_ID group by Templates.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Code not in (select Template_Type_Code from Templates)	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types except select distinct t.Template_Type_Code from Templates t join Documents d on t.Template_ID = d.Template_ID	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select distinct Ref_Template_Types.Template_Type_Description from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID	cre_Doc_Template_Mgt
select distinct Ref_Template_Types.Template_Type_Description from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID	cre_Doc_Template_Mgt
select Templates.Template_ID from Templates join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code where Ref_Template_Types.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select T1.Template_ID from Templates as T1 join Ref_Template_Types as T2 on T1.Template_Type_Code = T2.Template_Type_Code where T2.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
SELECT count(*) FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_ID  =  T2.document_ID WHERE T2.document_name  =  'Summer Show'	cre_Doc_Template_Mgt
select count(*) from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Summer Show"	cre_Doc_Template_Mgt
select Paragraph_ID, Document_ID, Paragraph_Text, Other_Details from Paragraphs where Paragraph_Text = "Korea"	cre_Doc_Template_Mgt
select Paragraph_ID, Document_ID, Paragraph_Text, Other_Details from Paragraphs where Paragraph_Text like "%Korea%"	cre_Doc_Template_Mgt
select Paragraphs.Paragraph_ID, Paragraphs.Paragraph_Text from Paragraphs join Documents on Documents.Document_ID = Paragraphs.Document_ID where Documents.Document_Name = "Welcome to NY"	cre_Doc_Template_Mgt
SELECT T1.paragraph_id ,   T1.paragraph_text FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id WHERE T2.Document_Name  =  'Welcome to NY'	cre_Doc_Template_Mgt
select Paragraphs.Paragraph_Text from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select Paragraphs.Paragraph_Text from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select Documents.Document_ID, count(*) from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID order by Documents.Document_ID	cre_Doc_Template_Mgt
select Documents.Document_ID, count(*) from Documents join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID order by Documents.Document_ID asc	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name, count(T2.Paragraph_ID) from Documents as T1 left join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID, T1.Document_Name	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name, count(T2.Paragraph_ID) from Documents as T1 left join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*)  >=  2	cre_Doc_Template_Mgt
select T1.Document_ID from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID having count(T2.Paragraph_ID) >= 2	cre_Doc_Template_Mgt
SELECT T1.document_id ,  T2.document_name FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id GROUP BY T1.document_id ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
SELECT T1.document_id ,  T2.document_name FROM Paragraphs AS T1 JOIN Documents AS T2 ON T1.document_id  =  T2.document_id GROUP BY T1.document_id ORDER BY count(*) DESC LIMIT 1	cre_Doc_Template_Mgt
select p.Document_ID from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by p.Document_ID order by count(*) asc limit 1	cre_Doc_Template_Mgt
select Paragraphs.Document_ID from Paragraphs group by Paragraphs.Document_ID order by count(*) asc limit 1	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) BETWEEN 1 AND 2	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs GROUP BY document_id HAVING count(*) BETWEEN 1 AND 2	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Brazil' INTERSECT SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Ireland'	cre_Doc_Template_Mgt
SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Brazil' INTERSECT SELECT document_id FROM Paragraphs WHERE paragraph_text  =  'Ireland'	cre_Doc_Template_Mgt
