#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch"
#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHMNT058 �Autor  �Douglas de S. Dourado� Data �  10/08/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � MANUTEN��O PREVENTIVA POR DISPOSITIVO                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP11 - MANUTENCAO DE ATIVOS                                ���
���	         � TABELA DE CADASTRO:  ZEWFN0		                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHMNT058
Private oDlg
Private aRotina, cCadastro // Obrigatorio iniciar estas variaveis do Mbrowse
/*********BROWSE*********/
cCadastro := "Preventiva por Dispositivo"
aRotina   := {}
aAdd(aRotina,{ "Visualizar"	    ,"U_MNT058(1)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_MNT058(2)" 	, 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"U_MNT058(3)"  , 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"U_MNT058(4)"  , 0 , 5})    
mBrowse(6,1,22,75,"ZEW",,,,,,fCriaCor())   
/*************************/         
Return   


User Function MNT058(nParam)
Private nPar := nParam, cTitle
Private cGetCod := space(15), cLetra:=space(01), cGetPrev:= space(06), dDataUlt := CtoD('  /  /  '), cDescDisp := ''
Private cPeriod := space(04), cDescPrev := space(80) , cGetSeque := space(02) , mDesc := space(300)
Private aSize := MsAdvSize(), lData := .F. 


/************* Identifica a opera��o que ser� realizada *****************/
  
If nPar==1      //visualizar
   fCarrega()
   cTitle  := 'Visualizar'  	 
ElseIf nPar==2  //incluir	
	cTitle := 'Cadastro'	
ElseIf nPar==3  //alterar              
	fCarrega()		
	cTitle := 'Alterar'
ElseIf nPar==4  //excluir
	fCarrega()			
   	cTitle := 'Excluir' 
EndIf 	

/************** Inicializa��o dos Say's e Get's ************************/ 

Define MsDialog oDlg Title (cTitle) From aSize[7],00 To aSize[6],aSize[5] Pixel

	@ 08,10  Say "C�digo Dispositivo: " PIXEL OF oDlg    	      
	@ 18,10  GET cGetCod SIZE 50,10 F3 "ZBN" WHEN (nPar == 2) VALID fDisp(.T.)

	@ 08,60  Say "Letra: " PIXEL OF oDlg    	      
	@ 18,60  MsGet oLetra VAR cLetra WHEN (nPar == 2) SIZE 08,10 PIXEL OF oDlg VALID fDisp(.T.) 	
	
	@ 08,125 Say "Descri��o Dispositivo: " PIXEL OF oDlg
	@ 18,125 MSGET oDesDisp Var cDescDisp WHEN .F. SIZE 200,10 PIXEL OF oDlg
	
	@ 08,82  Say "Sequencial: " PIXEL OF oDlg    	      
	@ 18,82  MSGET oGetSeq VAR cGetSeque WHEN .F. SIZE 10,10 PIXEL OF oDlg 
	
	@ 37,10  Say "C�d. Preventiva: " PIXEL OF oDlg	
	@ 46,10  GET cGetPrev SIZE 28,10 F3 "ZEE" WHEN (nPar == 2) VALID fPrev()
	
	@ 37,60  Say "Descri��o Preventiva: " PIXEL OF oDlg
	@ 46,60  MSGET oDescPrev VAR cDescPrev  SIZE 285,10 WHEN .F. PIXEL OF oDlg	
	
	@ 60,10  Say "Periodo: " PIXEL OF oDlg	
	@ 69,10  GET cPeriod SIZE 20,10 WHEN (nPar == 2 .or. nPar == 3) PICTURE '@9999' PIXEL OF oDlg
	@ 73,34  Say "DIAS" PIXEL OF oDlg
	
	@ 86,10  Say "Data Ultima Manuten��o: " PIXEL OF oDlg	
	@ 95,10  MSGET oDataUlt VAR dDataUlt SIZE 50,10 WHEN (lData = .F.) PIXEL OF oDlg
	
	@ 112,10 Say "Descri��o da Preventiva: (Opcional) " PIXEL OF oDlg	
	@ 121,10 GET mDesc MEMO SIZE 202,30 WHEN (nPar == 2 .or. nPar == 3) PIXEL OF oDlg    // Memo
			  	
	@ 160,10 BUTTON "Confirmar" Size 30,20 PIXEL OF oDlg action Confirmar()		  
	@ 160,45 BUTTON "Cancelar"  Size 30,20 PIXEL OF oDlg action Cancelar()	
	
Activate MsDialog oDlg Centered      

Return

/**********************************************************************/

/*************** Carrega os Dados para Visualiza��o *******************/
Static Function fCarrega()  
	
	cGetCod     := ZEW->ZEW_COD
	cLetra      := ZEW->ZEW_LETRA
	cGetPrev    := ZEW->ZEW_PRE
	cGetSeque 	:= ZEW->ZEW_SEQUE
	
	// Campo de Descri��o de Preventiva	
	ZEE->(DBSETORDER(1))      	   
    IF ZEE->(DBSEEK(xFilial("ZEE") + cGetPrev))
      cDescPrev := ZEE->ZEE_DESC
    ENDIF     
    ZEE->(DBCLOSEAREA())

	// Campo de Descri��o do Dispositivo 
	ZBN->(DBSETORDER(1))      	   	
	IF ZBN->( DBSEEK(xFilial("ZBN") + cGetCod + cLetra) )
  	  cDescDisp := ZBN->ZBN_DESC	
	ENDIF	
	ZBN->(DBCLOSEAREA())
		
	dDataUlt := ZEW->ZEW_DTUM  
	cPeriod  := ZEW->ZEW_PERIOD
	mDesc	 := ZEW->ZEW_DESC
			
Return	
/**********************************************************************/


/************* Grava, Altera, ou Exclui o Registro no BD **************/
Static Function Confirmar()
    
  DO CASE // Verfica a opera��o que ser� feita
  
	CASE nPar == 2    // Inclui um novo registro --------
		IF !Validar()
			Return
   		EndIf 		
		 		  		 		
	    RecLock("ZEW",.T.)
	    	ZEW->ZEW_FILIAL := xFilial("ZEW") 
	    	ZEW->ZEW_COD    := cGetCod
			ZEW->ZEW_LETRA  := cLetra
			ZEW->ZEW_PRE    := cGetPrev 
			ZEW->ZEW_DTUM   := dDataUlt
			ZEW->ZEW_PERIOD := val(cPeriod)
			ZEW->ZEW_SEQUE  := cGetSeque
			ZEW->ZEW_DESC   := mDesc // memo
		MsUnlock("ZEW") 
		ConfirmSX8()
    	MsgBox('Dados Cadastrados com sucesso !', 'Dados Cadastrados', 'INFO')
    	oDlg:End()   		
    
    CASE nPar == 3  // Altera o registro --------------      
   		IF !Validar()
			Return
   		EndIf 		
	    RecLock("ZEW",.F.) 
	    	ZEW->ZEW_DTUM := dDataUlt
	        ZEW->ZEW_PERIOD := cPeriod
			ZEW->ZEW_DESC  := mDesc		
		MsUnlock("ZEW") 
    	MsgBox('Dados Alterados com sucesso !', 'Dados Alterados', 'INFO')
   		oDlg:End()
    			
    CASE nPar == 4   // Exclui o Registro ------
    	If MsgYesNo("Tem certeza de que deseja excluir?")		
	  		RecLock("ZEW",.F.)
	  			ZEW->(dbDelete())
	 		MsUnLock("ZEW")
	 		MsgBox('Dados Excluidos com Sucesso','Registro Excluido') 
 			oDlg:End()	 	 		
	 	ENDIF
	 	        
    OTHERWISE  // No caso de uma opera��o de "Visualizar"         
    	oDlg:end()   
		
  ENDCASE  		 		

	
Return    
/********************************************************************/        

//*** FUN��O DE VALIDA��O DOS CAMPOS **************************
Static Function Validar()

If Empty(cGetCod) 
  Alert('Favor informar o c�digo do produto') // Valida o c�digo do dispositivo
  Return .F.
EndIf  
  
If Empty(cLetra)
  Alert('Favor informar a letra do dispositvo')  // Valida a letra do dispositivo
  Return .F.
EndIf

If Empty(cGetPrev)
  Alert('Favor informar a preventiva') // Valida a preventiva
  Return .F.
EndIf   

If Empty(cPeriod)
  Alert('Favor informar o periodo de dias at� a prox. manuten��o') // Valida a data do produto
  Return .F.
EndIf 

    
Return .T. 
//**********************************************************//

/****** Verifica Filial, Cod, Letra e Seq, e gera um novo sequencial ******/
Static Function GeraSeq()
Local nRecZew := ZEW->(RECNO()) //Guarda a posi��o da tabela ZEW
Private cSeq := '0' , dData := CtoD('  /  /  ')   

IF Empty(cGetCod) .or. Empty(cLetra) .or. Empty(cGetPrev)
	cGetSeq := ''
	oGetSeq:refresh()
	Return
EndIf	

ZEW->(DBSETORDER(2)) 

ZEW->(DBSEEK(cGetCod + cLetra + cGetPrev))

WHILE !ZEW->(Eof()) .AND. ZEW->(ZEW_COD + ZEW_LETRA + ZEW_PRE) == (cGetCod + cLetra + cGetPrev)
   
  	cSeq  := ZEW->ZEW_SEQUE    	
    ZEW->(DBSKIP())
  	
ENDDO  
                                   
cGetSeque := AllTrim( Str(val(cSeq)+1) )

oGetSeq:refresh()

ZEW->(DBGOTO(nRecZew)) // Retorna posi��o do ZEW

Return  
/*******************************************************************/

// Busca a data da ultima manuten��o da manuten��o de preventiva feita
Static function fBuscaData()

cQueryData := " SELECT ZBO_FILIAL, ZBO_DISP, ZBO_LETRA, MAX(ZBO_DATINI) as DATA_FIM "
cQueryData += " FROM " + RetSqlName("ZBO") + " ZBO " 
cQueryData += " WHERE ZBO_DISP = '"+cGetCod+"' "  
cQueryData += " AND ZBO_LETRA = '"+cLetra+"' "
cQueryData += " AND ZBO_CDPREV = '"+cGetPrev+"' "
cQueryData += " GROUP BY ZBO_FILIAL, ZBO_DISP, ZBO_LETRA "

TCQUERY cQueryData NEW ALIAS "TMP"
TcSetField("TMP","DATA_FIM","D")  // Muda a data de string para date 

dDataUlt := TMP->DATA_FIM

IF Empty(dDataUlt) 
	lData := .F.
Else 
	lData := .T.	
EndIF
	
oDataUlt:Refresh()
oDataUlt:SetFocus(oDataUlt)
	
TMP->(DbCloseArea())

Return 

/************** VALIDA PREVENTIVA **********************************/
Static Function fPrev()

ZEE->(DBSETORDER(1)) // FILIAL + CODIGO

IF !ZEE->(DBSEEK(xFilial("ZEE") + cGetPrev))
	Alert('Preventiva n�o encontrada')	
	Return .F.
Else
	cDescPrev := ZEE->ZEE_DESC
	oDescPrev:Refresh()
	fBuscaData() 
ENDIF	

GeraSeq()

ZEE->(DBCLOSEAREA())

Return .T.                       
/********************************************************************/
    
/************** VALIDA DISPOSITIVO + LETRA **************************/
Static Function fDisp(lValLetra)

ZBN->(DBSETORDER(1)) // Filial + Codigo + Letra

IF !ZBN->(DBSEEK(xFilial("ZBN") + cGetCod + iif(lValLetra .AND. cLetra<>'',cLetra,'')))
	Alert('Dispositivo n�o encontrado')
	cDescDisp := ''	
	oDesDisp:Refresh()
	Return .F.
Else
	cDescDisp := ZBN->ZBN_DESC
	oDesDisp:refresh()		
ENDIF

GeraSeq()

ZBN->(DBCLOSEAREA())

Return .T.
//******************************************************************/ 

/****** Preenche a Descri��o da Preventiva *************************/
Static Function fPreDesc()                                           

	ZEE->(DBSETORDER(1))      	   
    IF ZEE->(DBSEEK(xFilial("ZEE") + cGetPrev))
      cDescPrev := ZEE->ZEE_DESC
      oDescPrev:Refresh()
    ENDIF
    
    ZEE->(DBCLOSEAREA())

Return
/*******************************************************************/

Static Function Cancelar() /** Evento do bot�o cancelar **/
	
	RollBackSX8()
	oDlg:end()      

Return