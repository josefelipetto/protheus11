/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A103CND2  �Autor  �Alexandre R.Bento   � Data �  12/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE para recalculo da dt vencimento das parcelas             ��
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo para WHB Usinagem e Fundi��o S.A.                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
User Function A103CND2()      	
Local _nx      := 0
Local _nVlrTot := 0
Local _aVenc   := {}

If Alltrim(GETMV("MV_FINDUP")) == "S"
	For _nx := 1 to Len(paramixb)
	    _nVlrTot +=paramixb[_nx][2] //somente tras o valor total da nota
	Next _nx
//calcula o vencimento das parcelas com a database, ou seja, a data de digita��o
	_aVenc := Condicao(_nVlrTot,cCondicao,,dDataBase) 
    Return(_aVenc)	
Endif	
 
Return
                     