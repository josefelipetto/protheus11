/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NHEST180        � Alexandre R. Bento    � Data � 29.12.10 ���
������������������������������������������������������������������������Ĵ��
���Descri��o � Permite Alterar o parametro MV_ULMES                      ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

#include "rwmake.ch"      

User Function NhEst180()  
Private _TBloq
Private _dData := GETMV("MV_ULMES") //data do fechamento


 	Define MsDialog _TBloq Title OemToAnsi("Bloqueio") From 030,015 To 250,375 Pixel
    @ 010,006 To 100,180 Title OemToAnsi(" Data de Bloqueio de Movimenta��es de Materiais ") //Color CLR_HBLUE
	@ 035,020 Say "Data : " Size 50,50
	@ 035,045 Get _dData Picture "99/99/9999" Size 50,10 Object oData
	
    @ 085,085 BMPBUTTON TYPE 01 ACTION fGData()
	Activate MsDialog _TBloq Center 

Return

Static Function fGData()

If MsgYesNo("Confirma Altera��o da Data de Bloqueio")

      _dData := Dtos(_dData)
      Dbselectarea("SX6")
      GETMV("MV_ULMES") //data do fechamento
      RecLock("SX6",.F.)
	     SX6->X6_CONTEUD:= _dData
	  MsUnlock("SX6")

EndIf

Close(_TBloq)  
Return(nil)      
