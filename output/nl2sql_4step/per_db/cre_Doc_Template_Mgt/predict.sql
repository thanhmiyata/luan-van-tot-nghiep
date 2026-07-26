select count(*) from Documents	cre_Doc_Template_Mgt
select count(*) from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select count(distinct Documents.Template_ID) from Documents	cre_Doc_Template_Mgt
select count(distinct Template_Type_Code) from Templates	cre_Doc_Template_Mgt
select count(*) from Documents join Templates on Documents.Template_ID = Templates.Template_ID where Templates.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select count(*) from Documents join Templates on Documents.Template_ID = Templates.Template_ID where Templates.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select Templates.Template_ID, count(Documents.Document_ID) from Templates left join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID	cre_Doc_Template_Mgt
select Template_ID, count(*) from Documents group by Template_ID	cre_Doc_Template_Mgt
select Templates.Template_ID, Templates.Template_Type_Code from Templates join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID, Templates.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Templates.Template_ID, Templates.Template_Type_Code from Templates join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID, Templates.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_ID from Documents group by Template_ID having count(*) > 1	cre_Doc_Template_Mgt
select T2.Template_ID from Documents as T2 group by T2.Template_ID having count(T2.Template_ID) > 1	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_ID not in (select Template_ID from Documents)	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_ID not in (select Template_ID from Documents)	cre_Doc_Template_Mgt
select count(Template_ID) from Templates	cre_Doc_Template_Mgt
select count(*) from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select distinct Template_Type_Code from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_Type_Code in ("PP", "PPT")	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_Type_Code in ("PP", "PPT")	cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select Templates.Template_Type_Code, count(*) from Templates group by Templates.Template_Type_Code	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code, count(Templates.Template_ID) as "count of Templates" from Ref_Template_Types left join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code group by Ref_Template_Types.Template_Type_Code	cre_Doc_Template_Mgt
select T.Template_Type_Code from Templates as T group by T.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code group by Ref_Template_Types.Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code group by Ref_Template_Types.Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
select min(Version_Number), Template_Type_Code from Templates group by Template_Type_Code order by min(Version_Number) asc	cre_Doc_Template_Mgt
select min(Version_Number), Template_Type_Code from Templates group by Template_Type_Code	cre_Doc_Template_Mgt
select T2.Template_Type_Code from Documents as T1 join Templates as T3 on T1.Template_ID = T3.Template_ID join Ref_Template_Types as T2 on T3.Template_Type_Code = T2.Template_Type_Code where T1.Document_Name = "Data base"	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Ref_Template_Types as T1 join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code join Documents as T3 on T2.Template_ID = T3.Template_ID where T3.Document_Name = "Data base"	cre_Doc_Template_Mgt
select Document_Name from Documents join Templates on Documents.Template_ID = Templates.Template_ID where Templates.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select T1.Document_Name from Documents as T1 join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID group by Ref_Template_Types.Template_Type_Code	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID group by Ref_Template_Types.Template_Type_Code	cre_Doc_Template_Mgt
select T.Template_Type_Code from Templates as T join Documents as D on T.Template_ID = D.Template_ID group by T.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Code not in (select Template_Type_Code from Templates where Template_ID in (select Template_ID from Documents))	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Code not in (select T.Template_Type_Code from Documents as D join Templates as T on D.Template_ID = T.Template_ID)	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select distinct Ref_Template_Types.Template_Type_Description from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID	cre_Doc_Template_Mgt
select distinct T1.Template_Type_Description from Ref_Template_Types as T1 join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code join Documents as T3 on T2.Template_ID = T3.Template_ID	cre_Doc_Template_Mgt
select Templates.Template_ID from Templates join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code where Ref_Template_Types.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select Templates.Template_ID from Templates join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code where Ref_Template_Types.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
select count(*) from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Summer Show"	cre_Doc_Template_Mgt
select count(*) from Paragraphs inner join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Summer Show"	cre_Doc_Template_Mgt
select Paragraph_ID, Document_ID, Paragraph_Text, Other_Details from Paragraphs where Paragraph_Text = "Korea"	cre_Doc_Template_Mgt
select Paragraph_ID, Document_ID, Paragraph_Text, Other_Details from Paragraphs where Paragraph_Text like "%Korea%"	cre_Doc_Template_Mgt
select T1.Paragraph_ID, T1.Paragraph_Text from Paragraphs as T1 join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Welcome to NY"	cre_Doc_Template_Mgt
select Paragraphs.Paragraph_ID, Paragraphs.Paragraph_Text from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Welcome to NY"	cre_Doc_Template_Mgt
select Paragraph_Text from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select T2.Paragraph_Text from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID where T1.Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select Documents.Document_ID, count(Paragraphs.Paragraph_ID) from Documents left join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID order by Documents.Document_ID asc	cre_Doc_Template_Mgt
select p.Document_ID, count(*) from Paragraphs as p group by p.Document_ID order by p.Document_ID asc	cre_Doc_Template_Mgt
select Documents.Document_ID, Documents.Document_Name, count(Paragraphs.Paragraph_ID) from Documents left join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID, Documents.Document_Name	cre_Doc_Template_Mgt
select Documents.Document_ID, Documents.Document_Name, count(Paragraphs.Paragraph_ID) from Documents left join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID, Documents.Document_Name	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) >= 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) >= 2	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID, T1.Document_Name order by count(T2.Paragraph_ID) desc limit 1	cre_Doc_Template_Mgt
select d.Document_ID, d.Document_Name from Documents d inner join Paragraphs p on d.Document_ID = p.Document_ID group by d.Document_ID, d.Document_Name order by count(*) desc limit 1	cre_Doc_Template_Mgt
select p.Document_ID from Paragraphs p group by p.Document_ID order by count(*) asc limit 1	cre_Doc_Template_Mgt
select d.Document_ID from Documents d join Paragraphs p on d.Document_ID = p.Document_ID group by d.Document_ID order by count(*) asc limit 1	cre_Doc_Template_Mgt
select T1.Document_ID from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID having count(*) between 1 and 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) between 1 and 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs where Paragraph_Text like "%Brazil%" intersect select Document_ID from Paragraphs where Paragraph_Text like "%Ireland%"	cre_Doc_Template_Mgt
select Document_ID from Paragraphs where Paragraph_Text like "%Brazil%" intersect select Document_ID from Paragraphs where Paragraph_Text like "%Ireland%"	cre_Doc_Template_Mgt
