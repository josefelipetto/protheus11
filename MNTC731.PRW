#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MNTC7301   �Autor �Jo�o Felipe         � Data �  05/05/2008���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA QUE INSERE UM BOTAO NA ROTINA MNTC730     ���
���			 � CONSULTA->PLANO->ORDENS DO BEM 					  		  ���
�������������������������������������������������������������������������͹��
���Uso       � MANUTENCAO	                                              ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function  MNTC7301()
	aAdd(aROTINA,{"Ord. Servico","U_MNTCONS()",0,1}) //adiciona um botao no mbrowse
Return(.T.)							

User Function MNTCONS()
Local olddetalhe,ccondicao

Private cCadastro := OemtoAnsi("Ordens de Servico") //"Ordens de Servico"
olddetalhe := aCLONE(aROTINA) 
aRotina    := {{"Pesquisar"		 ,"NG600RPES"  	 , 0, 1   },;  //"Pesquisar"
                {"Visual."		 ,"AXVISUAL"     , 0, 2   },;  //"Visual."
                {"Detalhes"		 ,"MNTCOSDE"   	 , 0, 3, 0},;  //"Detalhes"
                {"Imprimir"		 ,"U_NHMNT002"    , 0, 3, 0},;  //"Imprimir"
                {"Ocorren."      ,"MNTCOCOR"   	 , 0, 4, 0},;  //"Ocorren."
                {"Problemas"     ,"OsProblema"   , 0, 4, 0},;  //"Problemas"  
                {"Motivo Atraso" ,"NGATRASOS" 	 , 0, 4, 0},;  //"Motivo Atraso"
                {"Etapas"        ,"OsEtapas"  	 , 0, 4}}      //"Etapas"               

M->T9_CODBEM := ST9->T9_CODBEM
DbSelectArea("STJ")
DbSetOrder(02)
cKey   := "B"+M->T9_CODBEM
bWHILE := {|| !Eof() .And. STJ->TJ_TIPOOS == "B" .And. STJ->TJ_CODBEM  == M->T9_CODBEM}
bFOR   := {|| TJ_FILIAL  == xFILIAL("STJ")}

NGCONSULTA("TRBJ",cKEY,bWHILE,bFOR,aRotina,{})
DbSelectArea("STJ")
DbSetOrder(01)
aRotina := aCLONE(olddetalhe)

Return .T.
