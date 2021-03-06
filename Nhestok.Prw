/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHESTOK  � Autor � Jose Roberto          � Data � 24/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao das linhas do cadastro de EPI's                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Execblock usado do programa NHEST023                       ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SC1                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


#include "rwmake.ch"        

User Function nhESTok()      

SetPrvt("RETORNO,_LRET,J,I,")
nProd    := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="Z7_PRODUTO"})
nLocaliz := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="Z7_LOCALIZ"})
nLocal   := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="Z7_LOCAL"})

Retorno  := .t.
_lRet    := .f.
nQtDigit := 0

If Len(aCols) == 1 .and. ( aCols[N][nusado+1] )
   MsgAlert("Unica Linha Excluida")
   Retorno := .f.
else

	SB1->(dbsetorder(1))
	SB1->(dbSeek(xFilial('SB1')+ACOLS[n][nProd]))
	If SB1->B1_RASTRO$'L'
		Alert('Produto controla lote! Esta rotina n�o est� preparada para atender produtos que controlam lote!')
		Return .F.
	Endif
	
	If SB1->B1_LOCALIZ=='S' .AND. EMPTY(Acols[n][nLocaliz])//-- controla localizacao
		Alert('Produto controla Localizacao! Informe a Localizacao!')
		Return .f.
	Endif

   j := 0
   For i:=1 to Len(aCols)
      If !( aCols[i][nusado+1] )
        _lRet := .t.
        j := j + 1
      EndIf
   Next

   If ( aCols[N][nusado+1] ) .OR. (( !Empty(aCols[N][1]))  .and. (!Empty(aCols[N][2]))  .And. (aCols[N][4] > 0 ))

         IF SB2->(DbSeek(xFilial("SB2")+aCols[N][2]+aCols[N][nLocal]))//SB1->B1_LOCPAD))
	         
	         If !aCols[n][len(aHeader)+1]
	         	nQtDigit := aCols[N][4]
	         EndIf
	         
	         //Faz a somatoria das quantidades dos itens iguais no acols
	         For x:=1 to Len(aCols)
	         	If x!=n
	         		If aCols[n][nProd]==aCols[x][nProd] .and. aCols[n][nLocal]==aCols[x][nLocal] .and. !aCols[x][len(aHeader)+1]
	         			nQtDigit += aCols[n][4]
	         	    EndIf
	         	EndIf
	         Next
	         
	         If SB2->B2_QATU < nQtDigit .AND. aCols[N][nusado+1] == .F.
    	        MsgInfo("Produto sem saldo em Estoque "+SB2->B2_COD+" Saldo : " +Transform(SB2->B2_QATU,"@E 999,999,999.99") +"  - Verifique !!!")  
        	    Return(.F.)
	         Endif
   
         Else 
            If (( !aCols[N][nusado+1] ) .AND. !SB2->(Found()))
               MsgInfo("Produto sem saldo em Estoque "+aCols[N][2]+" - Verifique !!!")  
               Return(.F.)
            Endif   
         Endif
        
   
     //  se deletado                                             
      Retorno := .t.
//      MsgAlert("se deletado")
   ElseIf !( aCols[N][nusado+1] ) .and. _lRet
      Retorno := .t.     //lret
  //    MsgAlert("lret")
   ElseIf ( aCols[N][nusado+1] ) .and. j < Len(aCols)
      Retorno := .t.   // usado
    //  MsgAlert(" Usado ")
   Else
      MsgAlert("Existem campos obrigatorios sem preenchimento (2)")
      Retorno := .f.
   EndIf
                  
   aCols[N][4] := 1 //Quantidade fixa 1
   aCols[N][1] := StrZero(N,2) //Corrige item quando digitado errado
   
   If (Empty( aCols[N][2]) .OR. aCols[N][4] < 1 ) .AND.  aCols[N][nusado+1] == .F.
         MsgAlert("Existem campos obrigatorios sem preenchimento ")
      	 Retorno := .f.
   Endif

   If Len(aCols) == 0
         MsgAlert("Existem campos obrigatorios sem preenchimento ")
      	 Retorno := .f.
   Endif
   
   If aCols[N][4] > 1  .AND.  aCols[N][nusado+1] == .F.
         MsgAlert("Atencao Quantidade de EPI Nao pode ser Maior que 1 ")
      	 Retorno := .f.
   Endif  
   
   // Adicionado por Douglas Dourado - 23/10/2012
   // Verifica se produto est� bloqueado para invent�rio
   If !U_E205BLQ(aCols[n][nProd],Acols[n][nLocal])				
      Retorno := .F. 	
   EndIF
   
Endif                                                                                                

Return(Retorno)   // Direto estava dando erro. Patetico    
