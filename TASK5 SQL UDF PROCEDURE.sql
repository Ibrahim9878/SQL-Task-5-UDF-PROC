USE [Library]
--Stored Procedure
--1. Parametr kimi gonderilen ededin faktorialin hesablayan "Factorial" SP yaradin (5! = 1*2*3*4*5 = 120)
--(0! = 1) (nezere alin ki, menfi ededin faktoriali olmur).
 
CREATE PROC Faktorial
@num AS int
AS
BEGIN
	IF @num < 0 
	BEGIN
		PRINT 'MENFININ FAKTORIAL YOXDI'
		RETURN
	END
	ELSE 
	BEGIN
		IF @num = 0
		BEGIN
			PRINT '1'
			RETURN
		END
		ELSE 
		BEGIN
			DECLARE @hasil AS int = 1
			WHILE @num >= 1
			BEGIN
				SET @hasil = @hasil * @num
				SET @num = @num - 1
			END
			PRINT @hasil
		END
	END
END
 
EXEC Faktorial 0
 
--2. "LazyStudents" SP yaradin. SP hech vaxt kitabxanadan kitab goturmeyen
-- telebelerin siyahisini gosterir ve output parametr olaraq bele telebelerin sayini qaytarir
 
CREATE PROC LazyStudents
@count AS int OUTPUT
AS
BEGIN
	SELECT @count = COUNT(*)
	FROM Students AS S FULL OUTER JOIN S_Cards AS SC ON S.Id = SC.Id_Student
	WHERE S.Id IS NULL OR SC.Id_Student IS NULL
	RETURN @count
END
 
DECLARE @c AS INT 
EXEC LazyStudents @c OUTPUT
PRINT @c
 
--UDF
--1. Neshriyatlar ve onlarin minimal sehifeye malik kitablarinin
--siyahisini qaytaran funksiya yazin.
 
--CREATE FUNCTION [Neshriyatlar ve onlarin minimal sehifeye malik kitablariQ] ()
--RETURNS TABLE
--AS
--RETURN 
--(
--	SELECT DISTINCT P.[Name],  B.[Name], B.Pages
--	FROM PRESS AS P JOIN Books AS B ON P.Id = B.Id_Press 
--	GROUP BY P.[Name],B.[Name],B.Pages
--	ORDER BY B.Pages
 
--)
CREATE FUNCTION [Neshriyatlar_ve_minimal_sehifeye_malik_kitablar] ()
RETURNS TABLE
AS
RETURN 
(
    SELECT P.[Name] AS PressName, B.[Name] AS BookName, B.Pages AS Pages
    FROM Press AS P JOIN Books AS B ON P.Id = B.Id_Press
    WHERE B.Pages = (
        SELECT MIN(B2.Pages)
        FROM Books AS B2
        WHERE B2.Id_Press = B.Id_Press
    )
)

DROP FUNCTION Neshriyatlar_ve_minimal_sehifeye_malik_kitablar
SELECT *
FROM Neshriyatlar_ve_minimal_sehifeye_malik_kitablar()

--2. Chap etdiyi kitablarin Sehifelerinin ededi ortasi N-den chox olan 
--neshriyatlarin adini qaytaran funksiya yazin. N funksiyaya parametr kimi gonderilmelidir.

CREATE FUNCTION AVGBoyuk 
(@n AS int)
RETURNS TABLE
AS
RETURN
(
	SELECT P.[Name], AVG(B.Pages) AS AVGPages
	FROM Press AS P JOIN Books AS B ON P.Id = B.Id_Press
	GROUP BY P.[Name]
	HAVING AVG(B.Pages) > @n
)

SELECT *
FROM AVGBoyuk(100)
