
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A120AEFL  �Autor  �Alexandre R. Bento  � Data �  03/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada no pedido de compra, apos teclar F4 para   ���
���          �selecionar as pedido em aberto filtra o fornecedor e loja   ���
�������������������������������������������������������������������������͹��
���Uso       �Geral / Autorizacao de compras - mata122                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//nTipo  Num�rico  nTipo == 1 - Pedido de Compras   nTipo == 2 - Autoriza��o de Entrega
#Include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"

User Function A120AEFL() 

Local cFiltro1 := ' ' 
Local cFiltro2 := ' ' 
//ParamIXB[1]

If Upper(Alltrim(Funname()))$"MATA122" 
   
   cFiltro1 :=  " C3_FORNECE= '" + CA120FORN + "' .And.  C3_LOJA = '" + CA120LOJ + "'"   

Endif   
                            
Return ( {cFiltro1, cFiltro2} ) 

