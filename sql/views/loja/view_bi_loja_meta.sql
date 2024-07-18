CREATE OR REPLACE VIEW view_bi_loja_meta AS 
SELECT 
        PCDATAS.DATA,
        FILIAL.CODIGO COD_FILIAL,
        NVL(META.VLVENDAPREV,0) VLR_META_DIA,
        (CASE WHEN PCDATAS.DATA = TRUNC(PCDATAS.DATA,'MM') THEN (SELECT SUM(NVL(M.VLVENDAPREV,0)) 
                                                                FROM PCMETASUP M 
                                                                WHERE M.codfilial = FILIAL.CODIGO 
                                                                        
                                                                        AND  EXTRACT(MONTH FROM M.DATA) = EXTRACT(MONTH FROM PCDATAS.DATA  )
                                                                        AND  EXTRACT(YEAR FROM M.DATA) = EXTRACT(YEAR FROM PCDATAS.DATA  )
                                                                        ) ELSE 0 END)VLR_META_MES

FROM PCDATAS 
        LEFT JOIN (SELECT PCFILIAL.DTREGISTRO DATA,PCFILIAL.CODIGO FROM PCFILIAL WHERE  PCFILIAL.CODIGO NOT IN (6,7,8,99))FILIAL  ON FILIAL.DATA < PCDATAS.DATA
        LEFT JOIN (SELECT  M.DATA, M.CODFILIAL,M.VLVENDAPREV FROM PCMETASUP M WHERE M.VLVENDAPREV > 0 )META ON META.DATA = PCDATAS.DATA AND META.CODFILIAL = FILIAL.CODIGO

WHERE 
    PCDATAS.DATA BETWEEN ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND TRUNC(SYSDATE)
ORDER BY 
    DATA, 
    COD_FILIAL
    
    
 WITH READ ONLY    

                             