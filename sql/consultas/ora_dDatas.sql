SELECT
    D.data,
    D.diautil dia_util
FROM 
    pcdatas D 
WHERE 
    D.data  BETWEEN ADD_MONTHS(TRUNC(SYSDATE,'YY'),-24) AND LAST_DAY( TRUNC(SYSDATE))
ORDER BY DATA



