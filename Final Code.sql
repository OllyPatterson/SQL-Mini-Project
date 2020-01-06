--The below code is designed to create a number of reference/lookup tables associated with the original HES subset
--The original data contained surrogate keys with no readable value, so the below code assigns each attribute with its own reference table to detail the description of what each surrogate means
--The last part of the code joins these references together in one final readable version of the data 

--Dimadmincat
IF OBJECT_ID('dbo.Dimadmincat') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimAdminCat
END
--this initial stage per attribute is essential to make sure the code is robust enough to drop/rejoin the data at will

SELECT DISTINCT
     admincat as ID
     ,CASE
		WHEN		   admincat = '1' THEN 'NHS patient'
                  WHEN admincat = '2' THEN 'Private patient'
                  WHEN admincat = '3' THEN 'Amenity patient: one who pays for the use of a single room or small ward'
				  WHEN admincat = '4' THEN 'A category II patient: one for whom work is undertaken by hospital medical or dental staff within categories II'
				  WHEN admincat = '98' THEN 'Not applicable'
				  WHEN admincat = '99' THEN 'Not Known: Validation error'
     END AS DESCRIPTION
--Above I have assigned the surrogate keys of the original dataset with the descriptions from the HES data dictionary
--This way, there is a readable desc for each attribute that does not include a surrogate reference
INTO DimAdminCat
--this has then been selected into a stand-alone table for the attribute AdminCat as seen directly above

FROM GWS
--GWS is the original dataset imported from Excel

--THE ABOVE CODING STEPS HAVE BEEN REPEATED FOR EACH ATTRIBUTE AS SEEN BELOW

--Dimadmincatst
IF OBJECT_ID('dbo.Dimadmincatst') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimAdminCatst
END

SELECT DISTINCT
     admincatst as ID
     ,CASE
		WHEN		   admincatst = '1' THEN 'NHS patient'
                  WHEN admincatst = '2' THEN 'Private patient'
                  WHEN admincatst = '3' THEN 'Amenity patient: one who pays for the use of a single room or small ward'
				  WHEN admincatst = '4' THEN 'A category II patient: one for whom work is undertaken by hospital medical or dental staff within categories II'
				  WHEN admincatst = '98' THEN 'Not applicable'
				  WHEN admincatst = '99' THEN 'Not Known: Validation error'
     END AS DESCRIPTION
INTO DimAdminCatst
FROM GWS

--Dimadmimeth
IF OBJECT_ID('dbo.Dimadmimeth') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimAdmiMeth
END

SELECT DISTINCT
     admimeth as ID
     ,CASE
		WHEN admimeth = '11' THEN 'Waiting list. . A Patient admitted electively from a waiting list having been given no date of admission at a time a decision was made to admit'
		WHEN admimeth = '12' THEN 'Booked. A Patient admitted having been given a date at the time the decision to admit was made, determined mainly on the grounds of resource availability'
		WHEN admimeth = '13' THEN 'Planned. A Patient admitted, having been given a date or approximate date'
		WHEN admimeth = '21' THEN 'Accident and emergency or dental casualty department of the Health Care Provider'
		WHEN admimeth = '22' THEN 'General Practitioner: after a request for immediate admission has been made direct to a Hospital Provider, i.e. not through a Bed bureau, by a General Practitioner: or deputy'
		WHEN admimeth = '23' THEN 'Bed bureau'
		WHEN admimeth = '24' THEN 'Consultant Clinic, of this or another Health Care Provider'
		WHEN admimeth = '25' THEN 'Admission via Mental Health Crisis Resolution Team'
		WHEN admimeth = '28' THEN 'Other means'
		WHEN admimeth = '31' THEN 'Admitted ante-partum'
		WHEN admimeth = '32' THEN 'Admitted post-partum'
		WHEN admimeth = '2A' THEN 'Accident and Emergency Department of another provider' 
		WHEN admimeth = '2B' THEN 'Transfer of an admitted patient from another Hospital Provider'
		WHEN admimeth = '2C' THEN 'Baby born at home as intended'
		WHEN admimeth = '2D' THEN 'Other emergency admission'

ELSE isnull(NULL, 'Not Known')
--as there were substantial NULL values in the dataset, this line of code is to replace that with a commonly associated term of 'Not known' (as used by the HES data input team)
     END AS DESCRIPTION
INTO DimAdmiMeth
FROM GWS


--Dimadmisorc
IF OBJECT_ID('dbo.Dimadmisorc') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimAdmiSorc
END

SELECT DISTINCT
     Admisorc as ID
     ,CASE
	WHEN ADMISORC = 19 THEN 'The usual place of residence, unless otherwise listed'
    WHEN ADMISORC = 29 THEN 'Temporary place of residence when usually resident elsewhere, for example'
    WHEN ADMISORC = 48 THEN 'High security psychiatric hospital, Scotland (1999-00 to 2006-07)'
    WHEN ADMISORC = 53 THEN 'NHS other hospital provider: ward for patients who are mentally ill'
    WHEN ADMISORC = 54 THEN 'NHS run Care Home'
    WHEN ADMISORC = 66 THEN 'Local authority foster care, but not in residential accommodation'
    WHEN ADMISORC = 69 THEN 'Local authority home or care (1989-90 to 1995-96)'
    WHEN ADMISORC = 87 THEN 'Non-NHS run hospital'
     END AS DESCRIPTION

INTO DimAdmiSorc
FROM GWS

--DimCategory
IF OBJECT_ID('dbo.DimCategory') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimCategory
END


SELECT DISTINCT
     category as ID
     ,CASE
		WHEN		   Category = 11 THEN 'NHS patient: formally detained under Part II of the Mental Health Act 1983'
                  WHEN Category = 12 THEN 'NHS patient: formally detained under Part III of the Mental Health Act 1983 or under other Acts'
                  WHEN Category = 10 THEN 'NHS patient: not formally detained'
				  WHEN Category = 31 THEN 'Amenity patient: formally detained under Part II of the Mental Health Act 1983'
				  WHEN Category = 30 THEN 'Amenity patient: not formally detained' 
				  WHEN Category = 32 THEN 'White and Asian (Mixed)' 
				  WHEN Category = 20 THEN 'Private patient: not formally detained'
				  WHEN Category = 22 THEN 'Private patient: formally detained under Part III of the Mental Health Act 1983 or under other Acts'
				  WHEN Category = 21 THEN 'Private patient: formally detained under Part II of the Mental Health Act 1983'
				  ELSE 'Not Known'
     END AS DESCRIPTION

INTO DimCategory
FROM GWS


IF OBJECT_ID('dbo.DimClasspat') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimClassPat
END

--DimClassPat
SELECT DISTINCT
     Classpat as ID
     ,CASE
      WHEN classpat = 1 THEN 'Ordinary admission'
      WHEN classpat = 2 THEN 'Day case admission'
      WHEN classpat = 3 THEN 'Regular day attender'
      WHEN classpat = 4 THEN 'Regular night attender'
      WHEN classpat = 5 THEN 'Mothers and babies using only delivery facilities'
      WHEN classpat = 8 THEN 'Not applicable (other maternity event)'
      WHEN classpat = 9 THEN 'Not known'
     END AS DESCRIPTION
INTO DimClassPat
FROM GWS

--DimElecdur
IF OBJECT_ID('dbo.DimElecdur') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimElecDur
END

SELECT DISTINCT
     elecdur as ID
     ,CASE
		WHEN		   try_cast(elecdur as varchar(50)) = '9998' THEN 'Not applicable'
                  WHEN try_cast(elecdur as varchar(50)) = '9999' THEN 'Not known'
			ELSE try_cast(elecdur as varchar(50))
     END AS DESCRIPTION

INTO DimElecDur
FROM GWS


--DimEpitype
IF OBJECT_ID('dbo.DimEpitype') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimEpitype
END


SELECT DISTINCT
     epitype as ID
     ,CASE
		WHEN		   epitype = '1' THEN 'General episode (anything that is not covered by the other codes)'
                  WHEN epitype = '2' THEN 'Delivery episode'
                  WHEN epitype = '3' THEN 'Birth episode'
				  WHEN epitype = '4' THEN 'Formally detained under the provisions of mental health legislation'
				  WHEN epitype = '5' THEN 'Other delivery event' 
ELSE isnull(NULL, 'Not Known')
     END AS DESCRIPTION

INTO DimEpitype
FROM GWS

----DimEthnos
IF OBJECT_ID('DimEthnos') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimEthnos
END

SELECT DISTINCT
     ETHNOS as ID
     ,CASE
		WHEN ETHNOS = 'H' THEN 'Indian (Asian or Asian British)'
                  WHEN ETHNOS = 'A' THEN 'British (White)'
                  WHEN ETHNOS = 'K' THEN 'Bangladeshi (Asian or Asian British)'
				  WHEN ETHNOS = 'N' THEN 'African (Black or Black British)'
				  WHEN ETHNOS = 'D' THEN 'White and Black Caribbean (Mixed)' 
				  WHEN ETHNOS = 'F' THEN 'White and Asian (Mixed)' 
				  WHEN ETHNOS = 'L' THEN 'Any other Asian background'
				  WHEN ETHNOS = 'B' THEN 'Irish (White)'
ELSE isnull(NULL, 'Not Known')
     END AS DESCRIPTION

INTO DimEthnos

--DimLeglcat
IF OBJECT_ID('DimLeglcat') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimLeglCat
END


SELECT DISTINCT
     leglcat as ID
     ,CASE
			WHEN LEGLCAT = 1  THEN 'Informal'
			WHEN LEGLCAT = 2  THEN 'Formally detained under the Mental Health Act, Section 2'
			WHEN LEGLCAT = 3  THEN 'Formally detained under the Mental Health Act, Section 3'
			WHEN LEGLCAT = 4  THEN 'Formally detained under the Mental Health Act, Section 4'
			WHEN LEGLCAT = 5  THEN 'Formally detained under the Mental Health Act, Section 5(2)'
			WHEN LEGLCAT = 6  THEN 'Formally detained under the Mental Health Act, Section 5(4)'
			WHEN LEGLCAT = 7  THEN 'Formally detained under the Mental Health Act, Section 35'
			WHEN LEGLCAT = 8  THEN 'Formally detained under the Mental Health Act, Section 36'
			WHEN LEGLCAT = 9  THEN 'Formally detained under the Mental Health Act, Section 37 with Section 41 restrictions'
			WHEN LEGLCAT = 10 THEN 'Formally detained under the Mental Health Act, Section 37 excluding Section 37(4)'
			WHEN LEGLCAT = 11 THEN 'Formally detained under the Mental Health Act, Section 37(4)'
			WHEN LEGLCAT = 12 THEN 'Formally detained under the Mental Health Act, Section 38'
			WHEN LEGLCAT = 13 THEN 'Formally detained under the Mental Health Act, Section 44'
			WHEN LEGLCAT = 14 THEN 'Formally detained under the Mental Health Act, Section 46'
			WHEN LEGLCAT = 15 THEN 'Formally detained under the Mental Health Act, Section 47 with Section 49 restrictions'
			WHEN LEGLCAT = 16 THEN 'Formally detained under the Mental Health Act, Section 47'
			WHEN LEGLCAT = 17 THEN 'Formally detained under the Mental Health Act, Section 48 with Section 49 restrictions'
			WHEN LEGLCAT = 18 THEN 'Formally detained under the Mental Health Act, Section 48'
			WHEN LEGLCAT = 19 THEN 'Formally detained under the Mental Health Act, Section 135'
			WHEN LEGLCAT = 20 THEN 'Formally detained under the Mental Health Act, Section 136'
			WHEN LEGLCAT = 21 THEN 'Formally detained under the previous legislation (fifth schedule)'
			WHEN LEGLCAT = 22 THEN 'Formally detained under Criminal Procedure (Insanity) Act 1964 as amended by the Criminal Procedures (Insanity and Unfitness to Plead) Act 1991'
			WHEN LEGLCAT = 23 THEN 'Formally detained under other Acts'
			WHEN LEGLCAT = 24 THEN 'Supervised discharge under the Mental Health (Patients in the Community) Act 1995'
			WHEN LEGLCAT = 25 THEN 'Formally detained under the Mental Health Act, Section 45A'
			WHEN LEGLCAT = 26 THEN 'Not applicable'
			WHEN LEGLCAT = 27 THEN 'Not Known'
	ELSE isnull(NULL, 'Not Known')
     END AS DESCRIPTION

INTO DimLeglCat
FROM GWS

--DimSpellbgin
IF OBJECT_ID('Dimspellbgin') IS NOT NULL
BEGIN
     DROP TABLE dbo.DimSpellBgin
END

SELECT DISTINCT
     spellbgin as ID
     ,CASE
		WHEN		   spellbgin = '0' THEN 'Not the first episode of spell'
                  WHEN spellbgin = '1' THEN 'First episode of spell that started in a previous year'
                  WHEN spellbgin = '2' THEN 'First episode of spell that started in current year'

     END AS DESCRIPTION

INTO DimSpellBgin
FROM GWS

--DimSex
IF OBJECT_ID('dbo.DimSex') IS NOT NULL

BEGIN
     DROP TABLE dbo.DimSex
END

SELECT DISTINCT
     Sex as ID,
     CASE
		when sex = '1' then 'Male'  
		when sex = '2' then 'Female'  
		when sex = '9' then 'Not specified'  
		when sex = '0' then 'Not known'  
     END
	 AS DESCRIPTION
	 INTO DIMSEX
	 FROM GWS

--DimEpistat
IF OBJECT_ID('dbo.DimEpistat') IS NOT NULL

BEGIN
     DROP TABLE dbo.DimEpistat

END

SELECT DISTINCT

     Epistat as ID,
     CASE
		when epistat = '1' then 'Unfinished'  
		when epistat = '3' then 'Finished'  
		when epistat = '9' then 'Derived unfinished'
		else 'Not Known' 

     END
	 AS DESCRIPTION
	 INTO DIMEPISTAT
	 FROM GWS

--Code to Join the above Reference tables together in one readable version of the data
select 
gws.[ID no#]
,gws.hesid as HesID
,gws.episode as Episode
,gws.lopatid as Lopatid
,try_cast(gws.epistart as date) as Epistart
,try_cast(gws.epiend as date) as Epiend
,try_cast(gws.dob as date) as DOB
,datediff(year, DOB, epistart) as Startage
,datediff(year, DOB, epiend) as Endage
--using datediff for Start and End age removed a lot of the DQ errors associated with age. 
--A lot of cases the endage was lower than the start age, and 'admiage' and 'activage' were almost exclusively wrong
--Therefore, in the final readable version, it made sense to only include DOB with the start and end age calculated properly using the datediff function in SQL
,DimSex.Description as Sex
,isnull(DimEpitype.Description, 'Not Known') as Epitype
,DimEpistat.description as Epistat
,DimSpellbgin.description as Spelbgin
,DimadminCat.description as Admincat
,DimCategory.description as Category
,isnull(Dimethnos.description, 'Not Known') as Ethnos
,isnull(Dimleglcat.description, 'Not Known') as Leglcat
,isnull(DimAdmiMeth.description,'Not Known') as Admimeth
--using isnull to further correct the presence of NULLS by replacing them with a consistent use 'Not Known'
,DimAdmisorc.description as Admisorc
,Dimelecdur.description as Elecdur
,Dimclasspat.description as Classpat
/*
into GWSFINAL
seen above, i have commented out the final section which selects the big join into a standalone table of its own
this means it can then be simply imported into tableau for visualization of the humanly readable version of the data
*/
from GWS
left join DimSex on DimSex.ID = GWS.sex
left join Dimepitype on Dimepitype.ID = GWS.epitype
left join DimEpistat on Dimepistat.ID = GWS.Epistat
left join DimSpellbgin on Dimspellbgin.ID = GWS.Spellbgin
left join DimAdminCat on Dimadmincat.ID = GWS.admincat
left join Dimadmincatst on Dimadmincatst.ID = GWS.admincatst
left Join dimcategory on Dimcategory.ID = GWS.category
left join dimethnos on Dimethnos.ID = GWS.ethnos
left join dimleglcat on dimleglcat.ID = GWS.leglcat
left join dimadmimeth on dimadmimeth.ID = GWS.admimeth
left join dimadmisorc on dimadmisorc.ID = GWS.admisorc
left join dimelecdur on dimelecdur.ID = gws.elecdur
left join dimclasspat on dimclasspat.ID = GWS.classpat
order by [ID no#]
