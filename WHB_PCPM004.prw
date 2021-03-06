/*---------------------------------------------------------------------------+
!                             FICHA T�CNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Rotina                                                  !
+------------------+---------------------------------------------------------+
!M�dulo            ! SIGAPCP                                                 !
+------------------+---------------------------------------------------------+
!Nome              ! WHB_PCPM004                                             !
+------------------+---------------------------------------------------------+
!Descri��o         ! Firmar ordem de producao                                !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 23/08/2010                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZAC�ES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descri��o detalhada da atualiza��o      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+-------*/
#Include "Protheus.ch"
#Include "rwmake.ch"

user Function pWhbm004()

Local cHrIni  := "  :  "
Local cHrFim  := "  :  "
Local dDtIni  := SC2->C2_DATPRI
Local dDtFim  := SC2->C2_DATPRF
Local cMaq    := AllTrim(SC2->C2_DISA)
Local cProva  := SC2->C2_PROVA
Local cObs    := SC2->C2_OBSAPON

//tela n�o pode ser cancelada
While !montaTela(@cHrIni,@cHrFim,@dDtIni,@dDtFim,@cMaq,@cProva,@cObs); Enddo

recLock("SC2",.f.)
SC2->C2_OPHRINI := cHrIni
SC2->C2_OPHRFIM := cHrFim
SC2->C2_DATPRI  := dDtIni
SC2->C2_DATPRF  := dDtFim
SC2->C2_DISA    := cMaq
SC2->C2_PROVA   := cProva
SC2->C2_OBSAPON := cObs
msUnLock()

Return

/*-----------------+---------------------------------------------------------+
!Nome              ! montaTela                                               !
+------------------+---------------------------------------------------------+
!Descri��o         ! Funcao para montagem da tela de interface com usuario   !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Ricardo Vieceli                                  !
+------------------+--------------------------------------------------------*/
Static Function montaTela(cHrIni,cHrFim,dDtIni,dDtFim,cMaq,cProva,cObs)

Local lRet := .f.
Local oDlg
Local aDisa := {"", "1=Disa 1","2=Disa 2","3=KW"}
Local aProva := { "N=N�o" , "S=Sim"}
Define MsDialog oDlg Title "Detalhes da Ordem de Produ��o" From 0,0 To 347,395 Pixel Style DS_MODALFRAME

	//Botoes
   	bEnchoice := EnchoiceBar(oDlg,{||lRet := .t.,oDlg:End()},{||Alert('Favor digitar os dados e confirmar!')})

	@ 015,005 To 65,195 Label " Detalhes da Ordem de Produ��o " Of oDlg Pixel
	@ 025,009 Say "N�mero OP:"    Size 035,010 Of oDlg Pixel
	@ 035,009 Say "Produto:"      Size 035,010 Of oDlg Pixel
	@ 045,009 Say "Descri��o"     Size 035,010 Of oDlg Pixel
	@ 055,009 Say "Data Emiss�o:" Size 035,010 Of oDlg Pixel

	@ 025,060 Say SC2->C2_NUM+"\"+SC2->C2_ITEM+"\"+SC2->C2_SEQUEN Size 075,010 Of oDlg Pixel
	@ 035,060 Say SB1->B1_COD           Size 075,010 Of oDlg Pixel
	@ 045,060 Say SB1->B1_DESC          Size 075,010 Of oDlg Pixel
	@ 055,060 Say dtoc(SC2->C2_EMISSAO) Size 075,010 Of oDlg Pixel

	@ 066,005 To 156,195 Of oDlg Pixel
	
	@ 072,009 Say "Linha:"  Size 035,010 Of oDlg Pixel
	@ 070,050 ComboBox cMaq Items aDisa Size 050,007 /*on change fProxHora(@cHrIni,@cHrFim,@dDtIni,@dDtFim,cMaq)*/ Of oDlg Pixel

	@ 084,009 Say "Data In�cio:"  Size 035,010 Of oDlg Pixel
	@ 082,050 Get dDtIni Size 045,007 When(cMaq!="") Picture "@E 99/99/9999" /*Valid fProxHora(@cHrIni,@cHrFim,@dDtIni,@dDtFim,cMaq)*/ Of oDlg Pixel

	@ 096,009 Say "Data Fim:" Size 035,010 Of oDlg Pixel
	@ 094,050 Get dDtFim Size 045,007 When(.F.) Picture "@E 99/99/9999" Of oDlg Pixel

	@ 108,009 Say "Hora In�cio:"  Size 035,010 Of oDlg Pixel
	@ 106,050 Get cHrIni Size 030,007 Picture "@E 99:99" When(cMaq!="") /*Valid valCalcula(@cHrIni,@cHrFim,@dDtIni,@dDtFim)*/ Of oDlg Pixel
	
	@ 120,009 Say "Hora Fim:" Size 035,010 Of oDlg Pixel
	@ 118,050 Get cHrFim  Size 030,007 When(.F.) Picture "99:99" Of oDlg Pixel

	@ 132,009 Say "Prova:"  Size 035,010 Of oDlg Pixel
	@ 130,050 ComboBox cProva Items aProva Size 040,007 Of oDlg Pixel

	@ 144,009 Say "Observ.:"  Size 035,010 Of oDlg Pixel
	@ 142,050 Get cObs  Size 140,007 Picture "@!" /*VALID fPeriodo(dDtIni,dDtFim,cHrIni,cHrFim,cMaq)*/ Of oDlg Pixel

oDlg:Activate(,,,.T.,{||.T.},,bEnchoice)

//Activate MsDialog oDlg Center

//Valida se campo hora foi preenchido corretamente
If lRet
	lRet := atVldHora(cHrIni) .And. atVldHora(cHrFim) .And. !Empty(cMaq) //.And. fPeriodo(dDtIni,dDtFim,cHrIni,cHrFim,cMaq)
Endif

Return(lRet)

/*-----------------+--------------------------------------------------------------+
!Nome              ! fPeriodo                                                     !
+------------------+--------------------------------------------------------------+
!Descri��o         ! Verifica se a o periodo informado n�o sobrep�e o per�odo de  !
!                  ! outra OP.                                                    !
+------------------+--------------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa                                          !
+------------------+-------------------------------------------------------------*/
/*
Static Function fPeriodo(dDtIni,dDtFim,cHrIni,cHrFim,cMaq)
Local cAl := getNextAlias()
Local _lRet := .T. 

    beginSql Alias cAl
    	SELECT
    		C2_NUM num,
    		C2_OPHRINI hi,
    		C2_OPHRFIM hf,
    		C2_DATPRI di,
    		C2_DATPRF df
    	FROM 
    		%Table:SC2% C2 (NOLOCK)
    	WHERE
    		C2_DISA = %Exp:cMaq%
    	AND C2_DATPRF >= %Exp:DtoS(dDtIni)% 
    	AND C2_DATPRI <= %Exp:DtoS(dDtFim)%
		AND C2.%NotDel%
		AND C2.C2_FILIAL = %Exp:xFilial("SC2")%
		AND C2.C2_TPOP = 'F'
    	
    endSql 
    
	TCSETFIELD( cAl,"di","D")
	TCSETFIELD( cAl,"df","D")
    
    While (cAl)->(!Eof())

		If (cAl)->df == dDtIni
			If HoraToInt(cHrIni) < HoraToInt((cAl)->hf) .AND. ;
				HoraToInt(cHrIni) >= HoraToInt((cAl)->hi)
				_lRet := .F.
				EXIT
			EndIF
		ElseIf (cAl)->df >  dDtIni
			IF (cAl)->di == dDtIni
				IF HoraToInt(cHrFim) > HoraToInt((cAl)->hi)
					_lRet := .F.
					EXIT
				EndIf
			ElseIf (cAl)->di < dDtIni
				_lRet := .F.
				EXIT
			EndIf
		EndIf
		
		If (cAl)->di == dDtFim
			If HoraToInt(cHrFim) > HoraToInt((cAl)->hi) .AND. ;
				HoraToInt(cHrFim) <= HoraToInt((cAl)->hf)
				_lRet := .F.
				EXIT
			EndIf
		ElseIf (cAl)->di <  dDtFim
			If (cAl)->df == dDtIni
				If HoraToInt(cHrIni) < HoraToInt((cAl)->hf)
					_lRet := .F.
					EXIT
				EndIf
			ElseIf (cAl)->df > dDtIni
				_lRet := .F.
				EXIT
			EndIf
		EndIf
		
		(cAl)->(DBSKIP())

	EndDo
	
	If !_lRet
    	Alert("O per�odo informado j� est� sendo utilizado por outra OP! " + CHR(10)+CHR(13) + ;
    	      "Favor informar outro per�odo!" + CHR(10)+CHR(13)  + CHR(10)+CHR(13) + ;
    	      "OP: "          +(cAl)->num       + CHR(10)+CHR(13) + ;
    	      "Data In�cio: " + DtoC((cAl)->di) + CHR(10)+CHR(13) + ;
    	      "Data Fim: "    + DtoC((cAl)->df) + CHR(10)+CHR(13) + ;
    	      "Hora In�cio: " + (cAl)->hi + CHR(10)+CHR(13) + ;
    	      "Hora Fim: "    + (cAl)->hf + CHR(10)+CHR(13) ;
    	      )
    	(cAl)->(dbCloseArea())
    	Return .F.
    EndIf

   	(cAl)->(dbCloseArea())

Return .T.
*/
/*-----------------+---------------------------------------------------------+
!Nome              !                                                         !
+------------------+---------------------------------------------------------+
!Descri��o         !                                                         !
+------------------+---------------------------------------------------------+
!Autor             !                                                         !
+------------------+--------------------------------------------------------*/
/*
static Function valCalcula(cHrIni,cHrFim,dDtIni,dDtFim)

Local lRet := .f.
Local nHora := 0
Local nDias := 0

//-- Valida hora
If atVldHora(cHrIni)
    
	//-- calcula a hora final e a data final de acordo com o produto
	cHrFim := U_NHPCP035(SC2->C2_PRODUTO, SC2->C2_QUANT, cHrIni, dDtIni,"H") // H = retorna hora final
	dDtFim := U_NHPCP035(SC2->C2_PRODUTO, SC2->C2_QUANT, cHrIni, dDtIni,"D") // D = retorno data final
	
	//-- Valida hora final
	lRet := atVldHora(cHrIni)

Endif

Return(lRet)
*/

/*-----------------+---------------------------------------------------------+
!Nome              ! fProxHora                                               !
+------------------+---------------------------------------------------------+
!Descri��o         ! Funcao para trazer hora inicial da pr�xima op           !
+------------------+---------------------------------------------------------+
!Autor             ! Jo�o Felipe da Rosa / Mario C. Pietrzak                 !
+------------------+--------------------------------------------------------*/
/*
Static Function fProxHora(cHrIni,cHrFim,dDtIni,dDtFim,cMaq)
Local cAl := getNextAlias()
Local nHr := 0
Local cHr := '  :  '

	beginSql Alias cAl
		
		SELECT TOP 1
			C2.C2_OPHRFIM hora
		FROM
			SC2FN0 C2 (NOLOCK)
		WHERE
			C2.C2_FILIAL      = %xFilial:SC2%
			AND C2.%NotDel%
			AND C2.C2_DISA    = %Exp:cMaq%
			AND C2.C2_DATPRF  = %Exp:DtoS(dDtIni)%
			AND C2.C2_TPOP    = 'F' //Firme
		ORDER BY
			C2.C2_DATPRF,
			C2.C2_OPHRFIM DESC
	endSql
	
	If (cAl)->(!Eof())
		nHr := horaToInt((cAl)->hora)
		nHr += 1/60 // adiciona 1 minuto
		cHr := IntToHora(nHr)
	EndIf
	
	(cAl)->(dbCloseArea())
    
	If cHr <> '  :  '
		cHrIni := cHr
		valCalcula(@cHrIni,@cHrFim,@dDtIni,@dDtFim)
	EndIf
	
	If cHrIni == '  :  '
		cHrFim := '  :  '
	EndIf
	
Return
*/