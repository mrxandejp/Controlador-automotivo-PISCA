;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		;NOVAS VARIÁVEIS
		CONT		;CONTADOR PARA O TMR0
		PISCA_ALERTA    ;FLAG PARA INDICAR SE O PISCA ALERTA ESTÁ ACIONADO
		FAROL_ESQUERDO	;FLAG PARA INDICAR SE O FAROL ESQUERDO ESTÁ ACIONADO
		FAROL_DIREITO	;FLAG PARA INDICAR SE O FAROL DIREITO ESTÁ ACIONADO
		

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES
	BTFSS	GPIO, GP0
	GOTO	PROXIMO1
	BSF	PISCA_ALERTA,0
	BCF	FAROL_ESQUERDO,0
	BCF	FAROL_DIREITO,0
	GOTO	SAI_INT
PROXIMO1
	BTFSS	GPIO, GP1
	GOTO	PROXIMO2
	BSF	FAROL_ESQUERDO,0
	BCF	PISCA_ALERTA,0
	BCF	FAROL_DIREITO,0
	GOTO	SAI_INT
PROXIMO2
	BTFSS	GPIO, GP2
	GOTO	PROXIMO3
	BSF	FAROL_DIREITO,0
	BCF	PISCA_ALERTA,0
	BCF	FAROL_ESQUERDO,0
	GOTO	SAI_INT
PROXIMO3
	BCF	FAROL_DIREITO,0
	BCF	PISCA_ALERTA,0
	BCF	FAROL_ESQUERDO,0
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	BCF	INTCON,GPIF
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000111'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'10000111'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'10001000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	MOVLW	B'00000111'	;DEFINE AS INTERRUPÇÕES DAS ENTRADAS 
	MOVWF	IOC		;GP0 GP1 E GP2
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL.
	BTFSC	PISCA_ALERTA,0	;CONFERE SE A FLAG DO ALERTA ESTÁ LIGADO
	GOTO	ALERTA		;SE ESTIVER VAI PARA O ALERTA SE NÃO
	BTFSC	FAROL_ESQUERDO,0;CONFERE SE A FLAG DO FAROL ESQUERDO TÁ LIGADO
	GOTO	ESQUERDO	;SE ESTIVER VAI PARA O ESQUERDO SE NÃO
	BTFSC	FAROL_DIREITO,0	;CONFERE SE A FLAG DO FAROL DIREITO TÁ LIGADO
	GOTO	DIREITO		;SE ESTIVER VAI PARA O DIREITO SE NÃO
	GOTO	MAIN		;CONFERE TUDO NOVAMENTE
ALERTA	
	;ETAPA_1
	BSF	GPIO,GP4	;LIGA LED-E
	BSF	GPIO,GP5	;LIGA LED-D
	MOVLW	.10		;CONTADOR PARA FAZER UM TEMPO DE 500ms
	MOVWF	CONT
LOOP_1	
	MOVLW	.61		;TEMPO PARA O TMR0 INICIAR, PARA FAZER 50ms
	MOVWF	TMR0		
	BCF	INTCON, T0IF	;LIMPA A FLAG DO ESTOURO DO TMR0
TESTE_1	
	BTFSS	INTCON, T0IF	;CONFIRO SE O TMR0 ESTOUROU
	GOTO	TESTE_1		;SE NÃO ESTOUROU FICA CONFERINDO ATÉ ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_1		;SE NÃO FOR ZERO VOLTA PARA O LOOP_1 PARA CONTAR O TEMPO DENOVO
	;ETAPA_2
	BCF	GPIO,GP4	;APAGA O LED-E
	BCF	GPIO,GP5	;APAGA O LED-D
	MOVLW	.10		;E REPETE O MESMO PROCESSO DA PRIMEIRA ETAPA
	MOVWF	CONT		;PARA QUE O LED FIQUE APAGADO POR 500ms
LOOP_2	
	MOVLW	.61		;TEMPO PARA O TMR0 INICIAR, PARA FAZER 50ms
	MOVWF	TMR0
	BCF	INTCON, T0IF	;LIMPA A FLAG DO ESTOURO DO TMR0
TESTE_2	
	BTFSS	INTCON, T0IF	;CONFIRO SE O TMR0 ESTOUROU
	GOTO	TESTE_2		;SE NÃO ESTOUROU FICA CONFERINDO ATÉ ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_2		;SE NÃO FOR ZERO VOLTA PARA O LOOP_2 PARA CONTAR O TEMPO DENOVO
	GOTO	MAIN
ESQUERDO
	;ETAPA_E1
	BSF	GPIO,GP4	;LIGA LED-E
	MOVLW	.10		;CONTADOR PARA FAZER UM TEMPO DE 500ms
	MOVWF	CONT
LOOP_E1	
	MOVLW	.61		;TEMPO PARA O TMR0 INICIAR, PARA FAZER 50ms
	MOVWF	TMR0		
	BCF	INTCON, T0IF	;LIMPA A FLAG DO ESTOURO DO TMR0
TESTE_E1	
	BTFSS	INTCON, T0IF	;CONFIRO SE O TMR0 ESTOUROU
	GOTO	TESTE_E1	;SE NÃO ESTOUROU FICA CONFERINDO ATÉ ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_E1		;SE NÃO FOR ZERO VOLTA PARA O LOOP_1 PARA CONTAR O TEMPO DENOVO
	;ETAPA_E2
	BCF	GPIO,GP4	;APAGA O LED-E
	MOVLW	.10		;E REPETE O MESMO PROCESSO DA PRIMEIRA ETAPA
	MOVWF	CONT		;PARA QUE O LED FIQUE APAGADO POR 500ms
LOOP_E2	
	MOVLW	.61		;TEMPO PARA O TMR0 INICIAR, PARA FAZER 50ms
	MOVWF	TMR0
	BCF	INTCON, T0IF	;LIMPA A FLAG DO ESTOURO DO TMR0
TESTE_E2	
	BTFSS	INTCON, T0IF	;CONFIRO SE O TMR0 ESTOUROU
	GOTO	TESTE_E2		;SE NÃO ESTOUROU FICA CONFERINDO ATÉ ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_E2		;SE NÃO FOR ZERO VOLTA PARA O LOOP_2 PARA CONTAR O TEMPO DENOVO
	GOTO	MAIN
DIREITO
	;ETAPA_D1
	BSF	GPIO,GP5	;LIGA LED-D
	MOVLW	.10		;CONTADOR PARA FAZER UM TEMPO DE 500ms
	MOVWF	CONT
LOOP_D1	
	MOVLW	.61		;TEMPO PARA O TMR0 INICIAR, PARA FAZER 50ms
	MOVWF	TMR0		
	BCF	INTCON, T0IF	;LIMPA A FLAG DO ESTOURO DO TMR0
TESTE_D1	
	BTFSS	INTCON, T0IF	;CONFIRO SE O TMR0 ESTOUROU
	GOTO	TESTE_D1	;SE NÃO ESTOUROU FICA CONFERINDO ATÉ ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_D1		;SE NÃO FOR ZERO VOLTA PARA O LOOP_1 PARA CONTAR O TEMPO DENOVO
	;ETAPA_D2
	BCF	GPIO,GP5	;APAGA O LED-D
	MOVLW	.10		;E REPETE O MESMO PROCESSO DA PRIMEIRA ETAPA
	MOVWF	CONT		;PARA QUE O LED FIQUE APAGADO POR 500ms
LOOP_D2	
	MOVLW	.61		;TEMPO PARA O TMR0 INICIAR, PARA FAZER 50ms
	MOVWF	TMR0
	BCF	INTCON, T0IF	;LIMPA A FLAG DO ESTOURO DO TMR0
TESTE_D2	
	BTFSS	INTCON, T0IF	;CONFIRO SE O TMR0 ESTOUROU
	GOTO	TESTE_D2		;SE NÃO ESTOUROU FICA CONFERINDO ATÉ ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_D2		;SE NÃO FOR ZERO VOLTA PARA O LOOP_2 PARA CONTAR O TEMPO DENOVO
	GOTO MAIN

	GOTO MAIN
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
