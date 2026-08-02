SELECT COUNT(*) AS COUNT_Documents FROM Documents
SELECT COUNT(*) AS count FROM Documents
SELECT Document_ID, Document_Name, Document_Description FROM Documents
SELECT Document_ID, Document_Name, Document_Description FROM Documents
SELECT Document_Name, Template_ID FROM Documents WHERE Document_Description LIKE '%w%'
SELECT Document_Name, Template_ID FROM Documents WHERE Document_Description LIKE '%w%'
SELECT Document_ID, Template_ID, Document_Description FROM Documents WHERE Document_Name = 'Robbin CV'
SELECT Document_ID, Template_ID, Document_Description FROM Documents WHERE Document_Name = 'Robbin CV'
SELECT COUNT(DISTINCT Templates.Template_ID) AS number_of_templates FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID
SELECT COUNT(DISTINCT Template_Type_Code) FROM Templates
SELECT COUNT(*) FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Templates.Template_Type_Code = 'PPT'
SELECT COUNT(*) AS count FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Templates.Template_Type_Code = 'PPT'
SELECT Templates.Template_ID, COUNT(*) AS count_of_documents FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Templates.Template_ID
SELECT Template_ID, COUNT(*) FROM Documents GROUP BY Template_ID
SELECT Templates.Template_ID, Templates.Template_Type_Code FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Templates.Template_ID, Templates.Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Templates.Template_ID, Templates.Template_Type_Code FROM Templates JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Templates.Template_ID, Templates.Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Documents.Template_ID FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID GROUP BY Documents.Template_ID HAVING COUNT(*) > 1
SELECT d.Template_ID FROM Documents AS d INNER JOIN Templates AS t ON d.Template_ID = t.Template_ID GROUP BY d.Template_ID HAVING COUNT(*) > 1
SELECT Template_ID FROM Templates WHERE NOT Template_ID IN (SELECT Template_ID FROM Documents)
SELECT Template_ID FROM Templates WHERE NOT Template_ID IN (SELECT Template_ID FROM Documents)
SELECT COUNT(Template_ID) FROM Templates
SELECT COUNT(*) AS count FROM Templates
SELECT Template_ID, Version_Number, Template_Type_Code FROM Templates
SELECT Template_ID, Version_Number, Template_Type_Code FROM Templates
SELECT DISTINCT Template_Type_Code FROM Ref_Template_Types
SELECT Template_Type_Code FROM Ref_Template_Types
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT Template_ID FROM Templates WHERE Template_Type_Code IN ('PP', 'PPT')
SELECT COUNT(*) AS count FROM Templates WHERE Template_Type_Code = 'CV'
SELECT COUNT(*) FROM Templates WHERE Template_Type_Code = 'CV'
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Version_Number, Template_Type_Code FROM Templates WHERE Version_Number > 5
SELECT Ref_Template_Types.Template_Type_Code, COUNT(*) AS count FROM Templates INNER JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code
SELECT Ref_Template_Types.Template_Type_Code, COUNT(Templates.Template_ID) AS "Count of Templates" FROM Ref_Template_Types INNER JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code
SELECT Templates.Template_Type_Code FROM Templates INNER JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code GROUP BY Templates.Template_Type_Code ORDER BY COUNT(Templates.Template_ID) DESC LIMIT 1
SELECT Template_Type_Code FROM Templates GROUP BY Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code HAVING COUNT(*) < 3
SELECT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code HAVING COUNT(Templates.Template_ID) < 3
SELECT MIN(Version_Number), Template_Type_Code FROM Templates GROUP BY Template_Type_Code ORDER BY MIN(Version_Number) ASC
SELECT MIN(Version_Number) AS Version_Number, Template_Type_Code FROM Templates GROUP BY Template_Type_Code
SELECT r.Template_Type_Code FROM Documents AS d JOIN Templates AS t ON d.Template_ID = t.Template_ID JOIN Ref_Template_Types AS r ON t.Template_Type_Code = r.Template_Type_Code WHERE d.Document_Name = 'Data base'
SELECT rt.Template_Type_Code FROM Documents AS d JOIN Templates AS t ON d.Template_ID = t.Template_ID JOIN Ref_Template_Types AS rt ON t.Template_Type_Code = rt.Template_Type_Code WHERE d.Document_Name = 'Data base'
SELECT Document_Name FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Templates.Template_Type_Code = 'BK'
SELECT Document_Name FROM Documents JOIN Templates ON Documents.Template_ID = Templates.Template_ID WHERE Templates.Template_Type_Code = 'BK'
SELECT Ref_Template_Types.Template_Type_Code, COUNT(*) AS number_of_documents FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Ref_Template_Types.Template_Type_Code
SELECT Ref_Template_Types.Template_Type_Code, COUNT(*) AS Document_Count FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code JOIN Documents ON Templates.Template_ID = Documents.Template_ID GROUP BY Ref_Template_Types.Template_Type_Code
SELECT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code JOIN Documents ON Documents.Template_ID = Templates.Template_ID GROUP BY Ref_Template_Types.Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Ref_Template_Types.Template_Type_Code FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code GROUP BY Ref_Template_Types.Template_Type_Code ORDER BY COUNT(*) DESC LIMIT 1
SELECT Template_Type_Code FROM Ref_Template_Types WHERE NOT Template_Type_Code IN (SELECT Template_Type_Code FROM Templates WHERE Template_ID IN (SELECT Template_ID FROM Documents))
SELECT Template_Type_Code FROM Ref_Template_Types WHERE NOT Template_Type_Code IN (SELECT T.Template_Type_Code FROM Documents AS D JOIN Templates AS T ON D.Template_ID = T.Template_ID)
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT Template_Type_Code, Template_Type_Description FROM Ref_Template_Types
SELECT Template_Type_Description FROM Ref_Template_Types WHERE Template_Type_Code = 'AD'
SELECT Template_Type_Description FROM Ref_Template_Types WHERE Template_Type_Code = 'AD'
SELECT Template_Type_Code FROM Ref_Template_Types WHERE Template_Type_Description = 'Book'
SELECT Template_Type_Code FROM Ref_Template_Types WHERE Template_Type_Description = 'Book'
SELECT DISTINCT Ref_Template_Types.Template_Type_Description FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code JOIN Documents ON Templates.Template_ID = Documents.Template_ID
SELECT DISTINCT Ref_Template_Types.Template_Type_Description FROM Ref_Template_Types JOIN Templates ON Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code JOIN Documents ON Templates.Template_ID = Documents.Template_ID
SELECT Templates.Template_ID FROM Templates JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code WHERE Ref_Template_Types.Template_Type_Description = 'Presentation'
SELECT Templates.Template_ID FROM Templates JOIN Ref_Template_Types ON Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code WHERE Ref_Template_Types.Template_Type_Description = 'Presentation'
SELECT COUNT(*) AS count FROM Paragraphs
SELECT COUNT(*) FROM Paragraphs
SELECT COUNT(*) AS paragraph_count FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Documents.Document_Name = 'Summer Show'
SELECT COUNT(*) AS count FROM Paragraphs INNER JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Documents.Document_Name = 'Summer Show'
SELECT Paragraph_ID, Document_ID, Paragraph_Text, Other_Details FROM Paragraphs WHERE Paragraph_Text = 'Korea'
SELECT Paragraph_ID, Document_ID, Paragraph_Text, Other_Details FROM Paragraphs WHERE Paragraph_Text LIKE '%Korea%'
SELECT Paragraphs.Paragraph_ID, Paragraphs.Paragraph_Text FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Documents.Document_Name = 'Welcome to NY'
SELECT Paragraphs.Paragraph_ID, Paragraphs.Paragraph_Text FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Documents.Document_Name = 'Welcome to NY'
SELECT Paragraph_Text FROM Paragraphs JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID WHERE Document_Name = 'Customer reviews'
SELECT Paragraphs.Paragraph_Text FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID WHERE Documents.Document_Name = 'Customer reviews'
SELECT Documents.Document_ID, COUNT(*) AS Paragraph_count FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID ORDER BY Documents.Document_ID ASC
SELECT Documents.Document_ID, COUNT(*) AS number_of_paragraphs FROM Documents JOIN Paragraphs ON Paragraphs.Document_ID = Documents.Document_ID GROUP BY Paragraphs.Document_ID ORDER BY Documents.Document_ID ASC
SELECT Documents.Document_ID, Documents.Document_Name, COUNT(Paragraphs.Paragraph_ID) FROM Documents INNER JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID, Documents.Document_Name
SELECT Documents.Document_ID, Documents.Document_Name, COUNT(Paragraphs.Paragraph_ID) AS Paragraph_Count FROM Documents INNER JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID, Documents.Document_Name
SELECT Documents.Document_ID FROM Documents INNER JOIN Paragraphs ON Paragraphs.Document_ID = Documents.Document_ID GROUP BY Documents.Document_ID HAVING COUNT(Paragraphs.Paragraph_ID) >= 2
SELECT Documents.Document_ID FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID HAVING COUNT(*) >= 2
SELECT Documents.Document_ID, Documents.Document_Name FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID, Documents.Document_Name ORDER BY COUNT(*) DESC LIMIT 1
SELECT d.Document_ID, d.Document_Name FROM Documents AS d INNER JOIN Paragraphs AS p ON d.Document_ID = p.Document_ID GROUP BY d.Document_ID, d.Document_Name ORDER BY COUNT(*) DESC LIMIT 1
SELECT Paragraphs.Document_ID FROM Paragraphs INNER JOIN Documents ON Paragraphs.Document_ID = Documents.Document_ID GROUP BY Paragraphs.Document_ID ORDER BY COUNT(Paragraphs.Paragraph_ID) ASC LIMIT 1
SELECT d.Document_ID FROM Documents AS d JOIN Paragraphs AS p ON d.Document_ID = p.Document_ID GROUP BY d.Document_ID ORDER BY COUNT(*) ASC LIMIT 1
SELECT Documents.Document_ID FROM Documents JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID HAVING COUNT(*) BETWEEN 1 AND 2
SELECT Documents.Document_ID FROM Documents INNER JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID GROUP BY Documents.Document_ID HAVING COUNT(Paragraphs.Paragraph_ID) BETWEEN 1 AND 2
SELECT DISTINCT p.Document_ID FROM Paragraphs AS p JOIN Documents AS d ON p.Document_ID = d.Document_ID WHERE p.Paragraph_Text LIKE '%Brazil%' AND p.Paragraph_Text LIKE '%Ireland%'
SELECT Documents.Document_ID FROM Documents INNER JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID WHERE Paragraphs.Paragraph_Text LIKE '%Brazil%' INTERSECT SELECT Documents.Document_ID FROM Documents INNER JOIN Paragraphs ON Documents.Document_ID = Paragraphs.Document_ID WHERE Paragraphs.Paragraph_Text LIKE '%Ireland%'
