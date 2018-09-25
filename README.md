# Controlador automotivo: PISCA

## Objetivo:
Exercícios para gerenciamento de portas e de tempo (com TIMERs e interrupção).

## Contexto: 
Sistema de sinalização automotiva, controlando o "pisca-pisca" lados direito e esquerdo,
quando acionados.

## Especificações:
* Um interruptor de 3 posições, para acender 2 LEDs (LED-E e LED-D):
* Quando na posição central, o LED-E e o LED-D permanecem apagados;
* Quando na posição E (esquerda), o LED-E pisca com frequência de 1 Hz;
* Quando na posição D (direita), o LED-D pisca com frequência de 1 Hz;
* Um interruptor (liga-desliga), pisca os dois LEDs ao mesmo tempo (função alerta), com
frequência de 1 Hz. Esse interruptor tem maior prioridade;
* GP0 é utilizado com o interruptor que comandará a função "alerta";
* GP1 e GP2 são utilizados para o interruptor de 3 posições;
* GP4 e GP5 são utilizados, respectivamente, para os LED-E e LED-D.
