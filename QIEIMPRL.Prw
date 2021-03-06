/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � QIEIMPRL        � Alexandre R. Bento    � Data � 22/08/07 ���
������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada p/ fazer a importa��o p/ quality         ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

#include "rwmake.ch"   
User Function QIEIMPRL()

Local _nCod   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_COD"})  
Local _lImpo  := .F.

   If SF1->F1_TIPO$"B/N" .AND. !Empty(AllTrim(SF1->F1_STATUS)) //Beneficiamento
      For _nx:= 1 to Len(Acols)
         SB1->(DbSeek(xFilial("SB1")+Acols[_nx][_nCod]))
         
         IF SM0->M0_CODIGO == "NH"  //empresa WHB Usinagem

            If SB1->B1_TIPO$"PW/CC/MC/CP/MP/BN" //so importa esses tipos
               _lImpo := .T.
            Endif
            
         Elseif SM0->M0_CODIGO == "FN"  //empresa WHB Fundicao
         
            If ( SB1->B1_TIPO$"PW/CC/MC/CP/MP" ) .OR. ; //so importa esses tipos
	           ( SB1->B1_TIPO$"MA" .And. SB1->B1_GRUPO$"MA02/MA03/MA33/MA31" ) .OR. ;//ou so importa esses Grupos do tipo MA
	           ( ALLTRIM(SB1->B1_COD)$"MA01.000133" ) //ou so importa esses produtos
               _lImpo := .T.
            Endif
         
         Endif   
      Next _nx

      If _lImpo // Importa p/ quality
         U_Nhest003("SF1100I")    // Chama fun��o que importa nf beneficiamento para quality
      Endif   
   Endif                              
		
Return .T.