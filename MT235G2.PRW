/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT235G2  � Autor � Alexandre R. Bento    � Data � 03.07.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Reabertura de solicita��o de Compras                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Compras (Na Elimina��o de Residuos)de contratos de parceria���
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
User Function MT235G2()

If mv_par08 ==4 .or. mv_par08==1 // PEDIDO EM ABERTO ou PEDIDO DE COMPRAS

	If mv_par08 ==4     // PEDIDO EM ABERTO
	
		If (SC3->C3_QUANT-SC3->C3_QUJE) > 0 .And. !Empty(SC3->C3_NUMSC)
		   	SB1->(DbSetOrder(1)) //filial + cod
	        SB1->(DbSeek(xFilial("SB1")+ SC3->C3_PRODUTO))
	        If SB1->(Found())	
		   
		       If MsgBox("Deseja Abrir a Solicita��o de Compra  "+SC3->C3_NUMSC +"  para o Produto "+Chr(13)+;
		             SC3->C3_PRODUTO + " - "+ Subs(SB1->B1_DESC,1,30)+Chr(13)+;
		             "Com a Qtde " + Transform(SC3->C3_QUANT-SC3->C3_QUJE,"@e 999,999,999.99"),"Reabertura de Solicitacao","YESNO") 
		          SC1->(DbSetOrder(1)) //filial + Numero SC + Item SC
				  If SC1->(DbSeek(xFilial("SC1")+SC3->C3_NUMSC+SC3->C3_ITEMSC)) 		 	  
				     If SC1->C1_RESIDUO$"S"
				        MsgBox("A SC "+SC1->C1_NUM + " Esta eliminada Residuo, Por isso Nao Pode Ser Reaberta","Reabertura de Solicitacao","STOP") 
				     Else
					    RecLock("SC1",.F.)
				           SC1->C1_QUJE := SC3->C3_QUANT - SC3->C3_QUJE
				        MsUnLock("SC1")
				     Endif   
				  Endif   
		          
			   Endif   
		    Endif    
		Endif          
	Endif

	//-- PARA ELIMINAR PC OU PA SOMENTE SE USUARIO FOR COMPRADOR
	SY1->(dbSetOrder(3)) // Y1_FILIAL+Y1_USER                                                                                                                                               
	If !SY1->(dbSeek(xFilial('SY1')+__cUserID))
		Return .F.
	Endif
		
ElseIf mv_par08==5 // SC
    
	//-- para eliminar SC somente sendo COMPRADOR ou sendo o SOLICITANTE
	SY1->(dbSetOrder(3)) // Y1_FILIAL+Y1_USER                                                                                                                                               
	If !SY1->(dbSeek(xFilial('SY1')+__cUserID))
		If ALLTRIM(SC1->C1_SOLICIT)<>ALLTRIM(UPPER(cUserName))
			Return .F.
		Endif
	Endif
		
Endif
	          
Return .T.