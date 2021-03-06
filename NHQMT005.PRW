#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHQMT005   �Autor �Jo�o Felipe         � Data �  08/01/08  ���
�������������������������������������������������������������������������͹��
���Desc.     � RELATORIO DE INSTRUMENTOS CALIBRADOS                       ���
�������������������������������������������������������������������������͹��
���Uso       � METROLOGIA                                                 ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHQMT005()   

cString   := "QM6"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi("a rela��o de instrumentos calibrados dia-a-dia.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHQMT005"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATORIO DE INSTRUMENTOS CALIBRADOS") 
cabec1    := " Instrumento     Rev.          Respons�vel         Nome                         Data        N�. Certif"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHQMT005"
_cPerg    := "QMT005" 

//VARIAVEIS AUXILIARES
aMat    := {}
_nTotal := 0
_cCod   := ""
_cMatr  := ""
_nTMatr := 0
lPrim   := .T.

// mv_par01 de instrumento
// mv_par02 at� instrumento
// mv_par03 de respons�vel
// mv_par04 at� repons�vel
// mv_par05 de data
// mv_par06 at� data   
// mv_par07 de depto
// mv_par08 ate depto       
// mv_par09 exp. p/ excel ? (s/n)

Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 

If mv_par09==1 //excel sim
	Processa( {|| QMT005XLS() },"Importando...")
ElseIf mv_par09==2 //excel nao
	RptStatus({|| RptDetail()   },"Imprimindo...") 

	set filter to 
	//set device to screen
	If aReturn[5] == 1
		Set Printer To
		Commit
	    ourspool(wnrel) //Chamada do Spool de Impressao
	Endif                                          
	MS_FLUSH() //Libera fila de relatorios em spool
EndIf

Return

Static Function Gerando()

//-----------------------------------------------------------------------
// MONTA A QUERY   
//-----------------------------------------------------------------------  

BeginSql Alias "TMP"
	SELECT 
		QM6.QM6_INSTR  ,
		QM6.QM6_REVINS ,
		QM6.QM6_RESP   ,
		QAA.QAA_NOME   , 
		QM6.QM6_DATA   ,
		(
			SELECT TOP 1 
				QM7.QM7_NRCERT
			FROM 
				%Table:QM7% QM7 (NOLOCK)
			WHERE
				QM2.QM2_INSTR = QM7.QM7_INSTR
				AND QM2.QM2_REVINS = QM7.QM7_REVINS
				AND QM7.%NOTDEL%
				AND QM7.QM7_FILIAL = %xFilial:QM7%
			ORDER BY 
				QM7.QM7_DATA DESC
		) CERTIF
			
	FROM 
		%Table:QM6% QM6 (NOLOCK) , 
		%Table:QAA% QAA (NOLOCK) , 
		%Table:QM2% QM2 (NOLOCK) 
	WHERE 
		    QM6.QM6_INSTR BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND QM6.QM6_RESP  BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND QM2.QM2_DEPTO BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
		AND QM6.QM6_DATA  BETWEEN %Exp:DtoS(mv_par05)% AND %Exp:DtoS(mv_par06)%
		AND QM2.QM2_INSTR  = QM6.QM6_INSTR
		AND QM2.QM2_REVINS = QM6.QM6_REVINS
		AND QM6.QM6_RESP   = QAA.QAA_MAT
		AND QM6.%NotDel%
		AND QAA.%NotDel%
		AND QM2.%NotDel%                 
		AND QM2.QM2_FILIAL = %xFilial:QM2%
		AND QAA.QAA_FILIAL = %xFilial:QAA%
		AND QM6.QM6_FILIAL = %xFilial:QM6%
		
	ORDER BY 
		QM6_INSTR, 
		QM6_REVINS 
	DESC
EndSql

/*			

cQuery := " SELECT QM6.QM6_INSTR,QM6.QM6_REVINS,QM6.QM6_RESP,QAA.QAA_NOME , QM6.QM6_DATA "
cQuery += " FROM "+RetSqlName('QM6')+" QM6, "+RetSqlName("QAA")+" QAA, "+RetSqlName("QM2")+" QM2 "
cQuery += " WHERE QM6.QM6_INSTR BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND QM6.QM6_RESP BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQuery += " AND QM6.QM6_DATA BETWEEN '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"'"
cQuery += " AND QM2.QM2_INSTR = QM6.QM6_INSTR "
cQuery += " AND QM2.QM2_DEPTO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cQuery += " AND QM6.QM6_RESP = QAA.QAA_MAT"
cQuery += " AND QM6.D_E_L_E_T_ = ' '"
cQuery += " AND QAA.D_E_L_E_T_ = ' '"
cQuery += " AND QAA.QAA_FILIAL = '"+xFilial('QAA')+"'"
cQuery += " AND QM6.QM6_FILIAL = '"+xFilial('QM6')+"'"
cQuery += " ORDER BY QM6_INSTR, QM6_REVINS DESC"

//QM7_FILIAL+QM7_INSTR+QM7_REVINS+DtoS(QM7_DATA)+QM7_CSEQ+QM7_ESCALA+QM7_REVESC+QM7_PONTO+QM7_REVPAD

//MemoWrit('C:\TEMP\QMT005.SQL',cQuery)
TCQUERY cQuery NEW ALIAS 'TMP'

*/

TcSetField("TMP","QM6_DATA","D")  // TRANSFORMA DE STRING PARA DATA

TMP->(DbGotop())
   
While TMP->(!Eof())

	//------------------------------------------------------
	// Pula os Instrumentos que nao tiverem ultima revisao
	//------------------------------------------------------
	If _cCod == TMP->QM6_INSTR
		TMP->(DbSkip())
		Loop
	EndIf
           
	_cCod := TMP->QM6_INSTR
	
	aAdd(aMat,{TMP->QM6_INSTR,TMP->QM6_REVINS,TMP->QM6_RESP,Substr(TMP->QAA_NOME,1,20),DtoC(TMP->QM6_DATA),TMP->CERTIF})
	 
	TMP->(DbSkip())

EndDo

aSort(aMat,,,{|x,y| x[3] < y[3]}) //ordena por responsavel

TMP->(DbCloseArea())

Return

//�����������Ŀ
//� IMPRESSAO �
//�������������
Static Function RptDetail()

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)

For x:=1 to Len(aMat)

	If Prow() > 70
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
	
	If lPrim 
		_cMatr := aMat[x][3]
		lPrim  := .F.
	EndIf
	
	If _cMatr != aMat[x][3]
		@ Prow()+1,001 Psay OemToAnsi("Total:--->")+Space(40)+ Str(_nTMatr)
		@ Prow()+1,000 PSAY __PrtThinLine()
		_nTMatr := 0
		_cMatr := aMat[x][3]
	EndIf

	@Prow()+1, 001 psay aMat[x][1]
	@Prow()  , 018 psay aMat[x][2]
	@Prow()  , 034 psay aMat[x][3]
	@Prow()  , 051 psay aMat[x][4]
	@Prow()  , 078 psay aMat[x][5]
	@Prow()  , 094 psay aMat[x][6]
	
	_nTMatr++
	_nTotal++
	
Next

@ Prow()+1,000 PSAY __PrtThinLine()
@ Prow()+1,001 Psay OemToAnsi("TOTAL DE CALIBRA��ES--->")+Space(30)+ Str(_nTotal)

Return(nil)

//����������������������Ŀ
//� EXPORTA PARA O EXCEL �
//������������������������
Static Function QMT005XLS()
Local cExcel, _nOutFile 
Local _cLocal  := Space(100)
Local _lRet    := .F.
Local _cLinha  := "ABOBRINHA"
Local _nTotLin := 0
Local _cCod    := ""

	//��������������������������������������������������������Ŀ
	//� TELA PARA SOLICITACAO DO CAMINHO A SER SALVO O ARQUIVO �
	//����������������������������������������������������������
	oDlg2 := MSDialog():New(0,0,120,310,"Local do Arquivo",,,,,,,,,.T.)
    
	//contorno
	oGroup := tGroup():New(005,005,40,153,,oDlg2,,,.T.)
		
	oSay4 := TSay():New(20,10,{||"Local"},oDlg2,,,,,,.T.,,)
	
	oGet1 := tGet():New(18,30,{|u| if(Pcount() > 0, _cLocal:= u,_cLocal)},oDlg2,118,8,"@!",/*valid*/,;
		,,,,,.T.,,,/* when */,,,,,,,"_cLocal")
    
	//botoes
    oBt1 := tButton():New(45,88,"Ok",oDlg2,{||oDlg2:End()},30,10,,,,.T.)      
    oBt2 := tButton():New(45,123,"Cancelar",oDlg2,{||_lRet:=.T.,oDlg2:End()},30,10,,,,.T.)

	oDlg2:Activate(,,,.T.,{||,.T.},,{||})
	    
	If _lRet 
		Return
	EndIf	
	
	_cLocal := Alltrim(_cLocal)
	If !Right(_cLocal,1)$"\"
		_cLocal += "\"
	EndIf

	_nOutFile := Fcreate(_cLocal+"InsCalib.xls",0)
	
	If !File(_cLocal+"InsCalib.xls")
		Alert("Arquivo n�o pode ser criado. Escolha outro local!")
		Return
	EndIf

	cExcel := '<html>'
	cExcel += '<head></head>'
	cExcel += '<body>'
	cExcel += '<table border="1">'

	cExcel += '<tr style="background:#666666; color:#ffffff">'
	cExcel += '<td>Instrumento</td>'
	cExcel += '<td>Rev.</td>'
	cExcel += '<td>Respons�vel</td>'
	cExcel += '<td>Nome</td>'
	cExcel += '<td>Data</td>'
	cExcel += '<td>N� Certif.</td>'
	cExcel += '</tr>'
		
	ProcRegua(QM2->(RecCount()))

	For x:=1 to Len(aMat)
	
		If lPrim 
			_cMatr := aMat[x][3]
			lPrim  := .F.
		EndIf
		
		If _cMatr != aMat[x][3]
			cExcel += '<tr>'
			cExcel += '<td colspan="6" style="background:#efefef">'
			cExcel += 'Total: '+ AllTrim(Str(_nTMatr))
			cExcel += '<td>'
			cExcel += '</tr>'
			_nTMatr := 0
			_cMatr := aMat[x][3]
		EndIf  
		
		cExcel += '<tr>'
		cExcel += '<td>'+aMat[x][1]+'</td>'
		cExcel += '<td>'+aMat[x][2]+'</td>'
		cExcel += '<td>'+aMat[x][3]+'</td>'
		cExcel += '<td>'+aMat[x][4]+'</td>'
		cExcel += '<td>'+aMat[x][5]+'</td>'
		cExcel += '<td>'+aMat[x][6]+'</td>'
		cExcel += '</tr>'
	
		_nTMatr++
		_nTotal++
		
	Next
	
	cExcel += '<tr>
	cExcel += '<td colspan="5" style="background:#efefef">'
	cExcel += 'Total de Calibra��es: '+ AllTrim(Str(_nTotal))
	cExcel += '<td>'
	cExcel += '</tr>
	
	cExcel += '</table>'
	
	Fwrite(_nOutFile,cExcel)

	Fclose(_nOutFile)
   
	//Abre a p�gina da ficha t�cnica
	ShellExecute( "open", "excel.exe",_cLocal+"InsCalib.xls","",5 )

Return