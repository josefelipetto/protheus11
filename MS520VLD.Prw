/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MS520VLD  �Autor  �Alexandre R. Bento  � Data � 06/10/06    ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se foi gerado a ordem de libera��o p/ esta nota   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � WHB Usinagem / Fundi��o                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
#INCLUDE 'RWMAKE.CH'
User Function MS520VLD()

Local lRet		:= .T.
Local nRegSD2	:= SD2->(Recno())  //Guarda posi��o do registro do SD2    
Local nRegSF4	:= SF4->(Recno())  //Guarda posi��o do registro do SF4    
Local _lDupl 	:= .F.
SZN->(DbSetOrder(1))//filial+doc		                                  
SZM->(DbSetOrder(1))//filial+doc		
SD2->(DbSetOrder(3))
SF4->(DbSetOrder(1))//Filial+TES
If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
	If SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
		If SF4->F4_DUPLIC$"S"
			_lDupl := .T.
		Endif
	Endif
   If !Empty(SD2->D2_ORDLIB) .and. !alltrim(upper(cUserName))$"JOAOFR/ALEXANDRERB/MARCOSR/GUILHERMEDC/LUIZWJ/DOUGLASSD"
      
      //-- chamado 032431
   	  //-- joaofr
   	  //-- 22/05/2012
   	  If SZM->(Dbseek(xFilial("SZM")+SD2->D2_ORDLIB))
	   	  Alert('A NF: '+SF2->F2_DOC+' Serie: '+SF2->F2_SERIE+' Cliente: '+SF2->F2_CLIENTE+'/'+SF2->F2_LOJA+' n�o ser� exclu�da pois possui Ordem de Libera��o: '+SD2->D2_ORDLIB+ '!')
   		  lRet := .f.
      EndIf
      /*
      SZN->(Dbseek(xFilial("SZN")+SD2->D2_ORDLIB))
      While !SZN->(EOF()) .And. SZN->ZN_DOC == SD2->D2_ORDLIB // marcas todos os itens da ordem de libera��o
	  
	  	 RecLock("SZN")
		    SZN->ZN_OBS := "EXCLUIDA" 	//Marca a ordem de libera�ao como excluida
	     MsUnlock("SZN")
	     SZN->(Dbskip())
      Enddo
	  Aviso("Aten��o","Esta Nota, Possui a Ordem de Libera��o "+SD2->D2_ORDLIB+ " Que Vai Ser Marcada como Excluida pelo Sistema.",{"Ok"})
	  // lRet := .F.
	  */
      
      //-- fim chamado 032431
      	  
	Endif
EndIf
SD2->(Dbgoto(nRegSD2))//Retorna posi��o do registro do SD2
SF4->(Dbgoto(nRegSF4))//Retorna posi��o do registro do SF4

//-- OS N�: 030990
//-- Autor: Joao Felipe da Rosa
//-- 27/04/2012

ZAF->(dbsetorder(2)) //ZAF_FILIAL+ZAF_DOC+ZAF_SERIE
If !ZAF->(dbSeek(xFilial('ZAF')+SF2->F2_DOC+SF2->F2_SERIE))
	Alert('N�o existe Solicita��o de Exclus�o de NF para esta NF! Verifique!')
	If !alltrim(upper(cUserName))$"JOAOFR/ALEXANDRERB/MARCOSR/LUIZWJ/DOUGLASSD"
		lRet := .F.
	ENDIF
Else
	RecLock('ZAF',.F.)
		ZAF->ZAF_STATUS := 'S'
	MsUnLock('ZAF')
Endif	

//-- Fim OS 030990 


// Adicionado os itens da NF - 19/12/2013 - OS: 052489
If lRet .And. _lDupl
	
	cTo := "fernandow@whbbrasil.com.br;"
	cTo += "cibelleh@whbusinagem.com.br;"
	cTo += "valdelenems@whbbrasil.com.br;"	
	cTo += "cassianors@whbbrasil.com.br;"
	
	cMsg := '<h3>Aviso de Exclus�o de Nota Fiscal</h3><br />'
	cMsg += 'Foi exclu�da a seguinte Nota Fiscal: <br /><br />'
	cMsg += 'Nota Fiscal: ' + SF2->F2_DOC + '<br />'
	cMsg += 'Serie: ' + SF2->F2_SERIE + '<br />'
	cMsg += 'Cliente: ' + SF2->F2_CLIENTE + '<br />'
	cMsg += 'Data Emissao: ' + DTOC(SF2->F2_EMISSAO) + '<br/><br/>' 
	
	SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
	
	// Adicionado em 19/12/2013	 - DOUGLASSD
	While SD2->(!EOF()) .AND. SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)==SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
	                                                
	    cMsg += 'Item: ' + SD2->D2_ITEM + '<br/>'                                                       
		cMsg += 'Produto: ' + SD2->D2_COD + '<br/>'
		cMsg += 'Quantidade: ' + ALLTRIM(STR(SD2->D2_QUANT)) + '<br/><br/>'
		
		SD2->(DbSkip())
		
	EndDo
	
	SD2->(Dbgoto(nRegSD2)) //Retorna posi��o do registro do SD2
	
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := "*** AVISO DE EXCLUS�O DE NOTA FISCAL " + SF2->F2_DOC + " ***"
	oMail:cTo      := cTo	
	oMail:Envia()    
	
Endif

Return(lRet)