/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � A710SQL         � Alexandre R. Bento    � Data �14.07.2010���
������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para executar o MRP apenas dos produtos  ��� 
���            que tenham PMP                                			 ���
������������������������������������������������������������������������Ĵ��
���Uso       � Estoque / Custos                                          ���
�������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

#include "rwmake.ch"    
#include "Topconn.ch"

User Function A710SQL()

Local cAliasAtu := paramixb[1]
Local cQueryB1  := paramixb[2]
Local cQuery,cQuery1   
local  cArqTrab  
Local _lAchou
SetPrvt("CALIASESTRU,CARQTRAB,CNOMEARQ,_CESTRUTURA,_cCompon,_cComp")
Private nEstru := 0

	If !UPPER(FUNNAME())$"MATA710" // so executa o ponto de entrada a primeira vez quando � chamado pela rotina principal mata710 (MRP)
       Return cQueryB1
	Endif

    //Deixa o campo B1_MRP como n�o usado na rotina do MRP
	cQuery := "UPDATE "+  RetSqlName( 'SB1' ) 
	cQuery += " SET B1_MRP = 'N'" 
	cQuery += " WHERE B1_FILIAL  = '" + xFilial("SB1")+ "'"
	cQuery += " AND B1_MRP IN (' ','S')"

	If TCSQLExec(cQuery) < 0 //Executa a query
	   cErro := TCSQLERROR()
	   ALERT(cErro)
	Endif  

    //Busca os produtos do PMP, conforme o numero digitado no MRP
    cQuery := " SELECT HC_PRODUTO" 
    cQuery += " FROM " +  RetSqlName( 'SHC' ) +" (NOLOCK) "     
    cQuery += " WHERE HC_FILIAL = '"+xFilial("SHC")+"'"
    cQuery += " AND D_E_L_E_T_ = '' "
    cQuery += " AND HC_DOC = '" + mv_par23 + "' "
    cQuery += " GROUP BY HC_PRODUTO

//TCQuery Abre uma workarea com o resultado da query
//   MemoWrit('C:\TEMP\A710ALQ.SQL',cQuery)        
	TCQUERY cQuery NEW ALIAS "TEMP"  

    cArqTrab    := CriaTrab(nil,.f.)
  
    TEMP->(DbGoTop())
    While TEMP->(!Eof())

       //Explode estrutura do produto, conform PMP do MRP
       cArqTrab:= Estrut2(TEMP->HC_PRODUTO,1000)
       DbSelectArea("ESTRUT")                                                                                                                          
       
       ESTRUT->(DbGoTop())
       _cComp  :="('"+TEMP->HC_PRODUTO + "'," //Adiciona o produto PA na estrutura
       _lAchou := .f.
       While ESTRUT->(!Eof())
           
          If !Subs(ESTRUT->COMP,1,3)$"MOD" .And. ESTRUT->QUANT > 0  //descarta os MODs e tamb�m os retornos com esrutura negativa
             _cComp += "'"+ESTRUT->COMP+"'," 
             _lAchou := .t.      
          Endif
          ESTRUT->(DbSkip())
       Enddo
       _cCompon := len(_cComp)
       _cComp := Substring(_cComp,1,_cCompon-1) + ")"
       
       //Deixa o campo B1_MRP como Sim somente a estrutura dos produtos do PMP usados na rotina do MRP
	   cQuery1 := "UPDATE "+  RetSqlName( 'SB1' ) 
	   cQuery1 += " SET B1_MRP = 'S'" 
	   cQuery1 += " WHERE B1_FILIAL  = '" + xFilial("SB1")+ "'"
	   cQuery1 += " AND D_E_L_E_T_ =' '" 
	   cQuery1 += " AND B1_COD IN " + _cComp
	   
	   If _lAchou // variavel de controle s� executa se tiver PMP
		   If TCSQLExec(cQuery1) < 0 //Executa a query
		      cErro := TCSQLERROR()
		      ALERT(cErro)
		   Endif     
       Endif
	   
       TEMP->(DbSkip())
    Enddo
    //DbSelectArea("ESTRUT")     
//    FimEstrut2(Nil,cArqTrab)
    TEMP->(DbClosearea())
    
Return cQueryB1