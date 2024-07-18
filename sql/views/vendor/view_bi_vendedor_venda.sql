


CREATE OR REPLACE VIEW view_bi_vendedor_venda AS 

SELECT 
    PCDATAS.DATA,
    NVL(VENDAS.ETIQUETA,'XXX') ETIQUETA ,
    NVL(VENDAS.COD_FILIAL,0) COD_FILIAL ,
    NVL(VENDAS.COD_FILIAL_RETIRA,0) COD_FILIAL_RETIRA,
    NVL(VENDAS.ORIGEM_ESTOQUE,'XXX') ORIGEM_ESTOQUE,
    NVL(VENDAS.COD_FORNECEDOR,0) COD_FORNECEDOR ,
    NVL(VENDAS.RCA,0) COD_RCA,
    NVL(VENDAS.NUM_NOTA,0) NUM_NOTA ,
    NVL(VENDAS.NUM_TRANS_VENDA,0) NUM_TRANS_VENDA ,
    NVL(VENDAS.COD_CLIENTE,0) COD_CLIENTE ,
    NVL(VENDAS.COD_PROFISSIONAL,0) COD_PROFISSIONAL ,
    NVL(VENDAS.VLR_COMISSAO_PROFISSIONAL,0) VLR_COMISSAO_PROFISSIONAL ,
    NVL(PER_COMISSAO_PROFISSIONAL,0) PER_COMISSAO_PROFISSIONAL ,
    NVL(VENDAS.COD_SUPERVISOR,0) COD_SUPERVISOR ,
    NVL(VENDAS.TIPO_RETIRA_RED,'XXX') TIPO_RETIRA_RED,
    NVL(VENDAS.TIPO_RETIRA,'XXX') TIPO_RETIRA,
    NVL(VENDAS.COD_PROD,0) COD_PROD ,
    NVL(VENDAS.COD_DEPARTAMENTO,0) COD_DEPARTAMENTO ,
    NVL(VENDAS.COD_SECAO,0) COD_SECAO ,
    NVL(VENDAS.QTD,0) QTD ,
    NVL(VENDAS.VLR_VENDA,0) VLR_VENDA ,
    NVL(VENDAS.VLR_VENDA_DESP,0) VLR_VENDA_DESP,
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
    NVL(VENDAS.VLR_BONNUS_PLPAG,0) VLR_BONUS_PLPAG
    

FROM PCDATAS 
     
    LEFT JOIN   (

                    SELECT

                        'VENDA' ETIQUETA,
                        S.DTSAIDA DATA,
                        NVL(S.CODFILIAL,0) COD_FILIAL,
                        NVL(M.CODFILIALRETIRA,M.CODFILIAL) COD_FILIAL_RETIRA,
                        DECODE(NVL(M.CODFILIALRETIRA,M.CODFILIAL),M.CODFILIAL,'ESTOQUE LOJA','ESTOQUE CD') ORIGEM_ESTOQUE,
                        M.CODFORNECPROD COD_FORNECEDOR,
                        DECODE(NVL(S.CODUSUR,0),0,104,104,104,S.CODUSUR) RCA,
                        S.NUMNOTA NUM_NOTA,
                        S.NUMTRANSVENDA NUM_TRANS_VENDA ,
                        NVL(S.CODSUPERVISOR,7) COD_SUPERVISOR,
                        S.CODCLI COD_CLIENTE ,
                        NVL(S.CODUSUR2,0) COD_PROFISSIONAL ,
                        (NVL(M.QT,0)*NVL(M.PUNIT,0))*(NVL(M.PERCOM2,0)/100) VLR_COMISSAO_PROFISSIONAL ,
                         CASE WHEN NVL(M.PERCOM2,0) > 0 
                                THEN ROUND((NVL(M.QT,0)*NVL(M.PUNIT,0)*NVL(M.PERCOM2,0))/
                                            (NVL(M.QT,0)*NVL(M.PUNIT,0)),8)/100 
                                ELSE 0 END PER_COMISSAO_PROFISSIONAL ,  
                        M.CODPROD COD_PROD,
                        NVL(Z.TIPOENTREGA,'VD') TIPO_RETIRA_RED,
                        DECODE(Z.TIPOENTREGA,
                                            'RP','RETIRA POSTERIOR',
                                            'RI','RETIRA IMEDIATA',
                                            'EN','ENTREGA',
                                            'EF','ENCOMENDA',
                                            '','VENDA DIRETA',
                                            'XXX')TIPO_RETIRA,
                        M.QT QTD,
                        D.CODEPTO COD_DEPARTAMENTO,
                        W.CODSEC COD_SECAO,
                        (NVL(M.QT,0)*NVL(M.PUNIT,0)) VLR_VENDA,
                        (NVL(M.QT,0)*(NVL(M.PUNIT,0)+NVL(M.VLOUTROS,0))) VLR_VENDA_DESP,
                        (NVL(M.QT,0)*NVL(M.PTABELA,0)) VLR_TABELA,
                        (NVL(M.QT,0)*NVL(M.PTABELA,0))- (NVL(M.QT,0)*NVL(M.PUNIT,0))VLR_DESCONTO,
                        ROUND(NVL(M.PERCDESC,0) /100,8) PER_DESCONTO,
                        NVL(M.VLOUTROS,0) VLR_OUTRAS,
                        NVL(M.VLFRETE,0) VLR_FRETE,
                        ROUND(NVL(M.QT,0)*NVL(M.PUNIT,0)*NVL(M.PERCOM/100,0),2)VLR_COMISSAO_RCA,
                        CASE WHEN ( NVL(M.PERCOM,0) > 0 AND NVL(M.QT,0)> 0)
                                THEN ROUND((NVL(M.QT,0)*NVL(M.PUNIT,0)*NVL(M.PERCOM,0))/
                                            (NVL(M.QT,0)*(CASE WHEN NVL(M.PUNIT,0) > 0 THEN NVL(M.PUNIT,0) ELSE  NVL(M.PTABELA,0)-NVL(M.VLDESCONTO,0) END)),8)/100 
                                ELSE 0 END PER_COMISSAO_RCA ,
                        ROUND(NVL(M.QT,0)* (CASE 
                                                WHEN NVL(M.CUSTOFIN,0) > 0 
                                                    THEN NVL(M.CUSTOFIN,0) 
                                           ELSE (NVL(M.CUSTOCONT,0)+NVL(M.VLIPI,0)+NVL(M.VLCOFINS,0)+NVL(M.VLPIS,0)+NVL(Z.VLICMS,0)) 
                                            END  ),2) VLR_CMV,
                     ROUND( CASE 
                                WHEN NVL(M.QT,0)>0 
                                    THEN    NVL(M.QT,0)*(CASE 
                                                            WHEN NVL(M.CUSTOFIN,0) > 0 
                                                                THEN NVL(M.CUSTOFIN,0)
                                                            WHEN (NVL(M.CUSTOCONT,0)+NVL(M.VLIPI,0)+NVL(M.VLCOFINS,0)+NVL(M.VLPIS,0)+NVL(Z.VLICMS,0)) > 0
                                                                THEN  (NVL(M.CUSTOCONT,0)+NVL(M.VLIPI,0)+NVL(M.VLCOFINS,0)+NVL(M.VLPIS,0)+NVL(Z.VLICMS,0)) 
                                                        ELSE 1 END ) *100 / CASE 
                                                                                WHEN (NVL(M.QT,0)*NVL(M.PUNIT,0)) > 0 
                                                                                    THEN (NVL(M.QT,0)*NVL(M.PUNIT,0)) ELSE 1 END 
                            ELSE 0 END ,8)/100 PERC_CMV,                               
                        ROUND((NVL(M.QT,0)*NVL(M.PUNIT,0))- NVL(M.QT,0)*(   CASE 
                                                                                WHEN NVL(M.CUSTOFIN,0) > 0 
                                                                                    THEN NVL(M.CUSTOFIN,0)
                                                                                ELSE (NVL(M.CUSTOCONT,0)+NVL(M.VLIPI,0)+NVL(M.VLCOFINS,0)+NVL(M.VLPIS,0)+NVL(Z.VLICMS,0)) 
                                                                                END ) ,2) VLR_LUCRO,
                                                                                
                                                                
                        ROUND( CASE 
                                WHEN NVL(M.QT,0)> 0 
                                    THEN ((NVL(M.QT,0)*NVL(M.PUNIT,0))- NVL(M.QT,0)* ( CASE 
                                                                                        WHEN NVL(M.CUSTOFIN,0) > 0 
                                                                                            THEN NVL(M.CUSTOFIN,0)
                                                                                        WHEN (NVL(M.CUSTOCONT,0)+NVL(M.VLIPI,0)+NVL(M.VLCOFINS,0)+NVL(M.VLPIS,0)+NVL(Z.VLICMS,0)) > 0
                                                                                            THEN (NVL(M.CUSTOCONT,0)+NVL(M.VLIPI,0)+NVL(M.VLCOFINS,0)+NVL(M.VLPIS,0)+NVL(Z.VLICMS,0)) 
                                                                                        ELSE 0 END ))/CASE 
                                                                                                        WHEN (NVL(M.QT,0)*NVL(M.PUNIT,0))>0 
                                                                                                            THEN (NVL(M.QT,0)*NVL(M.PUNIT,0)) ELSE 1 END
                                ELSE 0 END,8) PER_LUCRO,
                                                                                
                        ROUND( CASE
                                WHEN NVL(M.QT,0) > 0 
                                    THEN ((NVL(M.QT,0)*NVL(M.PTABELA,0))- (NVL(M.QT,0)*NVL(M.PUNIT,0))) /(NVL(M.QT,0)*NVL(M.PTABELA,0))ELSE 0 END,8) PER_FLEX,
                        E.CODMARCA COD_MARCA ,
                        REPLACE(E.MARCA,'CLASSE','') MARCA,
                        CASE    WHEN U.CODMONITOR > 1                                     
                                    THEN  DECODE(E.CODMARCA ,1,0
                                                            ,2,0
                                                            ,3,0.20
                                                            ,4,0.40
                                                            ,5,1.20
                                                            ,6,1.05)
                                WHEN U.CODMONITOR > 2
                                    THEN  DECODE(E.CODMARCA ,1,0
                                                            ,2,0.25
                                                            ,3,0.55
                                                            ,4,0.40
                                                            ,5,1.20
                                                            ,6,1.05)
                                WHEN U.CODMONITOR > 3
                                    THEN  DECODE(E.CODMARCA ,1,0
                                                            ,2,0.25
                                                            ,3,0.55
                                                            ,4,0.75
                                                            ,5,1.55
                                                            ,6,1.05)
                        ELSE 0 END BONUS,                 
                        
                        CASE    WHEN U.CODMONITOR > 1

                                    THEN (NVL(M.QT,0)*NVL(M.PUNIT,0))* DECODE(E.CODMARCA    ,1,0
                                                                                            ,2,0
                                                                                            ,3,0.0020
                                                                                            ,4,0.0040
                                                                                            ,5,0.0120
                                                                                            ,6,0.0105) 
                                WHEN U.CODMONITOR > 2
                                    THEN (NVL(M.QT,0)*NVL(M.PUNIT,0))* DECODE(E.CODMARCA    ,1,0
                                                                                            ,2,0.0025
                                                                                            ,3,0.0020
                                                                                            ,4,0.0040
                                                                                            ,5,0.0120
                                                                                            ,6,0.0105) 
                                WHEN  U.CODMONITOR > 3
                                    THEN (NVL(M.QT,0)*NVL(M.PUNIT,0))* DECODE(E.CODMARCA    ,1,0
                                                                                            ,2,0.0025
                                                                                            ,3,0.0020
                                                                                            ,4,0.0040
                                                                                            ,5,0.0155
                                                                                            ,6,0.0105)  
                                                          
                            ELSE 0 END VLR_BONUS,  
                        (NVL(NVL(M.QT,0)*NVL(M.PUNIT,0)* DECODE(C.PERTXFIM,
                                            -5, CASE WHEN M.CODPLPAG >= 60 THEN 0.005 ELSE 0 END,
                                            -10,DECODE(C.TIPOVENDA,
                                                               'VV',DECODE(C.NUMDIAS,0,CASE WHEN M.CODPLPAG >= 60 THEN 0.005 ELSE 0 END),
                                                               'VP',DECODE(C.NUMDIAS,15,CASE WHEN M.CODPLPAG >= 60 AND C.VENDABK = 'S'  THEN 0.005  ELSE 0 END)
                                                                )) ,0))VLR_BONNUS_PLPAG
  
                        
                        
              

                    FROM 
                        PCMOV M, PCNFSAID S,PCMOVCOMPLE Z,PCPRODUT P,PCMARCA E, PCDEPTO D, PCSECAO W, PCUSUARI U, PCPLPAG C
                        
                    WHERE M.NUMTRANSVENDA = S.NUMTRANSVENDA
                        /*ADICIONADO*/
                        AND M.NUMPED = S.NUMPED
                        AND M.NUMNOTA = S.NUMNOTA
                        
                        AND M.NUMTRANSITEM = Z.NUMTRANSITEM
                        AND M.CODPROD = P.CODPROD
                        AND P.CODMARCA = E.CODMARCA
                        AND P.CODEPTO = D.CODEPTO
                        AND P.CODSEC = W.CODSEC
                        /*ADICIONAL*/
                        AND P.CODEPTO = W.CODEPTO
                        
                        AND S.CODUSUR = U.CODUSUR
                        AND M.CODPLPAG = C.CODPLPAG
                        AND S.CONDVENDA IN (1,7,5,9,11,14)
                        AND S.CODFILIALNF NOT IN(6,7)
                        AND S.DTCANCEL IS NULL
                        AND S.TIPOVENDA NOT IN( 'TR','SR')
                        /*ADICIONADO*/
                        AND M.DTCANCEL IS NULL
                        AND M.CODOPER = 'S'
                        AND M.DTMOV = S.DTSAIDA


                                                

                                         
)VENDAS 
    ON 
        PCDATAS.DATA = VENDAS.DATA
        

WHERE 
    PCDATAS.DATA  BETWEEN ADD_MONTHS(TRUNC(SYSDATE,'YY'),-24) AND TRUNC(SYSDATE)
      
ORDER BY 
    DATA, 
    COD_FILIAL, 
    COD_RCA
    
 WITH READ ONLY