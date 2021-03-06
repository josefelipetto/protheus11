/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHEST55  � Autor � Alexandre R. Bento     Data � 28/06/05  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � CADASTRO DE VEICULO                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Rdmake                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Expedi��o/ PCP / Controladoria / Portaria                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "protheus.ch"

User Function nhest055()
SetPrvt("CCADASTRO,AROTINA,")

If AllTrim(Upper(cUserName))$"CESARSM/PATRICIASB/EDENILSONAS/JOAOFR"
	cFuncao := 'axAltera'
Else
	cFuncao := 'U_Est55Alt()'
EndIf


//AXCADASTRO("SZN","SZN")
cCadastro := OemToAnsi("Cadastramento de Veiculos")
aRotina := {}

aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"    ,0, 1})
aAdd(aRotina,{ "Visualizar"	    ,'U_fVei(1)'   ,0, 2})

If Alltrim(Upper(cusername))$"FPORTARIA/SPORTARIA/CESARSM/PATRICIASB/JOAOFR/ADMINISTRADOR/ALEXANDRERB/MARCOSR/PORTARIA.ITESAPAR/EDENILSONAS/PAULOMS/PORTARIAPE"
	aAdd(aRotina,{ "Incluir"   	     ,'U_fVei(2)'  ,0, 3})
	aAdd(aRotina,{ "Alterar"         ,cFuncao      ,0, 4})
	aAdd(aRotina,{ "Excluir"         ,'U_fVei(3)'  ,0, 5}) 
	aAdd(aRotina,{ "Entrada Veiculo" ,'U_fVei(7)'  ,0, 5})                       
	aAdd(aRotina,{ "Saida Veiculo"   ,'U_fVei(4)'  ,0, 5})
	aAdd(aRotina,{ "OBS Veiculo"     ,'U_fVei(5)'  ,0, 6})            
	aAdd(aRotina,{ "Copia Veiculo"   ,'U_fVei(6)'  ,0, 6})                        
Endif

aAdd(aRotina,{ "Legenda"         ,"U_FLegVei"  ,0, 3})

DbSelectArea("SO5")
SO5->(DbSetOrder(1))
mBrowse( 6, 1,22,75,"SO5",,,,,,fCriaCor())

Return(nil)

User Function EST55alt()
	Alert("Usu�rio sem permiss�o!")
Return .F.

//������������������Ŀ
//� FUNCAO PRINCIPAL �
//��������������������
User Function fVei(cpar)
DEFINE FONT oFont12 NAME "Arial" SIZE 12, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10                                                                  
SetPrvt("_cDoc,_dDataE,_dDataCh,_cHoraE,_cMot,_cCpf, _cRG,_cPCam,_cPCar,oDialog,_nPar,cQuery, _aMotiv, _cMotiv,_cEmp,_cObs")  
SetPrvt("_lGerou,_cHoraCh,_cSetor,_aSetor,_cTipo,_aTipo,_cFone,_cVisit")
lPortSZM   := .F.
lPortZB8   := .F.
_nPar      := cpar
_aMotiv    := {"Coleta","Entrega","Funcionario" ,"Servico","Visita","Coleta/Entrega","GLP"}
_cMotiv    := " "
_cSetor    := " "
_aSetor    := {"Almox.Central","Almox.Componente","Almox.Bruto" ,"Expedi��o","Informatica","Engenharia","Qualidade","RH","Risa","Outros"}
_cTipo     := " "           
_aTipo     := {"Carroceria","Container","Furg�o/Bau" ,"Passeio","Pick-up","Syder"}
_cModTrans := ""
_aModTrans := {"1=Carreta","2=Truck","3=Bug","4=Outro"}
_lGerou    := .F.

If  _nPar == 2 //inclui
    DbSelectArea("SO5")
    _cDoc      := GetSXENum("SO5","O5_CODIGO")   // Variaveis do Cabecalho do Cadastro    
    DbCloseArea()

    _lGerou    := .T.
   	_dDataE    := Ctod("//") //Data de entrada na empresa
   	_cHoraE    := Space(05)  //hora de entrada na empresa   
   	_dDataCh   := date()     //Data de chegada
   	_cHoraCh   := time()     //hora de chegada
   	_cMot      := Space(30)
   	_cCpf      := Space(11)
   	_cRG       := Space(17)
   	_cPCam     := Space(08)
   	_cPCar     := Space(08)
   	_cEmp      := Space(30)
   	_cObs      := Space(100)   
   	_cFone     := Space(12)
   	_cVisit    := Space(20)
   	_nQtdeNf   := 0 
	_cModTrans := ""
Elseif _nPar == 1 .Or. _nPar == 3 .Or. _nPar == 5            

    _cDoc      := Alltrim(SO5->O5_CODIGO) // Variaveis do Cabecalho do Cadastro
    _dDataE    := SO5->O5_DTENTRA
    _cHoraE    := SO5->O5_HORAENT
    _cMot      := SO5->O5_DESCRI
    _cCpf      := SO5->O5_CPF
    _cRG       := SO5->O5_CHASSI
    _cPCam     := SO5->O5_PLACA
    _cPCar     := SO5->O5_PLACACA 
    _cMotiv    := SO5->O5_MOTIVO
    _cEmp      := SO5->O5_EMPRESA
    _cObs      := SO5->O5_OBS
    _cHoraCh   := SO5->O5_HORACHE      
    _dDataCh   := SO5->O5_EMISSAO      
    _cFone     := SO5->O5_FONE   
    _cVisit    := SO5->O5_VISITAD   
    _cSetor    := SO5->O5_DESTINO           
    _cTipo     := SO5->O5_TIPO  
    _nQtdeNf   := SO5->O5_QTDENF   
	_cModTrans := _aModTrans[Val(SO5->O5_MODTRAN)]

Elseif _nPar == 6

    DbSelectArea("SO5")
    _cDoc      := GetSXENum("SO5","O5_CODIGO")   // Variaveis do Cabecalho do Cadastro
    _lGerou    := .T.
    _dDataE    := Ctod("//")
    _cHoraE    := Space(05)  //hora de entrada na empresa
    _cHoraCh   := time()   //hora de chegada
    _dDataCh   := Date()
    _cMot      := SO5->O5_DESCRI
    _cCpf      := SO5->O5_CPF
    _cRG       := SO5->O5_CHASSI
    _cPCam     := SO5->O5_PLACA
    _cPCar     := SO5->O5_PLACACA 
    _cMotiv    := SO5->O5_MOTIVO
    _cEmp      := SO5->O5_EMPRESA
    _cObs      := SO5->O5_OBS
    _cFone     := SO5->O5_FONE  
    _cSetor    := SO5->O5_DESTINO           
    _cTipo     := SO5->O5_TIPO     
    _cVisit    := SO5->O5_VISITAD 
    _nQtdeNf   := SO5->O5_QTDENF
	_cModTrans := _aModTrans[Val(SO5->O5_MODTRAN)]
    DbCloseArea()   

Elseif _nPar == 4  //saida de veiculo        

	If Empty(SO5->O5_HORAENT)
		Alert("Efetue a entrada do ve�culo!")
		Return .F.
	EndIf
	
    If Empty(SO5->O5_HORASAI)
         //-- os numero: 062054
         
         lPortSZM := .F.
         lPortZB8 := .F.
         
         // busca as ordens de liberacao de saida amarradas com o cadastro de veiculos (tabela: SZM)
         cAl := getnextalias()
         
         beginSql ALIAS cAl
         	SELECT R_E_C_N_O_ AS ZM_RECNO
         	FROM %Table:SZM%
         	WHERE ZM_CODPLAC = %Exp:SO5->O5_CODIGO%
         	AND %NotDel%
         	AND ZM_FILIAL = %xFilial:SZM%
         	AND ZM_HORAPOR = ' '
         endSql
         
         SZN->(dbsetorder(1)) //ZN_FILIAL+ZN_DOC
         cMsgSZM := ''
		 aMsgSZM := {}
		 		 
         While (cAl)->(!eof())

			SZM->(dbgoto( (cAl)->ZM_RECNO ))

         	SZN->(dbseek(xFilial("SZN")+SZM->ZM_DOC))
         	WHILE SZN->(!EOF()) .AND. SZN->ZN_FILIAL==XFILIAL("SZN") .AND. SZM->ZM_DOC==SZN->ZN_DOC
         		
         		_n:=aScan(aMsgSZM,{|x| x==SZN->ZN_NFISCAL+'-'+SZN->ZN_SERIE })
         		If _n==0
	         		cMsgSZM += SZN->ZN_NFISCAL+'-'+SZN->ZN_SERIE+CHR(13)+CHR(10)
	         		aAdd(aMsgSZM,SZN->ZN_NFISCAL+'-'+SZN->ZN_SERIE)
	         	endif
         		
				SZN->(DBSKIP())         	
         	ENDDO
         	
         	(cAl)->(dbskip())
         Enddo
         
         If !EMPTY(cMsgSZM)
         	If MsgYesNo("Confirma Notas Fiscais de SA�DA?"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+cMsgSZM)
         		
         		(cAl)->(dbgotop())     
				While (cAl)->(!eof())
					SZM->(dbgoto( (cAl)->ZM_RECNO ))
			       	U_NHEST039(8) //-- ABRE TELA PARA ENCERRAR ORDEM DE LIBERACAO DE ENVIO
    		       	lPortSZM := .t.
		
		         	(cAl)->(dbskip())
        		Enddo
            Else
            	Return
  			Endif
         EndIf

         (cAl)->(dbclosearea())

         //-- busca as ordens de liberacao de recebimento (tabela: ZB8)
         
         cAl := getnextalias()
         
         beginSql ALIAS cAl
         	SELECT ZB8.R_E_C_N_O_ AS ZB8_RECNO
         	FROM %Table:ZB8% ZB8, %Table:SF1% SF1
         	WHERE SF1.F1_CODPLAC = %Exp:SO5->O5_CODIGO%
			AND ZB8.ZB8_FILIAL = %xFilial:ZB8%
			AND SF1.F1_FILIAL  = %xFilial:SF1%
			AND ZB8.ZB8_DOC    = SF1.F1_DOC
			AND ZB8.ZB8_SERIE  = SF1.F1_SERIE
			AND ZB8.ZB8_FORNEC = SF1.F1_FORNECE
			AND ZB8.ZB8_LOJA   = SF1.F1_LOJA
			AND ZB8.ZB8_HRPORT = ' '
			AND ZB8.ZB8_DTPORT = ' '
			AND ZB8.%NotDel%
			AND SF1.%NotDel%
         endSql
         
         cMsgZB8 := ''
         aMsgZB8 := {}
         
         While (cAl)->(!eof())
           	ZB8->(dbgoto( (cAl)->ZB8_RECNO ))

       		_n:=aScan(aMsgZB8,{|x| x==ZB8->ZB8_DOC+'-'+ZB8->ZB8_SERIE })
       		If _n==0
         		cMsgZB8 += ZB8->ZB8_DOC+'-'+ZB8->ZB8_SERIE+CHR(13)+CHR(10)
         		aAdd(aMsgZB8,ZB8->ZB8_DOC+'-'+ZB8->ZB8_SERIE)
         	endif

	        (cAl)->(dbskip())
         Enddo
         
         nRecSO5 := SO5->(Recno())
         
         If !EMPTY(cMsgZB8)
			IF MSGYESNO("Confirma Notas Fiscais de ENTRADA?"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+cMsgZB8)

         		(cAl)->(dbgotop())     
				While (cAl)->(!eof())
		           	ZB8->(dbgoto( (cAl)->ZB8_RECNO ))
		
	    	       	IF EMPTY(ZB8->ZB8_HRPORT) .AND. EMPTY(dtos(ZB8->ZB8_DTPORT))
		    	     	U_E136RECEBE(3) //-- ABRE TELA PARA ENCERRAR ORDEM DE LIBERACAO DE RECEBIMENTO
		        	 	lPortZB8 := .T.
			        Endif
			        
			        (cAl)->(dbskip())
         		Enddo
			Else
				Return	
			Endif
		Endif

		(cAl)->(dbclosearea())

        If !lPortSZM .AND. !lPortZB8
        	If !MSGYESNO("N�o foram encontradas Notas Fiscais de Entrada ou Sa�da amarradas a este cadastro de ve�culos!"+CHR(13)+CHR(10)+"Confirma saida?")
        		Return
        	Endif
        Endif
         
		SO5->(dbgoto(nRecSO5))
		
		//-- fim os: 062054
        

        Reclock("SO5",.F.)
  	        SO5->O5_DTSAIDA := Date() //Data de saida do veiculo
    	    SO5->O5_HORASAI := Time() // hora de saida do veiculo         	     
        MsUnlock("SO5")   
           
    Endif 
  
    Return
Elseif _nPar == 7  //entrada de veiculo        
   
   If Empty(SO5->O5_HORAENT)
         Reclock("SO5",.F.)
  	        SO5->O5_DTENTRA := Date() //Data de entrada de veiculo
    	    SO5->O5_HORAENT := Time() // hora de entrada de veiculo         	     
         MsUnlock("SO5")     
         Alert("Data: " +Dtoc(Date()) + "   Hora: "+ Substr(time(),1,5)+chr(13)+;
               "Entrada do Veiculo OK ") 
   Endif   
   
   Return                 
Endif   

//Define MsDialog oDialog Title OemToAnsi("Cadastro de Veiculos") From 020,030 To 274,705 Pixel 
//@ 013,007 To 110,333 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE

Define MsDialog oDialog Title OemToAnsi("Cadastro de Veiculos") From 020,030 To 274,855 Pixel 
@ 013,007 To 110,408 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE

@ 027,010 Say "Numero :" Size 030,8 Object olNum
@ 027,035 Say _cDoc Size 035,8 Object oDoc            
 oDoc:Setfont(oFont12)                      
@ 018,103 Say "Data" Size 30,8 Object olDataCh1           
@ 027,070 Say "Chegada:" Size 30,8 Object olDataCh2           
@ 025,095 Get _dDataCh Picture "99/99/9999" When .F. Size 35,8 Object oDataCh            
@ 018,130 Say "Hora " Size 40,8 Object olHoraCh           
@ 025,130 Get _cHoraCh Picture "99:99:99" When .F. Size 20,8 Object oHoraCh            

//@ 025,105 Get _dDataE Picture "99/99/9999" When .F. Size 35,8 Object oDataE            
@ 018,210 Say "Data" Size 30,8 Object olDataE1           
@ 027,177 Say "Entrada:" Size 40,8 Object olDataE2           
@ 025,202 Get _dDataE Picture "99/99/9999" When .F. Size 35,8 Object oDataE            
@ 018,243 Say "Hora " Size 40,8 Object olHoraE           
@ 025,238 Get _cHoraE Picture "99:99:99" When .F. Size 17,8 Object oHoraE

//@ 042,010 Say "Motorista :" Color CLR_HBLUE  Size 050,8            
@ 042,010 Say "Motorista :" Color CLR_HBLUE  Size 040,8 Object olMot           
@ 041,050 Get _cMot Picture "@!"  When(_nPar == 2 .or. _nPar == 6 ) Size 115,8 Valid !Empty(_cMot) Object oMot             

@ 042,187 Say "CPF:" Color CLR_HBLUE  Size 015,8 Object olCpf
@ 041,202 Get _cCpf Picture "@R 999.999.999-99" When(_nPar == 2 .or. _nPar == 6 ) Size 070,8 Valid !Empty(_cCpf) .and. ChkCpf(_cCpf) .and. U_fcRESTRI(_cCpf) Object oCpf             

@ 042,282 Say "RG :" Color CLR_HBLUE  Size 015,8 Object olRG
@ 041,295 Get _cRG Picture "@!"                When(_nPar == 2 .or. _nPar == 6 ) Size 050,8 Valid !Empty(_cRG) Object oRG             

@ 042,345 Say "Fon:" Size 010,08 Object olfone
@ 041,360 Get _cFone Picture "@!" When(_nPar == 2 .or. _nPar == 6 ) Size 045,8 Object ofone             

@ 057,010 Say OemToAnsi("Placa Caminh�o:") Color CLR_HBLUE  Size 050,8 Object olPCam
@ 055,050 Get _cPCam Picture "!!!-!!!!" When(_nPar == 2 .or. _nPar == 6 ) Size 035,8 Valid fPlaca(_cPCam) Object oPCam             

@ 057,090 Say OemToAnsi("Placa Carreta :") Size 050,8 Object olPCar
@ 055,130 Get _cPCar Picture "!!!-!!!!" When(_nPar == 2 .or. _nPar == 6 ) Size 035,8 Object oPCar

@ 057,166 Say "Mod. Transp.:" Color CLR_HBLUE Size 050,8 object olModT
If (_nPar == 5) .Or. (_nPar == 1)
	@ 057,202 Say StrTran(_cModTrans,Left(_cModTrans,2),"") Color CLR_BLUE SIZE 70,10 object oModT
Else
	@ 055,202 COMBOBOX _cModTrans ITEMS _aModTrans SIZE 70,10 OBJECT oModTrans
EndIf

@ 057,280 Say OemToAnsi("Tipo :") Size 020,8 object olTipo
//@ 053,205 Get _cPCar Picture "!!!-!!!!" When(_nPar == 2 .or. _nPar == 6 ) Size 045,8 Object oPCar                                 
If (_nPar == 5) .Or. (_nPar == 1)
   @ 057,295 Say _cTipo Color CLR_BLUE SIZE 110,10 object oTipo //When .F.
Else   
   @ 055,295 COMBOBOX _cTipo ITEMS _aTipo SIZE 110,10 object oatipo //When .F.
Endif   

@ 070,010 Say "Empresa :" Color CLR_HBLUE  Size 050,8 Object olEmp           
@ 068,050 Get _cEmp Picture "@!" When(_nPar == 2 .or. _nPar == 6 ) Size 115,8 Valid !Empty(_cEmp) Object oEmp             

@ 070,180 Say "Motivo :" Size 040,8 object olMotiv                    
If (_nPar == 5) .Or. (_nPar == 1)
   @ 070,202 Say _cMotiv Color CLR_BLUE SIZE 70,10 object oMotiv //When .F.
//    oMotiv:Setfont(oFont10)                      
Else   
   @ 068,202 COMBOBOX _cMotiv ITEMS _aMotiv SIZE 70,10 object oMotiv //When .F.
Endif   

@ 070,273 Say "Destino:" Size 040,8 object olSetor                   
If (_nPar == 5) .Or. (_nPar == 1)
   @ 070,295 Say _cSetor Color CLR_BLUE SIZE 110,10 object oSetor //When .F.
Else   
   @ 068,295 COMBOBOX _cSetor ITEMS _aSetor SIZE 110,10 object oaSetor //When .F.
Endif   

@ 083,010 Say "Visitado :" Size 40,8 object olVisit         
@ 081,050 Get _cVisit Picture "@!"  When(_nPar == 2 .Or. _nPar == 5 .or. _nPar == 6 ) size 115,10 object oVisit   

@ 083,174 Say "Quant. NF:" Size 40,8 object olQtdeNf        
@ 081,202 Get _nQtdeNf Picture "@e 999"  When(_nPar == 2 .Or. _nPar == 5 .or. _nPar == 6 ) size 70,10 object oQtdeNf

@ 096,010 Say "Obs :" Size 20,8 object olOBS        
@ 094,050 Get _cObs Picture "@!S100"  When(_nPar == 2 .Or. _nPar == 5 .or. _nPar == 6 ) size 355,10 object oOBS   

@ 113,380 BMPBUTTON TYPE 02 ACTION fEnd() //FCancela()
@ 113,350 BMPBUTTON TYPE 01 ACTION fGrVei()
Activate MsDialog oDialog Center valid fDialog()

Return           

//��������������������Ŀ
//� CANCELA O CADASTRO �
//����������������������
Static Function fEnd() 
   If _lGerou
   //   Alert(" Volta o numero ")
      RollBackSx8() //Volta a numera��o da Ordem de Libera��o
   Endif   
   Close(oDialog) 

Return

//�������������������������������ڿ
//� VALIDA O CADASTRO DE VEICULO �
//���������������������������������
Static Function fDialog()
Local _lRet := .T.

	If Empty(_cMot) .Or. Empty(_cPcam) .Or. Empty(_cCpf) .Or. Empty(_cRG) .Or. Empty(_cEmp) .Or. Empty(_cModTrans)
	   Alert("Campos obrigat�rios em branco!")
	   _lRet := .F.
	Endif
	
	If _cTipo=="Container" .AND. Empty(_cObs)
		Alert("Informe o n� do Container na observa��o!")
		Return .F.
	EndIf

	If _nPar ==  3                      
	   _lRet := .T.
	Endif

Return(_lRet)

//�����������������Ŀ
//� GRAVA O VEICULO �
//�������������������
Static Function fGrVei()

If _nPar == 2 .Or. _nPar == 6 
   SO5->(DbSetOrder(1))
   If !SO5->(Dbseek(xFilial("SO5")+_cDoc))
	  // Begin Transaction  
	      If !fDialog()
	      		Return
	      EndIf
	      
	      Reclock("SO5",.T.)
	         SO5->O5_FILIAL  := xFilial("SO5")
		     SO5->O5_CODIGO  := _cDoc
		     SO5->O5_DESCRI  := _cMot      // Motorista
		     SO5->O5_HORAENT := space(05)  //hora de entrada
		     SO5->O5_DTENTRA := Ctod("//") // data de entrada
	  	     SO5->O5_PLACACA := _cPCar     //placa da carreta
		     SO5->O5_PLACA   := _cPCam     //placa do camihao ou carro
		     SO5->O5_CPF     := _cCpf      // CPF do Motorista
		     SO5->O5_CHASSI  := _cRG       // RG do motorista
		     SO5->O5_HORACHE := Time()     //hora de chegada             		     
		     SO5->O5_EMISSAO := Date()     //Data de chegada
	  	     SO5->O5_EMPRESA := _cEmp      // empresa / transportadora
		     SO5->O5_MOTIVO  := _cMotiv    // motivo da entrada do veiculo         	     
		     SO5->O5_OBS     := _cObs      // Observa�ao da entrada do veiculo         	     	     
             SO5->O5_FONE    := _cFone
		     SO5->O5_VISITAD := _cVisit 
		     SO5->O5_DESTINO := _cSetor    // destino da entrada do veiculo         	     		     
		     SO5->O5_TIPO    := _cTipo     // tipo da entrada do veiculo         	     		     
		     SO5->O5_QTDENF  := _nQtdeNf   // quantidade de notas
		  	 SO5->O5_MODTRAN := Substr(_cModTrans,1,1) // modalidade do transporte
	      MsUnlock("SO5")
	      
	      If SM0->M0_CODIGO=="NH"
		      //chamado 004176 - FlaviaK
		      If AllTrim(SO5->O5_MOTIVO)=="GLP" 
		      	  fOpenDOC("FM08000035")
		      	  Alert("Favor imprimir o formul�rio!")
		      EndIf
	
		      //chamado 004177 - FlaviaK
		      If Val(_cDoc)%10==0
		          fOpenDOC("FM08000034")
		          Alert("Favor imprimir o formul�rio!")
		      EndIf
		  EndIf	      	
		      
	   ConfirmSX8()
	Else
        Msgbox("Este numero de documento ja existe Cadastrado,"  +chr(13)+;
             "Favor avisar a Informatica, pois nao sera gravado este documento.","Atencao","STOP" )  
	Endif
Elseif _nPar ==  3          

	If Empty(SO5->O5_HORASAI)//permite excluir somente se o veiculo n�o saiu da empresa.
       	Reclock("SO5",.F.)
        	SO5->(DbDelete())
    	MsUnlock("SO5")     
	Endif  

Elseif _nPar ==  5      

	Reclock("SO5",.F.)
		SO5->O5_OBS := _cObs   // Observa�ao da entrada do veiculo         	     	     
	MsUnlock("SO5")     

Endif

Close(oDialog)     
_lGerou  := .F.
SO5->(DbgoBottom())

Return

//�������������������������������Ŀ
//� ABRE O FORMULARIO FM08.000035 �
//���������������������������������
Static Function fOpenDoc(cDoq)
Local cMvSave   := "CELEWIN400"  
Local lView     := GetMv( "MV_QDVIEW" ) 
Local cPView    := Alltrim( GetMv( "MV_QDPVIEW" ) )
Local lAchou    := .F.
Local aQPath    := QDOPATH()
Local cQPath    := aQPath[1]
Local cQPathTrm := aQPath[3]
Local cTexto

QDH->(DbSetOrder(1)) // Ultima revisao
QDH->(DbSeek(xFilial("QDH")+cDoq)) //  + ZA7->ZA7_FERRV))	        
While AllTrim(QDH->QDH_DOCTO) == cDoq
	lAchou := .T.
	QDH->(DbSkip())
Enddo

If lAchou

	QDH->(DbSkip(-1))	
	
    cTexto := Alltrim(QDH->QDH_NOMDOC)
	
	If !File(cQPathTrm+cTexto)
		CpyS2T(cQPath+cTexto,cQPathTrm,.T.)
	EndIf
	
	If UPPER(Right(Alltrim(cTexto),4))$".CEL"

		fRename(cQPathTrm+cTexto,cQPathTrm+StrTran(UPPER(cTexto),".CEL",".DOC"))

		cTexto := StrTran(UPPER(cTexto),".CEL",".DOC")
		
		oWordTmp := OLE_CreateLink("TMsOleWord97")
		OLE_SetProperty( oWordTmp, oleWdVisible,   .T. )
		OLE_SetProperty( oWordTmp, oleWdPrintBack, .F. )
		OLE_OpenFile( oWordTmp, ( cQPathTrm + Alltrim(cTexto) ),.F., cMvSave, cMvSave )

		Aviso("", "Alterne para o programa do Ms-Word para visualizar o documento ou clique no botao para fechar.", {"Fechar"})

		OLE_CloseLink( oWordTmp )
	ELSE			
		QA_OPENARQ(cQPathTrm+cTexto)
	ENDIF

Else
	MsgBox("Documento nao encontrado!","Cadastro de documento","STOP")
Endif

Return

//���������������Ŀ
//� VALIDA A PLACA�
//�����������������
Static Function fPlaca(_cPl)
Local _nNum   := 1
Local _lFlag  := .T. 
Local _lRet   := .T. 
Local _cPlaca := _cPl

If !Empty(_cPCam) .And. Empty(_cPCar) 
   SO5->(DbSetOrder(4))
   SO5->(Dbseek(xFilial("SO5")+_cPlaca))
      While !SO5->(EOF()) .And. _cPlaca == SO5->O5_PLACA
        
         If Empty(SO5->O5_HORASAI)
            _cMot    := SO5->O5_DESCRI
            _cCpf    := SO5->O5_CPF
            _cRG     := SO5->O5_CHASSI
            _cPCam   := SO5->O5_PLACA
            _cPCar   := SO5->O5_PLACACA  
            _cHoraE  := SO5->O5_HORAENT // Hora de Entrada do veiculo na empresa
            _dDataE  := SO5->O5_DTENTRA // Data de Entrada do veiculo na empresa            
            _dDataCh := SO5->O5_EMISSAO // Data de chegada do veiculo na empresa            
            _cHoraCh := SO5->O5_HORACHE // Hora de chegada do veiculo na empresa            
            ObjectMethod(oHoraE,  "Refresh()")
            ObjectMethod(oDataE,  "Refresh()")
            ObjectMethod(oHoraCh, "Refresh()")
            ObjectMethod(oDataCh, "Refresh()")
            ObjectMethod(oMot,    "Refresh()")
            ObjectMethod(oRG,     "Refresh()")         
            ObjectMethod(oPCam,   "Refresh()")         
            ObjectMethod(oPCar,   "Refresh()")               
            oPCam:SetFocus(oPCam)  
            Msgbox("O Caminhao ja esta no PATIO CONFIRA A PLACA ou verique placa nao BAIXADA !!!","ALERT" )  
            _lRet  := .F. 
            exit //se achou for�a a saida do loop
         Endif   
         SO5->(Dbskip())
      Enddo   
Endif

If !Empty(_cPlaca)
   If Len(Alltrim(_cPlaca)) <> 8
      Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
             "A Placa so Pode conter LETRAS E NUMEROS.","Atencao","ALERT" )  
      _cPcam := Space(08)                
      _lRet  := .F. 
     
   Endif

   For _nNum:= 1 to 3
      
      _lFlag := Entre("A","Z",Subs(_cPlaca,_nNum,1))   
      If !_lFlag
         Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
             "A Placa so Pode conter LETRAS E NUMEROS.","Atencao Letras","ALERT" )  
         _cPcam := Space(08)   
         _lRet  := .F.              
      Endif      
   Next

   For _nNum:=5 to 8
      
      _lFlag := Entre("0","9",Subs(_cPlaca,_nNum,1))   
      If !_lFlag
         Msgbox("Placa Digitada Errada, Verifique !!!" +chr(13)+;
             "A Placa so Pode conter LETRAS E NUMEROS.","Atencao Numeros","ALERT" )  
         _cPcam := Space(08)                
         _lRet  := .F.              
      Endif      
   Next 
Endif               
SO5->(DbSetOrder(1))
If Empty(_cPlaca)
   _lRet  := .F.              
Endif

ObjectMethod(oPCam, "Refresh()")         

Return(_lRet)

//���������Ŀ
//� LEGENDA �
//�����������
User Function FLegVei()       

Local aLegenda :=	{ {"BR_AMARELO" , "Cadastrado"},;
					  {"BR_VERMELHO", "Fechado"   },;
  					  {"BR_VERDE"   , "Aberto"    }}

BrwLegenda("Cadastro de Veiculos", "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_AMARELO" , "Cadastrado"},;
					  {"BR_VERMELHO", "Fechado"   },;
  					  {"BR_VERDE"   , "Aberto"    }}

Local uRetorno := {}
Aadd(uRetorno, {'O5_HORAENT = " " .AND. O5_HORASAI = " "' , aLegenda[1][1] } )
Aadd(uRetorno, {'O5_HORAENT <> " " .AND. O5_HORASAI <> " "' , aLegenda[2][1] } )
Aadd(uRetorno, {'O5_HORAENT <> " " .AND. O5_HORASAI = " "' , aLegenda[3][1] } )

Return(uRetorno)

User Function fcRESTRI(_cDoc)
Local _lRet:= .T. 
ZFC->(DbSetOrder(1))
If ZFC->(DbSeek(xFilial("ZFC")+_cDoc))
	Alert('RESTRI��O, PROCURAR SEGURAN�A PATRIMONIAL! ')
	_lRet:= .F.	
EndIf
Return(_lRet)