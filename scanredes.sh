#!/bin/bash 

# LIMPANDO A TELA
clear

# DECLARANDO VARIÁVEIS

IPREDE="$(ip -4 route show default | awk '{print $3}' | cut -d'.' -f1,2,3).0/24"
TEMPO="7"

# ADQUIRINDO ENDEREÇO IP DA REDE:

echo "Executando varredura de rede simples..."
sleep 5
echo "Seu endereço de rede é: $IPREDE"
sleep 5
echo ""

# EXECUTANDO VARREDURA DISP ATIVOS

clear
echo "Executando varredura para identificar dispositivos ativos em sua rede..."
sleep $TEMPO
echo ""

# COMANDO VARREDURA:

echo -e "Resultado da varredura de dispositivos ativos coletado e armazenado.\nAguarde um momento..."
CONTEUDO="$CONTEUDO$(echo -e "Resultado da varredura de dispositivos ativos na sua rede: ")\n"
CONTEUDO="$CONTEUDO$(nmap -sn $IPREDE)\n"

# VARREDURA DISP COM PORTAS ABERTA

clear
echo "Executando varredura para identificar dispositivo com portas abertas..."
sleep $TEMPO
echo ""

# COMANDO PORTAS ABERTAS:

echo -e "Resultado do escaneamento das 100 principais portas abertas coletado e armazenado.\nAguarde um momento..."
CONTEUDO="$CONTEUDO$(echo -e "\nResultado do escaneamento das 100 principais portas: ")\n"
CONTEUDO=$CONTEUDO"$(nmap -F $IPREDE)\n"

# CHECANDO VULNERABILIDADES:

clear
echo "Checando possíveis vulnerabilidades na sua rede..."
sleep $TEMPO

# COMANDO VULNERABILIDADES:

echo -e "Resultado da varredura coletado e armazenado\nAguarde um momento...."
CONTEUDO="$CONTEUDO$(echo -e "\nResultado da varredura de vulnerabilidades na sua rede: ")\n"
CONTEUDO=$CONTEUDO"$(nmap --script=vuln $IPREDE)\n"

# EMAIL USUÁRIO

clear
echo "Fim do escaneamento! Os resultados serão enviados para o seu e-mail."
read -p "Insira seu e-mail: " USRMAIL
echo ""

# ENVIANDO EMAIL (MUTT)

if [ -z "$USRMAIL" ];

	then
		echo "Você deve digitar um endereço de e-mail. Abortando a execução."
		sleep $TEMPO
		clear
	else	
		echo -e "$CONTEUDO" | mutt -s "Resultado do Nmap" -- $USRMAIL > /dev/null 2>&1
		echo -e "E-mail enviado! Cheque sua caixa de entrada para ter acesso ao resultado.\nFim do script!"
		sleep $TEMPO
		clear
fi
