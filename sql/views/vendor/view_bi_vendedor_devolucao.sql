CREATE OR REPLACE VIEW view_bi_vendedor_devolucao AS 

SELECT 
    PCDATAS.DATA,
    NVL(VENDAS.ETIQUETA,'XXX') ETIQUETA ,
    NVL(VENDAS.COD_FILIAL,0) COD_FILIAL ,  
    NVL(VENDAS.COD_FORNECEDOR,0) COD_FORNECEDOR,
    NVL(VENDAS.RCA,0) COD_RCA,
    NVL(VENDAS.NUM_NOTA,0) NUM_NOTA ,
    NVL(VENDAS.COD_CLIENTE,0) COD_CLIENTE ,
    NVL(VENDAS.COD_PROFISSIONAL,0) COD_PROFISSIONAL ,
    NVL(VENDAS.VLR_COMISSAO_PROFISSIONAL,0) VLR_COMISSAO_PROFISSIONAL ,
    NVL(PER_COMISSAO_PROFISSIONAL,0) PER_COMISSAO_PROFISSIONAL ,
    NVL(VENDAS.COD_SUPERVISOR,0) COD_SUPERVISOR ,
    NVL(VENDAS.COD_PROD,0) COD_PROD ,
    NVL(VENDAS.COD_DEPARTAMENTO,0) COD_DEPARTAMENTO ,
    NVL(VENDAS.COD_SECAO,0) COD_SECAO ,
    NVL(VENDAS.QTD,0) QTD ,
    NVL(VENDAS.VLR_VENDA,0) VLR_VENDA ,
    NVL(VENDAS.VLR_VENDA_OUTRAS,0) VLR_VENDA_OUTRAS,
    NVL(VENDAS.VLR_TABELA,0) VLR_TABELA ,
    NVL(VENDAS.VLR_DESCONTO,0)VLR_DESCONTO ,
    NVL(VENDAS.PER_DESCONTO,0) PER_DESCONTO,
    NVL(VENDAS.VLR_OUTRAS,0) VLR_OUTRAS ,
    NVL(VENDAS.VLR_FRETE,0) VLR_FRETE ,
    NVL(VENDAS.VLR_COMISSAO_RCA,0)VLR_COMISSAO_RCA ,
    NVL(VENDAS.PER_COMISSAO_RCA,0) PER_COMISSAO_RCA ,
    NVL(VENDAS.VLR_CMV,0) VLR_CMV ,
    NVL(VENDAS.PERC_CMV,0) PERC_CMV ,
    NVL(VENDAS.VLR_LUCRO,0) VLR_LUCRO ,
    NVL(VENDAS.PER_LUCRO,0) PER_LUCRO ,
    NVL(VENDAS.PER_FLEX,0) PER_FLEX ,
    NVL(VENDAS.COD_MARCA,0) COD_MARCA,
    NVL(VENDAS.MARCA,'XXX') MARCA,
    NVL(VENDAS.BONUS,0) PERC_BONUS,
    NVL(VENDAS.VLR_BONNUS_PLPAG,0) VLR_BONUS_PLPAG,
    NVL(VENDAS.VLR_DEVOLUCAO,0) VLR_DEVOLUCAO,
    NVL(VENDAS.VLR_DEV_SEM_TV8,0) VLR_DEV_SEM_TV8,
    NVL(VENDAS.VLR_DEV_ESTORNO_RCA,0) VLR_DEV_ESTORNO_RCA
    

FROM PCDATAS 
     
    LEFT JOIN   (
                SELECT
                    'DEVOLUCAO' ETIQUETA,
                    PCESTCOM.DTESTORNO DATA,
                    PCNFENT.CODFILIAL COD_FILIAL,
                    PCMOV.CODFORNECPROD COD_FORNECEDOR, 
                    PCESTCOM.CODUSUR RCA,
                    PCNFENT.NUMNOTA NUM_NOTA,
                    PCMOV.CODCLI COD_CLIENTE,
                    NVL((SELECT (NVL(W.CODUSUR2,0)) FROM PCNFSAID W WHERE W.CONDVENDA IN(1,7,5,9,11,14) AND W.CODFILIALNF NOT IN(6,7) AND W.DTCANCEL IS NULL
                        AND W.NUMTRANSVENDA = PCESTCOM.NUMTRANSVENDA AND W.CODUSUR = PCESTCOM.CODUSUR),0)COD_PROFISSIONAL,
                    ROUND(NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0)*NVL(PCMOV.PERCOM2/100,0),2)*(-1) VLR_COMISSAO_PROFISSIONAL,
                    CASE WHEN NVL(PCMOV.PERCOM2,0) > 0 
                            THEN ROUND((NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0)*NVL(PCMOV.PERCOM2,0))/
                                        (NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0)),8)/100 
                            ELSE 0 END PER_COMISSAO_PROFISSIONAL ,
                    NVL((SELECT (NVL(W.CODSUPERVISOR,0)) FROM PCNFSAID W WHERE W.CONDVENDA IN(1,7,5,9,11,14) AND W.CODFILIALNF NOT IN(6,7) AND W.DTCANCEL IS NULL
                        AND W.NUMTRANSVENDA = PCESTCOM.NUMTRANSVENDA AND W.CODUSUR = PCESTCOM.CODUSUR),7)COD_SUPERVISOR,
                    PCMOV.CODPROD COD_PROD,
                    PCDEPTO.CODEPTO COD_DEPARTAMENTO,
                    PCSECAO.CODSEC COD_SECAO,
                    NVL(PCMOV.QT,0) QTD,
                    /**/
                    0 VLR_VENDA,
                    0 VLR_VENDA_OUTRAS,
                    0 VLR_TABELA,
                    0 VLR_DESCONTO,
                    0 PER_DESCONTO,
                    0 VLR_OUTRAS,
                    0 VLR_FRETE,
                    /**/
                    ROUND(NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0)*NVL(PCMOV.PERCOM/100,0),2)*(-1)VLR_COMISSAO_RCA,
                    CASE WHEN ( NVL(PCMOV.PERCOM,0) > 0  AND NVL(PCMOV.QT,0) > 0)
                            THEN ROUND((NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0)*NVL(PCMOV.PERCOM,0))/
                                        (NVL(PCMOV.QT,0)*(CASE WHEN NVL(PCMOV.PUNIT,0) > 0 THEN NVL(PCMOV.PUNIT,0) ELSE NVL(PCMOV.PTABELA,0)-NVL(PCMOV.VLDESCONTO,0) END
                                        
                                        )),8)/100 
                            ELSE 0 END PER_COMISSAO_RCA ,
                    ROUND(NVL(PCMOV.QT,0)* (CASE 
                                            WHEN NVL(PCMOV.CUSTOFIN,0) > 0 
                                                THEN NVL(PCMOV.CUSTOFIN,0) 
                                       ELSE (NVL(PCMOV.CUSTOCONT,0)+NVL(PCMOV.VLIPI,0)+NVL(PCMOV.VLCOFINS,0)+NVL(PCMOV.VLPIS,0)+NVL(PCMOVCOMPLE.VLICMS,0)) 
                                        END  ),2)*(-1) VLR_CMV,
                    ROUND( CASE 
                                WHEN  NVL(PCMOV.QT,0)>0 
                                    THEN(  NVL(PCMOV.QT,0)*(CASE 
                                                                WHEN NVL(PCMOV.CUSTOFIN,0) > 0 
                                                                    THEN NVL(PCMOV.CUSTOFIN,0)
                                                                WHEN (NVL(PCMOV.CUSTOCONT,0)+NVL(PCMOV.VLIPI,0)+NVL(PCMOV.VLCOFINS,0)+NVL(PCMOV.VLPIS,0)+NVL(PCMOVCOMPLE.VLICMS,0))  > 0
                                                                    THEN (NVL(PCMOV.CUSTOCONT,0)+NVL(PCMOV.VLIPI,0)+NVL(PCMOV.VLCOFINS,0)+NVL(PCMOV.VLPIS,0)+NVL(PCMOVCOMPLE.VLICMS,0)) 
                                                                ELSE 0 END ) *100 /(NVL(PCMOV.QT,0)*DECODE(NVL(PCMOV.PUNIT,0),0,PCMOV.PTABELA-PCMOV.VLDESCONTO,NVL(PCMOV.PUNIT,0)  )) ) ELSE 0 END                        
                        ,8)/100 PERC_CMV,
                    ROUND((NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0))- NVL(PCMOV.QT,0)*(   CASE 
                                                                            WHEN NVL(PCMOV.CUSTOFIN,0) > 0 
                                                                                THEN NVL(PCMOV.CUSTOFIN,0)
                                                                            ELSE (NVL(PCMOV.CUSTOCONT,0)+NVL(PCMOV.VLIPI,0)+NVL(PCMOV.VLCOFINS,0)+NVL(PCMOV.VLPIS,0)+NVL(PCMOVCOMPLE.VLICMS,0)) 
                                                                            END ) ,2)*(-1) VLR_LUCRO,
                                                                            
                                                                         
                    
                    ROUND(CASE 
                            WHEN NVL(PCMOV.QT,0) >0 
                                THEN ((NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0))- NVL(PCMOV.QT,0)* ( CASE 
                                                                                                    WHEN NVL(PCMOV.CUSTOFIN,0) > 0 
                                                                                                        THEN NVL(PCMOV.CUSTOFIN,0)
                                                                                                ELSE (NVL(PCMOV.CUSTOCONT,0)+NVL(PCMOV.VLIPI,0)+NVL(PCMOV.VLCOFINS,0)+NVL(PCMOV.VLPIS,0)+NVL(PCMOVCOMPLE.VLICMS,0)) 
                                                                                                    END ))/(NVL(PCMOV.QT,0)*DECODE(NVL(PCMOV.PUNIT,0),0,PCMOV.PTABELA-PCMOV.VLDESCONTO,NVL(PCMOV.PUNIT,0)  )) 
                                                                            
                        ELSE 0 END,8) PER_LUCRO,
                                                                            
                    ROUND( CASE 
                            WHEN NVL(PCMOV.QT,0) > 0 
                                THEN ((NVL(PCMOV.QT,0)*NVL(PCMOV.PTABELA,0))- (NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0))) /(NVL(PCMOV.QT,0)*NVL(PCMOV.PTABELA,0))
                            ELSE 0 END ,8)*(-1) PER_FLEX,
                    PCMARCA.CODMARCA COD_MARCA ,
                    REPLACE(PCMARCA.MARCA,'CLASSE','') MARCA,
                    CASE WHEN PCUSUARI.CODMONITOR > 1
                          
                            THEN  DECODE(PCMARCA.CODMARCA  ,1,0
                                                    ,2,0
                                                    ,3,0.20
                                                    ,4,0.40
                                                    ,5,1.20
                                                    ,6,1.05)
                        WHEN PCUSUARI.CODMONITOR > 2
                            THEN  DECODE(PCMARCA.CODMARCA ,1,0
                                                    ,2,0.25
                                                    ,3,0.55
                                                    ,4,0.40
                                                    ,5,1.20
                                                    ,6,1.05)
                        WHEN PCUSUARI.CODMONITOR > 3
                            THEN  DECODE(PCMARCA.CODMARCA ,1,0
                                                    ,2,0.25
                                                    ,3,0.55
                                                    ,4,0.75
                                                    ,5,1.55
                                                    ,6,1.05)
                        ELSE 0 END BONUS,                 
                        
                    CASE WHEN  PCUSUARI.CODMONITOR > 1
                     
                            THEN (NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0))* DECODE(PCMARCA.CODMARCA   ,1,0
                                                                                                    ,2,0
                                                                                                    ,3,0.0020
                                                                                                    ,4,0.0040
                                                                                                    ,5,0.0120
                                                                                                    ,6,0.0105) 
                         WHEN PCUSUARI.CODMONITOR > 2
                            THEN (NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0))* DECODE(PCMARCA.CODMARCA   ,1,0
                                                                                                    ,2,0.0025
                                                                                                    ,3,0.0020
                                                                                                    ,4,0.0040
                                                                                                    ,5,0.0120
                                                                                                    ,6,0.0105) 
                         WHEN PCUSUARI.CODMONITOR > 3
                            THEN (NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0))* DECODE(PCMARCA.CODMARCA   ,1,0
                                                                                                    ,2,0.0025
                                                                                                    ,3,0.0020
                                                                                                    ,4,0.0040
                                                                                                    ,5,0.0155
                                                                                                    ,6,0.0105)  
                                                      
                        ELSE 0 END *(-1) VLR_BONUS,  
                    (NVL(NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0)*(SELECT  DISTINCT  DECODE(PAG.PERTXFIM,
                                                -5,CASE WHEN SAI.CODPLPAG >= 60 THEN 0.005 ELSE 0 END,
                                                    -10,DECODE(PAG.TIPOVENDA,
                                                                    'VV',DECODE(PAG.NUMDIAS,0,CASE WHEN SAI.CODPLPAG >= 60 THEN 0.005 ELSE 0 END),
                                                                    
                                                                    'VP',DECODE(PAG.NUMDIAS,15,CASE WHEN SAI.CODPLPAG >= 60 AND PAG.VENDABK = 'S'  THEN 0.005 ELSE 0 END)
                                                                     ))     
                                                FROM  PCESTCOM COM,PCMOV SAI, PCPLPAG PAG
                                                WHERE  
                                                    PCMOV.NUMTRANSENT = COM.NUMTRANSENT 
                                                    AND COM.NUMTRANSVENDA = SAI.NUMTRANSVENDA 
                                                    AND PCMOV.CODPROD = SAI.CODPROD 
                                                    AND SAI.CODPLPAG = PAG.CODPLPAG  )  
                                                                ,0))*(-1) VLR_BONNUS_PLPAG,
                    NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0)*(-1) VLR_DEVOLUCAO,
                    NVL(PCMOV.QT,0)*(NVL(PCMOV.PUNIT,0)+NVL(PCMOV.VLOUTROS,0)+NVL(PCMOV.VLFRETE,0))*(-1) VLR_DEVOLUCAO_DESP,
                    ((DECODE((SELECT S.CONDVENDA FROM PCNFSAID S WHERE S.NUMTRANSVENDA = PCESTCOM.NUMTRANSVENDA ),8,0,(NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0)))))*(-1) VLR_DEV_SEM_TV8 ,
                    (NVL(PCMOV.QT,0)*NVL(PCMOV.PUNIT,0))* (SELECT  M.PERCOM/100 FROM PCMOV M WHERE  M.NUMTRANSVENDA = PCESTCOM.NUMTRANSVENDA AND M.CODPROD = PCMOV.CODPROD 
                                 AND PCMOV.NUMSEQ =  M.NUMSEQ AND M.CODOPER = 'S' AND M.DTCANCEL IS NULL GROUP BY M.PERCOM  HAVING  M.PERCOM > 1
                                 
                                 
                                 )*(-1) VLR_DEV_ESTORNO_RCA,
                    NVL(PCMOV.VLOUTROS,0)VLR_DEV_OUTRAS_RCA,
                    NVL(PCMOV.VLFRETE,0)VLR_DEV_FRETE_RCA
                        
              
                FROM 
                    PCESTCOM,PCNFENT, PCMOV, PCPRODUT, PCDEPTO, PCSECAO, PCMOVCOMPLE, PCMARCA, PCUSUARI  
                WHERE
                    PCESTCOM.NUMTRANSENT = PCNFENT.NUMTRANSENT
                    AND PCNFENT.NUMTRANSENT = PCMOV.NUMTRANSENT
                    AND PCMOV.NUMTRANSENT = PCESTCOM.NUMTRANSENT
                    AND PCMOV.NUMTRANSITEM = PCMOVCOMPLE.NUMTRANSITEM
                    AND PCPRODUT.CODMARCA = PCMARCA.CODMARCA
                    AND PCMOV.CODUSUR = PCUSUARI.CODUSUR
                    AND PCMOV.CODPROD = PCPRODUT.CODPROD
                    AND PCPRODUT.CODEPTO = PCDEPTO.CODEPTO
                    AND PCPRODUT.CODSEC = PCSECAO.CODSEC
                    AND PCNFENT.DTCANCEL IS NULL
                    AND PCMOV.DTCANCEL IS NULL
                    AND PCMOV.CODOPER = 'ED'
                   
                    GROUP BY
                        PCESTCOM.DTESTORNO ,
                        PCNFENT.CODFILIAL ,
                        PCMOV.CODFORNECPROD ,
                        PCESTCOM.CODUSUR ,
                        PCNFENT.NUMNOTA ,
                        PCESTCOM.NUMTRANSVENDA ,
                        PCMOV.PUNIT ,
                        PCMOV.PERCOM ,
                        PCMOV.VLDESCONTO ,
                        PCMOV.CUSTOFIN ,
                        PCMOV.CUSTOCONT ,
                        PCMOV.VLIPI ,
                        PCMOV.VLCOFINS ,
                        PCMOV.VLPIS ,
                        PCMOVCOMPLE.VLICMS ,
                        PCMOV.PERCOM2,
                        PCMOV.PTABELA ,
                        PCMOV.CODCLI ,
                        PCMOV.CODPROD ,
                        NVL(PCMOV.QT,0) ,
                        PCDEPTO.CODEPTO ,
                        PCSECAO.CODSEC,
                        PCMARCA.CODMARCA,
                        PCMARCA.MARCA,
                        PCUSUARI.CODMONITOR,
                        PCMOV.NUMSEQ ,
                        PCMOV.NUMTRANSENT,
                        NVL(PCMOV.VLOUTROS,0),
                        NVL(PCMOV.VLFRETE,0)
                                         
)VENDAS 
    ON 
        PCDATAS.DATA = VENDAS.DATA
    

WHERE 

   PCDATAS.DATA BETWEEN  ADD_MONTHS(TRUNC(SYSDATE,'YY'),-12) AND TRUNC(SYSDATE)
  
  
ORDER BY 
    DATA,
    COD_FILIAL, 
    COD_RCA



 WITH READ ONLY

