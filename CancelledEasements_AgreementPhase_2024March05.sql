-- March 2024
--extract table of cancelled easements that have reached the agreement phase but did not reach final payment
--extract table of completed easements from that period
-- compare to total # of easements from that period to calculate a cancellation rate "buffer" for appropriation calculators

SELECT * FROM ELINK_RIM2.EASEMENT E 
INNER JOIN ELINK_RIM2.V_EASE_PARSE VEP
ON E.EASEMENT_ID = VEP.EASEMENT_ID 
WHERE 
  E.DELETED_FLAG = 'Y' -- cancelled easements
  AND VEP.E_YEAR_FULL > 2017 --only past 6 years of records
  AND E.EASEMENT_TYPE_CODE NOT IN ('5','8','Y') -- don't include wetland banking, flowage, road replacement easements
  AND E.EASEMENT_ID NOT IN ('8959') --manual exclusion; easement moved foward under diff ID
  AND E.DELETE_REASON_CODE <> 'USER_ERROR' --don't include user error deletions
  AND E.EASEMENT_ID IN 
    (SELECT EC.EASEMENT_ID FROM ELINK_RIM2.EASEMENT_CHECKLIST EC
      WHERE EC.EASEMENT_CHECKLIST_DATE_CODE IN ('DATE10','DATE9B')) -- checklist code 
ORDER BY E.EASEMENT_PAYMENT
;


-- for completed easements; 

SELECT * FROM ELINK_RIM2.EASEMENT E 
INNER JOIN ELINK_RIM2.V_EASE_PARSE VEP
ON E.EASEMENT_ID = VEP.EASEMENT_ID 
WHERE 
  E.DELETED_FLAG = 'N' -- cancelled easements
  AND VEP.E_YEAR_FULL > 2017 --only past 6 years of records
  AND E.EASEMENT_TYPE_CODE NOT IN ('5','8','Y') -- don't include wetland banking, flowage, road replacement easements;
  AND E.EASEMENT_ID NOT IN ('8959') --manual exclusion; easement moved foward under diff ID
  AND E.DELETE_REASON_CODE <> 'USER_ERROR' --don't include user error deletions

ORDER BY E.EASEMENT_PAYMENT
;