/*

Steps for updating D_PRACTICE table practice codes to make the database values match conservation practice plan paperwork codes.
The D_PRACTICE table has referential integrity with CONSERVATION and PRACTICE_PAYMENT database tables.
You can't chance the existing RR1, RR2, RR3, and RR4 codes due to referential integrity.
You have to add new codes, convert the referential data to the new codes, then delete the original codes from D_PRACTICE.
Complete all steps in TEST first and then complete them in PROD.

*/

--ALTER TABLE change PRACTICE_DESC size from 50 to 75 so longer names can fit

--Search for unused codes that are not tied to practice payments or cons plans.

SELECT
    P.PRACTICE_CODE,
    P.PRACTICE_DESC
FROM
    D_PRACTICE P
WHERE
    P.PRACTICE_CODE IN
        (
            SELECT P.PRACTICE_CODE
            FROM D_PRACTICE P
            LEFT JOIN CONSERVATION C ON P.PRACTICE_CODE = C.PRACTICE_CODE
            WHERE C.PRACTICE_CODE IS NULL
        )
    AND P.PRACTICE_CODE IN
        (
            SELECT P.PRACTICE_CODE
            FROM D_PRACTICE P
            LEFT JOIN CONSERVATION C ON P.PRACTICE_CODE = C.PRACTICE_CODE2
            WHERE C.PRACTICE_CODE2 IS NULL
        )
    AND P.PRACTICE_CODE IN
        (
            SELECT P.PRACTICE_CODE
            FROM D_PRACTICE P
            LEFT JOIN PRACTICE_PAYMENT PP ON P.PRACTICE_CODE = PP.PRACTICE_CODE
            WHERE PP.PRACTICE_CODE IS NULL
        )
    AND P.PRACTICE_CODE NOT IN('RR15','RRGP','RR1a','RR1b','RR2a','RR2b','RR3a','RR3b','RR4a','RR4b')
ORDER BY
    PRACTICE_CODE
;

SELECT
*
FROM CONSERVATION C
--INNER JOIN CONSERVATION_PLAN CP ON C.CONSERVATION_PLAN_ID = CP.CONSERVATION_PLAN_ID
WHERE C.PRACTICE_CODE IN 
(
'DONX',
'ACUB',
'LEKS',
'LEKSX',
'RR10X',
'RR11X',
'RR12X',
'RR13X',
'RR1X',
'RR2X',
'RR3X',
'RR4X',
'RR5X',
'RR6X',
'RR7X',
'RR8X',
'RR8a',
'RR9X',
'RRAPP',
'RRFBX',
'RRFE',
'RRFEX',
'RRFPX',
'RRTCX',
'WRP'
)
;
--Repeat query for C.PRACTICE_CODE2 and PRACTICE_PAYMENT.PRACTICE_CODE fields

--Delete unused codes

DELETE FROM
    D_PRACTICE P
WHERE
    P.PRACTICE_CODE IN
    (
    'DONX',
    'ACUB',
    'LEKS',
    'LEKSX',
    'RR10X',
    'RR11X',
    'RR12X',
    'RR13X',
    'RR1X',
    'RR2X',
    'RR3X',
    'RR4X',
    'RR5X',
    'RR6X',
    'RR7X',
    'RR8X',
    'RR8a',
    'RR9X',
    'RRAPP',
    'RRFBX',
    'RRFE',
    'RRFEX',
    'RRFPX',
    'RRTCX',
    'WRP'
    )
;

--Add new codes to D_PRACTICE table: (RR1a, RR1b, RR2a, RR2b, RR3a, RR3b, RR4a, RR4b)

--Update D_PRACTICE table sort order

--Run update scripts to change RR1, RR2, RR3, and RR4 to RR1a, RR2a, RR3a, and RR4a in CONSERVATION AND PRACTICE_PAYMENT tables
--SELECT records that will be updated to know the count for each script and confirm that count before committing the updates.

SELECT COUNT(*) FROM CONSERVATION C WHERE C.PRACTICE_CODE = 'RR1'; --1356
SELECT COUNT(*) FROM CONSERVATION C WHERE C.PRACTICE_CODE = 'RR2'; --5607
SELECT COUNT(*) FROM CONSERVATION C WHERE C.PRACTICE_CODE = 'RR3'; --2260
SELECT COUNT(*) FROM CONSERVATION C WHERE C.PRACTICE_CODE = 'RR4'; --171
SELECT COUNT(*) FROM CONSERVATION C WHERE C.PRACTICE_CODE = 'RR10'; -- 3116

UPDATE CONSERVATION C SET C.PRACTICE_CODE = 'RR1a' WHERE C.PRACTICE_CODE = 'RR1';
UPDATE CONSERVATION C SET C.PRACTICE_CODE = 'RR2a' WHERE C.PRACTICE_CODE = 'RR2';
UPDATE CONSERVATION C SET C.PRACTICE_CODE = 'RR3a' WHERE C.PRACTICE_CODE = 'RR3';
UPDATE CONSERVATION C SET C.PRACTICE_CODE = 'RR4a' WHERE C.PRACTICE_CODE = 'RR4';
UPDATE CONSERVATION C SET C.PRACTICE_CODE = 'RR3b' WHERE C.PRACTICE_CODE = 'RR10';

SELECT COUNT(*) FROM CONSERVATION C WHERE C.PRACTICE_CODE2 = 'RR1'; --594
SELECT COUNT(*) FROM CONSERVATION C WHERE C.PRACTICE_CODE2 = 'RR2'; --3177
SELECT COUNT(*) FROM CONSERVATION C WHERE C.PRACTICE_CODE2 = 'RR3'; --48
SELECT COUNT(*) FROM CONSERVATION C WHERE C.PRACTICE_CODE2 = 'RR4'; --0
SELECT COUNT(*) FROM CONSERVATION C WHERE C.PRACTICE_CODE2 = 'RR10'; --34

UPDATE CONSERVATION C SET C.PRACTICE_CODE2 = 'RR1a' WHERE C.PRACTICE_CODE2 = 'RR1';
UPDATE CONSERVATION C SET C.PRACTICE_CODE2 = 'RR2a' WHERE C.PRACTICE_CODE2 = 'RR2';
UPDATE CONSERVATION C SET C.PRACTICE_CODE2 = 'RR3a' WHERE C.PRACTICE_CODE2 = 'RR3';
UPDATE CONSERVATION C SET C.PRACTICE_CODE2 = 'RR4a' WHERE C.PRACTICE_CODE2 = 'RR4';
UPDATE CONSERVATION C SET C.PRACTICE_CODE2 = 'RR3b' WHERE C.PRACTICE_CODE2 = 'RR10';

SELECT COUNT(*) FROM PRACTICE_PAYMENT PP WHERE PP.PRACTICE_CODE = 'RR1'; --1046
SELECT COUNT(*) FROM PRACTICE_PAYMENT PP WHERE PP.PRACTICE_CODE = 'RR2'; --6456
SELECT COUNT(*) FROM PRACTICE_PAYMENT PP WHERE PP.PRACTICE_CODE = 'RR3'; --3187
SELECT COUNT(*) FROM PRACTICE_PAYMENT PP WHERE PP.PRACTICE_CODE = 'RR4'; --179
SELECT COUNT(*) FROM PRACTICE_PAYMENT PP WHERE PP.PRACTICE_CODE = 'RR10'; --2

UPDATE PRACTICE_PAYMENT PP SET PP.PRACTICE_CODE = 'RR1a' WHERE PP.PRACTICE_CODE = 'RR1';
UPDATE PRACTICE_PAYMENT PP SET PP.PRACTICE_CODE = 'RR2a' WHERE PP.PRACTICE_CODE = 'RR2';
UPDATE PRACTICE_PAYMENT PP SET PP.PRACTICE_CODE = 'RR3a' WHERE PP.PRACTICE_CODE = 'RR3';
UPDATE PRACTICE_PAYMENT PP SET PP.PRACTICE_CODE = 'RR4a' WHERE PP.PRACTICE_CODE = 'RR4';
UPDATE PRACTICE_PAYMENT PP SET PP.PRACTICE_CODE = 'RR3b' WHERE PP.PRACTICE_CODE = 'RR10';

--Delete RR1, RR2, RR3, and RR4 from D_PRACTICE table