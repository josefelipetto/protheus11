/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120ISC  �Autor  �Microsiga           � Data �  03/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Apos calculo da folha atualiza campo RC_CC centro de custo ���
���          � com o do cadastro do funcionario RA_CC                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function VerLogFl()
/*
SRC->(DbSetOrder(1))
SRA->(DbGotop())
While !SRA->(Eof())	
	If SRA->RA_SITFOLH <> 'D'
		DbSelectArea("SRC")
		SRC->(DbSeek(xFilial('SRC') + SRA->RA_MAT))
		While !SRC->(Eof()) .AND. SRC->RC_MAT == SRA->RA_MAT
			If SRC->RC_CC <> SRA->RA_CC	
				Reclock('SRC',.F.)
				SRC->RC_CC := SRA->RA_CC			
				MsUnlock('SRC')
			Endif	
			SRC->(DbSkip())
		Enddo	
		DbSelectArea("SRA")
	Endif			
	SRA->(DbSkip())
Enddo
*/
Return(.T.)
