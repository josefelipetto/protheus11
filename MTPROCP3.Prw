/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTPROCP3C� Autor �Alexandre R. Bento     � Data �11/05/2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtrar o saldo dos produtos que j� foram atendidos no SB6 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Obs.:     �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#INCLUDE "RWMAKE.CH"
User Function MTPROCP3()
SetPrvt("_cAliasSB6") 

_cAliasSB6 := PARAMIXB[1]       

Return(  (_cAliasSB6)->B6_ATEND#"S" )
