--Compare and contrast actual easement acreage with what is listed on conservation plan table to get a sense of scale of conservation plan acreage issue in legacy data
-- database migration circa 2013 created issue with cons plan table where secondary conservation practices Exist 
-- this script generates a list of easements with mismatched acreage for future parsing and cleaning
-- can also give list with a threshold acreage difference (line 41)

SELECT
    E.EASEMENT_ID,
    E.EASEMENT_NUMBER,
    VEP.E_YEAR_FULL,
    ROUND(E.EASEMENT_ACRES,1) AS EASEMENT_ACRES, -- round up easement acres; alias as EASEMENT_ACRES
    SUM(C.NUMBER_ACRES) AS CONS_ACRES, --round up cons plan acres
    ABS(ROUND(E.EASEMENT_ACRES - SUM(C.NUMBER_ACRES),1)) AS ACRES_DIF,
    ABS(ROUND(((E.EASEMENT_ACRES - SUM(C.NUMBER_ACRES)) / E.EASEMENT_ACRES) * 100,1)) AS PERCENT_DIF
FROM
    ELINK_RIM2.EASEMENT E
INNER JOIN
    ELINK_RIM2.CONSERVATION_PLAN CP ON E.EASEMENT_ID = CP.EASEMENT_ID
INNER JOIN
    ELINK_RIM2.CONSERVATION C ON CP.CONSERVATION_PLAN_ID = C.CONSERVATION_PLAN_ID
INNER JOIN
    ELINK_RIM2.V_EASE_EXPIRED_STATUS_TBL_B VEES ON E.EASEMENT_ID = VEES.EASEMENT_ID
INNER JOIN
    ELINK_RIM2.V_EASEMENTS_REC_CHECK_B VERC ON E.EASEMENT_ID = VERC.EASEMENT_ID
INNER JOIN
    ELINK_RIM2.V_EASE_PARSE VEP ON E.EASEMENT_ID = VEP.EASEMENT_ID
WHERE   
    E.EASEMENT_TYPE_CODE NOT IN ('5', '8', 'Y')--exclude wetland classes
    AND E.DELETED_FLAG = 'N'--exclude easements that were deleted
    --and PRACTICE_CODE IN ('RR1','RR2','RR9','RRFB','RR10','RR11','RR2PP','RR3','RR4','RR7','RRTC') --optional limit to certain cons plan practices
    AND CP.DELETED_FLAG IS NULL
    AND CP.EXPIRY_DATE IS NULL
    AND VERC.RECORDED_FLAG = 'Y'--only want recorded easements
    AND VEES.EXPIRATION_STATUS <> 'EXPIRED' --only want active easements
GROUP BY
    E.EASEMENT_ID,
    E.EASEMENT_NUMBER,
    E.EASEMENT_ACRES,
    VEP.E_YEAR_FULL
HAVING
--ROUND(E.EASEMENT_ACRES,1) <> SUM(C.NUMBER_ACRES) -- optional filter for easements where easement acres and cons plan acres don't match
ABS(ROUND(E.EASEMENT_ACRES,1) - SUM(C.NUMBER_ACRES)) > 0.2 -
ORDER BY
    VEP.E_YEAR_FULL
;