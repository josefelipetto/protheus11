/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE254 �Autor  �Marcos R Roquitski  � Data �  22/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueio calculo folha de pagamento                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch" 
#include "Font.ch" 
#include "Colors.ch" 


User Function Nhgpe254()

	If MsgBox("Bloquea Rotina de Calculo de ** FOLHA DE PAGAMENTO ?.","Bloqueio de Lancamentos","YESNO")

		SX6->(DbSeek(xFilial("SRA")+"MV_GPEM020"))
		If SX6->(Found())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "S"
			MsUnlock("SX6")

			Alert("** FOLHA DE PAGAMENTO,  BLOQUEADA para manutencao.")	
		Else
			Alert("Parametro MV_GPEM020 Nao cadastrado. Verifique no cadastro de parametros!")	

		Endif	
	
	Else
	
		SX6->(DbSeek(xFilial("SRA")+"MV_GPEM020"))
		If SX6->(Found())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "N"
			MsUnlock("SX6")

			Alert("** FOLHA DE PAGAMENTO,  LIBERADA para manutencao.")

		Else

			Alert("Parametro MV_GPEM020 Nao cadastrado. Verifique no cadastro de parametros!")	

		Endif	
		
	Endif
	
Return
