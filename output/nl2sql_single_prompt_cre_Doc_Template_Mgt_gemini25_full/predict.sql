select count(*) from Documents	cre_Doc_Template_Mgt
select count(*) from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select count(distinct Template_ID) from Documents	cre_Doc_Template_Mgt
select count(distinct Template_ID) from Documents	cre_Doc_Template_Mgt
select count(T1.Document_ID) from Documents as T1 inner join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select count(T1.Document_ID) from Documents as T1 inner join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select T1.Template_ID, count(T2.Document_ID) from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_ID	cre_Doc_Template_Mgt
select Template_ID, count(Template_ID) from Documents group by Template_ID	cre_Doc_Template_Mgt
select T1.Template_ID, T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_ID order by count(T2.Document_ID) desc limit 1	cre_Doc_Template_Mgt
select T1.Template_ID, T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_ID, T1.Template_Type_Code order by count(T2.Document_ID) desc limit 1	cre_Doc_Template_Mgt
select Template_ID from Documents group by Template_ID having count(Document_ID) > 1	cre_Doc_Template_Mgt
select Template_ID from Documents group by Template_ID having count(Document_ID) > 1	cre_Doc_Template_Mgt
select Template_ID from Templates except select Template_ID from Documents	cre_Doc_Template_Mgt
select Template_ID from Templates except select Template_ID from Documents	cre_Doc_Template_Mgt
select count(*) from Templates	cre_Doc_Template_Mgt
select count(*) from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select distinct Template_Type_Code from Templates	cre_Doc_Template_Mgt
select distinct Template_Type_Code from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_Type_Code in ("PP", "PPT")	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_Type_Code in ("PP", "PPT")	cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	cre_Doc_Template_Mgt
select count(T1.Template_ID) from Templates as T1 inner join Ref_Template_Types as T2 on T1.Template_Type_Code = T2.Template_Type_Code where T2.Template_Type_Description = "CV"	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select T1.Template_Type_Code, count(T2.Template_ID) from Ref_Template_Types as T1 left join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code group by T1.Template_Type_Code	cre_Doc_Template_Mgt
select Template_Type_Code, count(Template_ID) from Templates group by Template_Type_Code	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code order by count(Template_ID) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code order by count(Template_ID) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates order by Version_Number asc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code, Version_Number from Templates order by Version_Number asc limit 1	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Templates as T1 inner join Documents as T2 on T1.Template_ID = T2.Template_ID where T2.Document_Name = "Data base"	cre_Doc_Template_Mgt
select T2.Template_Type_Code from Documents as T1 inner join Templates as T2 on T1.Template_ID = T2.Template_ID where T1.Document_Name = "Data base"	cre_Doc_Template_Mgt
select T1.Document_Name from Documents as T1 inner join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select T1.Document_Name from Documents as T1 inner join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select T1.Template_Type_Code, count(T3.Document_ID) from Ref_Template_Types as T1 left join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code left join Documents as T3 on T2.Template_ID = T3.Template_ID group by T1.Template_Type_Code	cre_Doc_Template_Mgt
select T1.Template_Type_Code, count(T3.Document_ID) from Ref_Template_Types as T1 join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code left join Documents as T3 on T2.Template_ID = T3.Template_ID group by T1.Template_Type_Code	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_Type_Code order by count(T2.Document_ID) desc limit 1	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID group by T1.Template_Type_Code order by count(T2.Document_ID) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Code not in ( select T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID )	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types except select T1.Template_Type_Code from Templates as T1 join Documents as T2 on T1.Template_ID = T2.Template_ID	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select distinct T2.Template_Type_Description from Templates as T1 inner join Ref_Template_Types as T2 on T1.Template_Type_Code = T2.Template_Type_Code where T1.Template_ID in ( select Template_ID from Documents )	cre_Doc_Template_Mgt
select distinct T1.Template_Type_Description from Ref_Template_Types as T1 inner join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code inner join Documents as T3 on T2.Template_ID = T3.Template_ID	cre_Doc_Template_Mgt
select T1.Template_ID from Templates as T1 inner join Ref_Template_Types as T2 on T1.Template_Type_Code = T2.Template_Type_Code where T2.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select T1.Template_ID from Templates as T1 inner join Ref_Template_Types as T2 on T1.Template_Type_Code = T2.Template_Type_Code where T2.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
select count(T1.Paragraph_ID) from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Summer Show"	cre_Doc_Template_Mgt
select count(T1.Paragraph_ID) from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Summer Show"	cre_Doc_Template_Mgt
select * from Paragraphs where Paragraph_Text = "Korea "	cre_Doc_Template_Mgt
select * from Paragraphs where Paragraph_Text like "%Korea %"	cre_Doc_Template_Mgt
select T1.Paragraph_ID, T1.Paragraph_Text from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Welcome to NY"	cre_Doc_Template_Mgt
select T1.Paragraph_ID, T1.Paragraph_Text from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Welcome to NY"	cre_Doc_Template_Mgt
select T1.Paragraph_Text from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select T1.Paragraph_Text from Paragraphs as T1 inner join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select Document_ID, count(Paragraph_ID) from Paragraphs group by Document_ID order by Document_ID	cre_Doc_Template_Mgt
select Document_ID, count(Paragraph_ID) from Paragraphs group by Document_ID order by Document_ID	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name, count(T2.Paragraph_ID) from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID, T1.Document_Name	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name, count(T2.Paragraph_ID) from Documents as T1 inner join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID, T1.Document_Name	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) >= 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) >= 2	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID order by count(T2.Paragraph_ID) desc limit 1	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name from Documents as T1 inner join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID order by count(T2.Paragraph_ID) desc limit 1	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID order by count(Paragraph_ID) asc limit 1	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID order by count(Paragraph_ID) asc limit 1	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) between 1 and 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(Paragraph_ID) between 1 and 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs where Paragraph_Text in ("Brazil", "Ireland") group by Document_ID having count(distinct Paragraph_Text) = 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs where Paragraph_Text like "%Brazil%" intersect select Document_ID from Paragraphs where Paragraph_Text like "%Ireland%"	cre_Doc_Template_Mgt
