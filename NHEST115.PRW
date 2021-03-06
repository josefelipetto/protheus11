/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHEST115  � Autor � Jo�o Felipe da Rosa    Data � 26/02/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gatilho para preencher a localizacao e o lote              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Rdmake                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Compras / financeiro                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"
#include "topconn.ch"
   
User Function nhest115()

Local cQuery

Local _nLocaliz := aScan(Aheader,{|x| UPPER(X[2])=="D3_LOCALIZ"})
Local _nLote 	:= aScan(Aheader,{|x| UPPER(x[2])=="D3_LOTECTL"})

If CTM$"002"
	cQuery := "SELECT TOP 1 B8_LOTECTL FROM "+RetSqlName("SB8")
	cQuery += " WHERE B8_PRODUTO = '"+Acols[n][1]+"'"
	cQuery += " AND B8_LOCAL = '10'"
	cQuery += " AND B8_SALDO > 0"
	cQuery += " ORDER BY B8_DTVALID"
    
	TCQUERY cQuery NEW ALIAS "TRA1"
	
If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
//	Acols[n][_nLocaliz]  := "01"
	Acols[n][_nLote] := TRA1->B8_LOTECTL

EndIf
	TRA1->(DbCloseArea())
	DbSelectArea("SX7")
EndIf	

Return("01")

                                           
