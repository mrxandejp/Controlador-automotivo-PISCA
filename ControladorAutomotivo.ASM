;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		;NOVAS VARI�VEIS
		CONT		;CONTADOR PARA O TMR0
		PISCA_ALERTA    ;FLAG PARA INDICAR SE O PISCA ALERTA EST� ACIONADO
		FAROL_ESQUERDO	;FLAG PARA INDICAR SE O FAROL ESQUERDO EST� ACIONADO
		FAROL_DIREITO	;FLAG PARA INDICAR SE O FAROL DIREITO EST� ACIONADO
		

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES
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
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

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
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000111'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'10000111'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'10001000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	MOVLW	B'00000111'	;DEFINE AS INTERRUP��ES DAS ENTRADAS 
	MOVWF	IOC		;GP0 GP1 E GP2
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL.
	BTFSC	PISCA_ALERTA,0	;CONFERE SE A FLAG DO ALERTA EST� LIGADO
	GOTO	ALERTA		;SE ESTIVER VAI PARA O ALERTA SE N�O
	BTFSC	FAROL_ESQUERDO,0;CONFERE SE A FLAG DO FAROL ESQUERDO T� LIGADO
	GOTO	ESQUERDO	;SE ESTIVER VAI PARA O ESQUERDO SE N�O
	BTFSC	FAROL_DIREITO,0	;CONFERE SE A FLAG DO FAROL DIREITO T� LIGADO
	GOTO	DIREITO		;SE ESTIVER VAI PARA O DIREITO SE N�O
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
	GOTO	TESTE_1		;SE N�O ESTOUROU FICA CONFERINDO AT� ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_1		;SE N�O FOR ZERO VOLTA PARA O LOOP_1 PARA CONTAR O TEMPO DENOVO
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
	GOTO	TESTE_2		;SE N�O ESTOUROU FICA CONFERINDO AT� ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_2		;SE N�O FOR ZERO VOLTA PARA O LOOP_2 PARA CONTAR O TEMPO DENOVO
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
	GOTO	TESTE_E1	;SE N�O ESTOUROU FICA CONFERINDO AT� ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_E1		;SE N�O FOR ZERO VOLTA PARA O LOOP_1 PARA CONTAR O TEMPO DENOVO
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
	GOTO	TESTE_E2		;SE N�O ESTOUROU FICA CONFERINDO AT� ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_E2		;SE N�O FOR ZERO VOLTA PARA O LOOP_2 PARA CONTAR O TEMPO DENOVO
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
	GOTO	TESTE_D1	;SE N�O ESTOUROU FICA CONFERINDO AT� ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_D1		;SE N�O FOR ZERO VOLTA PARA O LOOP_1 PARA CONTAR O TEMPO DENOVO
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
	GOTO	TESTE_D2		;SE N�O ESTOUROU FICA CONFERINDO AT� ESTOURAR
	DECFSZ	CONT,F		;DECREMENTO O CONT, SE FOR ZERO PULA
	GOTO	LOOP_D2		;SE N�O FOR ZERO VOLTA PARA O LOOP_2 PARA CONTAR O TEMPO DENOVO
	GOTO MAIN

	GOTO MAIN
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
