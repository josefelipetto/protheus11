/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE279  �Autor  �Marcos R. Roquitski � Data �  11/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �Nao calcula adiantamento salarial para adimissa no mes de   ���
���          �calculo.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       �WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


#include "rwmake.ch"

User Function Nhgpe279()

Local _cCalcule := "S"
Local _dDatac   := Ctod('01/' + Substr(MesAno(dDataBase),5,2) + '/' + Substr(MesAno(dDataBase),1,4) )

If SRA->RA_ADMISSA >= _dDatac ;	_cCalcule := "N"
Endif
Return(_cCalcule)
