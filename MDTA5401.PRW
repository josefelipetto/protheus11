
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MDTA5401 �Autor  � Jo�o Felipe da Rosa � Data �  10/21/11  ���
�������������������������������������������������������������������������͹��
���Desc.     �  Este ponto de entrada permite a cria��o de sem�foro para 
				controle de extintores, est� dispon�vel na rotina de 
				Extintores e ser� executado ao entrar na rotina.
.                                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAMDT                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MDTA5401()

	Local aCores := {{ "BR_VERDE"    , "Extintor Habilitado" },;
                     { "BR_VERMELHO" , "Extintor c/ Validade Vencida" }}

	Local uRetorno := {}
	
	Aadd(uRetorno, { 'TLA_SITUAC == "A"' , aCores[1][1] } )
	Aadd(uRetorno, { 'TLA_SITUAC <> "A"' , aCores[2][1] } )

Return(uRetorno)

User Function MDTA5402()

	Local aCores := {{ "BR_VERDE"    , "Extintor Habilitado" },;
                     { "BR_VERMELHO" , "Extintor c/ Validade Vencida" }}

	BrwLegenda('',"Legenda",aCores)

Return

