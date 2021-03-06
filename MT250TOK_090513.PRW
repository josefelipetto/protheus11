/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT250TOK  �Autor  � Jo�o Felipe da Rosa� Data �  25/05/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Executado na fun��o A250TudoOk(), rotina responsavel por   ���
���          � validar os apontamentos de produ��o simples                ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#Include 'rwmake.ch'

User Function MT250TOK
Local lRet     := ParamIXB //-- Valida��o do Sistema
Local cQuery   := ''  

/************* TESTE: INVENTARIO *******************/
//Verifica se produto est� bloqueado para invent�rio	
	If !U_E205BLQ(M->D3_COD,M->D3_LOCAL)				
	    Return .F. 	
	EndIF
/***************************************************/

//-- FUNDICAO
If SM0->M0_CODIGO=="FN"

	If Alltrim(M->D3_CC)$"ALMOXARI"
		Alert("Centro de Custo n�o pode ser ALMOXARI!")
		lRet := .F.
	EndIf
	
	SB1->(dbSetOrder(1)) // FILIAL + COD
	SB1->(dbSeek(xFilial("SB1")+M->D3_COD))
	
	If ALLTRIM(SB1->B1_GRUPO)$"PA01" .AND. EMPTY(M->D3_DTFUNDI)
		Alert('Informe a Data de Fus�o')
		Return .F.
	EndIf

//-- USINAGEM
ElseIf SM0->M0_CODIGO=="NH" 

	If Alltrim(M->D3_CC)$"ALMOXI"
		Alert("Centro de Custo n�o pode ser ALMOXI!")
		lRet := .F.
	EndIf

EndIf

//-- FUNDICAO E USINAGEM
If Empty(M->D3_CC)
	Alert("Informe o Centro de Custo!")
	Return .F.
EndIf

//�������������������������������������Ŀ
//� VALIDA��O EXTRA DE SALDOS           �
//� MOTIVO: O SISTEMA ESTAVA PERMITINDO �
//� APONTAMENTO DE PRODUCAO ONDE        �
//� A MATERIA PRIMA MP04.000026 ESTAVA  �
//� FICANDO NEGATIVO                    �
//���������������������������������������
//SG1->(dbsetorder(1))//G1_FILIAL+G1_COD+G1_COMP+G1_TRT                                                                                                                                 
//SG1->(dbseek(xFilial("SG1")+M->D3_COD))

aSemSaldo := {}
aSaldo    := {}
nSaldo    := 0
nNeces    := 0
                       
SD4->(DBSETORDER(2))//D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
SD4->(DBSEEK(XFILIAL("SD4")+M->D3_OP))

WHILE !SD4->(eof()) .and. SD4->D4_FILIAL==xFilial("SD4") .AND. SD4->D4_OP==M->D3_OP
	                          
    If !substr(SD4->D4_COD,1,3)$'MOD' .AND. SD4->D4_QTDEORI > 0
    	
    	aSaldo := CalcEst(SD4->D4_COD,SD4->D4_LOCAL,dDatabase+1)
    	nSaldo := aSaldo[1]
    	nNeces := (SD4->D4_QTDEORI/SC2->C2_QUANT) * M->D3_QUANT
    	
    	//-- SALDO - QUANTIDADE A CONSUMIR NO APONTAMENTO
    	If (nSaldo - nNeces) < 0
    		aAdd(aSemSaldo,{SD4->D4_COD,nSaldo,nNeces})
		Endif

    EndIf
    
    SD4->(dbskip())
ENDDO

If Len(aSemSaldo)>0
	
	cMsg := "Falta de Saldo de Componente(s) para apontamento da OP!"+CHR(13)+CHR(10)+CHR(13)+CHR(10)
	
	For xS:=1 to len(aSemSaldo)
		cMsg += aSemSaldo[xS][1]+" Saldo: "+alltrim(str(aSemSaldo[xS][2]))+" Usa: "+alltrim(str(aSemSaldo[xS][3]))+" Falta: "+alltrim(str((aSemSaldo[xS][2]-aSemSaldo[xS][3])*-1))+CHR(13)+CHR(10)
	Next

	MsgBox(cMsg,"Falta de Saldo","ALERT")     

	Return .F.
Endif

Return lRet  //-- (.T.) Valida apontamento de produ��o