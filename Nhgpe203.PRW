/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE203 �Autor  �Marcos R Roquitski  � Data �  22/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Trava lancamento mensal.                                   ���
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


User Function Nhgpe203()

	SetPrvt("_cMvGpe202c,_aGrupo,_cLogin")

	_aGrupo := pswret()
	_cLogin := _agrupo[1,2]
		
	_cMvGpe202c := Alltrim(GETMV("MV_GPE202C")) // Sequencial
	
	If ALLTRIM(_cLogin) $ Alltrim(_cMvGpe202c)
		GPEA090()	
 
	Else
		MsgBox("Rotina Bloqueada, favor entrar em contato com Administrador da Folha de Pagameto.","Bloqueio de Lancamentos","STOP")
	
	Endif	
		 				
Return(.T.)

