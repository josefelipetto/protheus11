/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT231G1  � Autor � Alexandre R. Bento    � Data � 03.09.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Reabertura de solicita��o de Compras                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Compras (Na Elimina��o de Residuos)                        ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���																		  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#Include "rwmake.ch"    
User Function MT235G1()


If mv_par08 ==1 // Elimina residuo de pedido de compras 
	If (SC7->C7_QUANT-SC7->C7_QUJE) > 0 .And. !Empty(SC7->C7_NUMSC)
	   If MsgBox("Deseja Abrir a Solicita��o de Compra  "+SC7->C7_NUMSC +"  para o Produto "+Chr(13)+;
	             SC7->C7_PRODUTO + " - "+ Subs(SC7->C7_DESCRI,1,30)+Chr(13)+;
	             "Com a Qtde " + Transform(SC7->C7_QUANT-SC7->C7_QUJE,"@e 999,999,999.99"),"Reabertura de Solicitacao","YESNO") 
	      SC1->(DbSetOrder(1)) //filial + Numero SC + Item SC
		  If SC1->(DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC)) 
		     If SC1->C1_RESIDUO$"S"
		        MsgBox("A SC "+SC1->C1_NUM + " Esta eliminada Residuo, Por isso Nao Pode Ser Reaberta","Reabertura de Solicitacao","STOP") 
		     Else
			    RecLock("SC1",.F.)
		           SC1->C1_QUJE := Iif((SC1->C1_QUJE - SC7->C7_QUANT) < 0,0,(SC1->C1_QUJE - SC7->C7_QUANT))
		        MsUnLock("SC1")
		     Endif   
		  Endif   
	   Endif    
	Endif          
Endif
	          
Return 
