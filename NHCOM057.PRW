/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCOM057  �Autor  �Jo�o Felipe da Rosa � Data �  18/08/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Modificacao da rotina A125Produto que valida o produto     ���
���          � dos pedidos em aberto                                      ���
�������������������������������������������������������������������������͹��
���Uso       � COMPRAS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHCOM057(cProduto)                                

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A125Produto� Autor �Alexandre Inacio Lemes�Data  �18/08/2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao do produto digitado                              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := A125Produto(ExpC1)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = produto                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                              	  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Mata125                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//Function A125Produto(cProduto)

Local aArea		 := GetArea()
Local cProdRef   := ""
Local cDescri	 := ""
Local cVar       := &(ReadVar())
Local nPGrade    := aScan(aHeader,{|x| Alltrim(x[2])=="C3_GRADE"})
Local nPQtd      := aScan(aHeader,{|x| Alltrim(x[2])=="C3_QUANT"})
Local nPProduto  := aScan(aHeader,{|x| Alltrim(x[2])=="C3_PRODUTO"})
Local nPItGrd    := aScan(aHeader,{|x| Alltrim(x[2])=="C3_ITEMGRD"})
Local nPosDesc   := 0
Local nX         := 0
Local lRet 		 := .T.
Local lReferencia:= .F.
Local lGrade     := MaGrade()

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Final("Atualizar SIGACUSB.PRX !!!")
Endif
//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao do ATUALIZADOR  �
//� do dicionario do modulo de Compras necessario para o uso do     |
//| recurso de grade produtos no MP10 Relese I dever� ser retirado  |
//| no proximo Release da Versao quando o dicionario for Atualizado |
//�������������������������������������������������������������������
If !(FindFunction("UPDCOM01_V") .And. UPDCOM01_V() >= 20070807)
	Final("Atualizar UPDCOM01_V.PRW ou checar o processamento deste UPDATE !!!")
EndIf

If !inclui .and. cVar # cCampo .and. !Empty(cCampo)
	HELP(" ",1,"A120CANNOT")
	Return(.F.)
Endif
cProdRef:=cProduto
If lGrade
	lReferencia := MatGrdPrrf(@cProdRef)

	If cProduto==GdFieldGet("C3_PRODUTO")
		Return(.T.)
	Endif	

	//������������������������������������������������������Ŀ
	//� Monta o AcolsGrade e o AheadGrade para este item     �
	//��������������������������������������������������������
	oGrade:MontaGrade(n,cProdRef,.T.,,lReferencia,.T.)

	If ( lReferencia )
		If ( nPGrade > 0 )
			aCols[n][nPGrade] := "S"
			lReferencia := .T.
		EndIf
		aCols[n][nPQtd] := 0
		cDescri := oGrade:GetDescProd(cProdRef)
	Else
		If ( nPGrade > 0 )
			If aCols[n][nPGrade] == "S"
				aCols[n][nPProduto] := Pad(cProdRef, Len(SC3->C3_PRODUTO))
				aCols[n][nPGrade] := "N"
				aCols[n][nPItGrd] := " "
			Endif				
		EndIf
	EndIf
Endif

dbSelectArea("SB1")
dbSetOrder(1)
If MsSeek(xFilial()+cProdRef,.F.)



/********  modificacao por Jo�o Felipe da Rosa 18/08/2010 **********

	If SB1->B1_CONTRAT $"N ".And.!lReferencia
		Help(" ",1,"A125CONTR")
		lRet := .F.
	EndIf

*******************************************************************/


	//�������������������������������������������������������������������������������������Ŀ
	//� Verifica se o produto x fornecedor foi bloqueado pela Qualidade.	                �
	//���������������������������������������������������������������������������������������
	If lRet.And.!lReferencia
		lRet := QieSitFornec(cA125Forn,cA125Loj,cProduto,.T.)
	EndIf

	//���������������������������������������Ŀ
	//� Verifica se o Registro esta Bloqueado.�
	//�����������������������������������������
	If lRet .And. !RegistroOk("SB1").And.!lReferencia
		lRet := .F.
	EndIf

	If lRet
		cDescri := SB1->B1_DESC
		dbSelectArea("SB5")
		dbSetOrder(1)
		MsSeek(xFilial()+cProduto)
		If !Empty(B5_CEME)
			cDescri := B5_CEME
		EndIf
		dbSelectArea("SB1")
		For nX = 1 to Len(aHeader)
			Do Case
			Case Trim(aHeader[nX][2]) == "C3_LOCAL"   	// Local
				If Empty(aCols[n][nX])
					aCols[n][nX] := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
				EndIf
			Case Trim(aHeader[nX][2]) == "C3_DESCRI"	// Descricao
				nPosDesc := nX
			Case Trim(aHeader[nX][2]) == "C3_IPI"     	// Percentual de IPI
				aCols[n][nX] := SB1->B1_IPI
			Case Trim(aHeader[nX][2]) == "C3_SEGUM"    // Percentual de IPI
				aCols[n][nX] := SB1->B1_SEGUM
			EndCase
		Next nX

		If nPosDesc > 0
			If Len(aCols[n][nPosDesc]) > Len(cDescri)
				aCols[n][nPosDesc] := cDescri+Space(Len(aCols[n][nPosDesc])-Len(cDescri))
			Else
				aCols[n][nPosDesc] := SubStr(cDescri,1,Len(aCols[n][nPosDesc]))
			EndIf
		EndIf

	EndIf
Else
	Help("  ",1,"REGNOIS")
	lRet := .F.
EndIf

RestArea(aArea)

Return lRet
