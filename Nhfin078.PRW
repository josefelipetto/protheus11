/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHFIN078  �Autor  �Marcos R Roquitski  � Data �  03/05/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Envia email de Avisos aos Fornecedores.                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhfin078()

SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome,_cTempo")

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
lConectou
lEnviado
cMensagem := '' 
CRLF := chr(13)+chr(10)
cMSG := ""
lEnd := .F.   
e_email = .F.                         

if MsgBox("Confirma email aos fornecedores","Enviar e-mail","YESNO")

	fEnvEmaila()

endif
Return(.t.)

Static Function fEnvEmaila()
Local lRet := .F.
Local _nTotPro := 0
Local _nTotDes := 0
Local _nZero := 0
Local _cMes := Space(20)
Local _aFile := {}
Local _nEnvia := 0
Local _aFile3 := {}
DbSelectArea("SA2")
SA2->(DbSetOrder(1))
SA2->(Dbgotop())

While !SA2->(Eof())

	lRet   := .T.
//	_cMail := "alexandrerb@whbbrasil.com.br"
	_cMail := Alltrim(SA2->A2_EMAIL)

	cMsg := '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title>.</title>' + CRLF
	cMsg += '</head>' + CRLF

/*
Senhores;
Este ano a WHB COMPONENTES AUTOMOTIVOS S/A., realizar� a 11� SIPAT � SEMANA INTERNA DE PREVEN��O DE ACIDENTES DO TRABALHO
Como tradicionalmente ocorre, distribuiremos nesta semana, atrav�s de concursos internos, pr�mios doados com a colabora��o dos nossos fornecedores.
Assim solicitamos a sua colabora��o no sentido de participar como patrocinador deste evento.
Segue em anexo, uma rela��o com poss�veis sugest�es para brindes.
Agradecemos a aten��o e colabora��o de todos.
Att.
*/                                           


/*
  

Prezado Fornecedor, 

Segue anexo correspond�ncias refere-se as regras para a utiliza��o da NF-eletronica a partir de 01/04/2009.

Quaisquer d�vida estamos ao seu dispor.

Att.

Departamento Fiscal

Obrigada
*/


    cMsg += '<b><font size="3" face="Arial">Prezado Fornecedor,</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'

	cMsg += '<b><font size="3" face="Arial">Segue anexo correspond�ncia referente as regras para a utiliza��o da NF-eletr�nica a partir de 01/04/2009.</font></b>' + CRLF
//	cMsg += '<b><font size="3" face="Arial">Este ano a WHB COMPONENTES AUTOMOTIVOS S/A., realizar� a 11� SIPAT � SEMANA INTERNA DE PREVEN��O DE ACIDENTES DO TRABALHO</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'

	cMsg += '<b><font size="3" face="Arial"> Quaisquer d�vida estamos ao seu dispor.</font></b>' + CRLF
//	cMsg += '<b><font size="3" face="Arial">Como tradicionalmente ocorre, distribuiremos nesta semana, atrav�s de concursos internos, pr�mios doados com a colabora��o dos nossos fornecedores.</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'


	e_email = .T.                                   


	If lRet .and. !Empty(_cMail)

		cMsg += '</tr>'
		cMsg += '</table>'
		cMsg += '</tr>' + CRLF

		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Arial">' + "Atenciosamente,"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="4" face="Arial">' + "Depto Fiscal - WHB"+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF

		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="1" face="Arriel">' + "OBSERVACAO:"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="1" face="Arriel">' + "N�o responda a esta mensagem, pois foi enviada de um endere�o de e-mail n�o monitorado as mensagens enviadas a este endere�o n�o podem ser respondidas."+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF


		cMsg += '</body>' + CRLF
		cMsg += '</html>' + CRLF      
        aadd(_aFile, "\System\NFEU.PDF")


       
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail); //'marcosr@whbbrasil.com.br';
			SUBJECT ' Nota Fiscal Eletr�nica WHB ';
			BODY cMsg;
	        ATTACHMENT _aFile[1];
			RESULT lEnviado
		Endif
		lRet := .F.
	Endif	
	
	
	SA2->(DbSkip())
	_nEnvia++

	If _nEnvia >= 10000

		If MsgBox("Continua saida de e-mail ","Enviando e-mail","YESNO")		
		   _nEnvia := 0
		Endif	

	Endif		
	
Enddo

Msgbox("Processo concluido com sucesso !","Enviar email","ALERT")

Return(.T.)
