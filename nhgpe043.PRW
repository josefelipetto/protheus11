/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE043  �Autor  �Marcos R. Roquitski � Data �  13/05/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtra funcionarios com o matricula inferior a 900000.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#Include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function  Nhgpe043()

DbSelectArea("SRA")
Set Filter to Substr(SRA->RA_MAT,1,1) == "0"
SRA->(DbGotop())

GPEA180() // Transferencia          

Set Filter to
SRA->(DbGotop())

Return(nil)