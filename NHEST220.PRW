/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Modulo            ! EST - Estoque/Custos                                    !
+------------------+---------------------------------------------------------+
!Nome              ! NHEST220.PRW                                            !
+------------------+---------------------------------------------------------+
!Descricao         ! Controle de Usu�rio x Grupo de Produtos                 +
+------------------+---------------------------------------------------------+
!Autor             ! Edenilson Santos                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 04/04/2013                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
*/

User Function NHEST220()

Private cCadastro:= "Controle de Usu�rios x Grupo de Produtos"
Private aRotina  := {{"Pesquisar" ,"AxPesqui"   ,0,1} ,;
					 {"Visualizar","AxVisual"   ,0,2} ,;
					 {"Incluir"   ,"U_EST220(1)",0,3} ,;
					 {"Alterar"   ,"U_EST220(2)",0,4}}
					
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZFB"

dbSelectArea("ZFB")
dbSetOrder(1)
dbSelectArea(cString)

ZFB->(Dbgotop()) 
mBrowse( 6,1,22,75,cString)

Return

User Function EST220(nParam)

#include "rwmake.ch"
#include "topconn.ch"

SetPrvt("aHeader,aCols,_cLogin,_aLogin,_cGrupo,_aGrupo")
nPar   := nParam
CRLF   := chr(13)+chr(10)   // PULA LINHA
_cLogin:= Space(25)
_cGrupo:= Space(04)
_lGrupo:= Space(30)

aHeader:= {}
aCols  := {}

aadd(aHeader,{"Login"     , "ZFB_LOGIN" , "@!" ,25 ,0 ,".T."         ,"" ,"C" ,"ZFB"}) //03
aadd(aHeader,{"Grupo"     , "ZFB_GRUPRO", "@!" ,04 ,0 ,"U_fcGrupo()" ,"" ,"C" ,"ZFB"}) //03
aadd(aHeader,{"Descri��o" , "BM_DESC"   , "@!" ,40 ,0 ,".F."         ,"" ,"C" ,"SBM"}) //03

If nPar == 2 // alterar
	ZFB->(DbSetOrder(1)) //filial + login + grupo
	_vLogin:= ZFB->ZFB_LOGIN
	If ZFB->(DbSeek(xFilial("ZFB")+_vLogin))
		While ZFB->(!EoF()) .And. ZFB->ZFB_LOGIN == _vLogin
		  	//aadd(aCols,{ZFB->ZFB_LOGIN, ZFB->ZFB_GRUPRO, iif (SBM->( DbSeek( xFilial("ZFB")+ZFB->ZFB_GRUPRO) ), SBM->BM_DESC, ""),.F.})
		  	aadd(aCols,{ZFB->ZFB_LOGIN, ZFB->ZFB_GRUPRO, Posicione("SBM",1,xFilial("SBM")+ZFB->ZFB_GRUPRO,"BM_DESC"),.F.})		  	
			ZFB->( DbSkip() )
		Enddo
	Endif
Endif

@ 200,050 To 480,590 Dialog oDlg Title OemToAnsi("Controle de Usu�rio x Grupo de Produtos")

@ 001,001 TO 120,272 MULTILINE MODIFY DELETE OBJECT oMultiline

@ 125,100 BMPBUTTON Type 01 Action fgTabela(nPar)
@ 125,140 BMPBUTTON Type 02 Action Close(oDlg)

Activate Dialog oDlg Centered

DbselectArea('ZFB')

Return

//����������������������Ŀ
//� VALIDA O CAMPO GRUPO �
//������������������������
User Function fcGrupo()
	SBM->( DbSetOrder(1) )
	SBM->(DbSeek(xFilial("SBM")+M->ZFB_GRUPRO))
	If !SBM->(Found())
		MsgBox("Grupo n�o encontrado, Escolha um Grupo Valido !","STOP","Controle de Usu�rio x Grupo de Produtos")
	Else
		Acols[n][3] := SBM->BM_DESC
	Endif
	
	oMultiline:Refresh()

Return(.T.)

Static Function fgTabela(vOpcao)

If vOpcao == 1 // INCLUIR
	
	For _x:=1 to Len(aCols)
		
		If !Empty(Acols[_x][1]) .And. !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
			
			ZFB->(dbSetOrder(1)) //Filial + Login + Grupo
			
			If !ZFB->(dbSeek(xFilial("ZFB")+aCols[_x][1]+aCols[_x][2]))
				
				Reclock("ZFB",.T.)
				ZFB->ZFB_FILIAL  := xFilial("ZFA")
				ZFB->ZFB_LOGIN   := aCols[_x][1] //Login do Usu�rio
				ZFB->ZFB_GRUPRO  := aCols[_x][2] //Grupo de Produtos
				MsUnlock("ZFB")
				
			Endif
			
		Endif
		
	Next _x
	
elseIf vOpcao == 2 // ALTERAR
	
	For _x:=1 to Len(aCols)
		
		If !Empty(Acols[_x][1]) .And. !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
			
			ZFB->(dbSetOrder(1)) //Filial + Login + Grupo
			
			If ZFB->(dbSeek(xFilial("ZFB")+aCols[_x][1]+aCols[_x][2]))
				
				Reclock("ZFB",.F.)
				//ZFB->ZFB_FILIAL  := xFilial("ZFA")
				//ZFB->ZFB_LOGIN   := aCols[_x][1] //Login do Usu�rio
				//ZFB->ZFB_GRUPRO  := aCols[_x][2] //Grupo de Produtos
				MsUnlock("ZFB")
				
			Else
				
				Reclock("ZFB",.T.)
					ZFB->ZFB_FILIAL  := xFilial("ZFA")
					ZFB->ZFB_LOGIN   := aCols[_x][1] //Login do Usu�rio
					ZFB->ZFB_GRUPRO  := aCols[_x][2] //Grupo de Produtos
				MsUnlock("ZFB")
				
			Endif
			
		Else // exclui
		
			If ZFB->(dbSeek(xFilial("ZFB")+aCols[_x][1]+aCols[_x][2]))
				Reclock("ZFB",.F.)
					ZFB->(dbdelete())
				MsUnlock("ZFB")
			Endif
			
		Endif
		
	Next _x
	
Endif

Close(oDlg)

Return