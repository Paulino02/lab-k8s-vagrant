#!/bin/bash

# DNS e IP fixos definidos no próprio script
DNS_NAME="nginx.local"
IP_ADDR="192.168.56.12"

# Arquivos da CA
CA_KEY="myCA.key"
CA_CERT="myCA.crt"
CA_SERIAL="myCA.srl"

# Arquivos do certificado do servidor
CERT_KEY="${DNS_NAME}.key"
CERT_CSR="${DNS_NAME}.csr"
CERT_CRT="${DNS_NAME}.crt"
CERT_CONF="${DNS_NAME}-san.conf"

echo "==============================="
echo "[*] Gerando certificado para:"
echo "    DNS: $DNS_NAME"
echo "    IP:  $IP_ADDR"
echo "==============================="

# Passo 1: Cria a CA local se ainda não existir
if [ ! -f "$CA_KEY" ] || [ ! -f "$CA_CERT" ]; then
  echo "[*] Criando autoridade certificadora (CA)..."
  openssl genrsa -out $CA_KEY 4096
  openssl req -x509 -new -nodes -key $CA_KEY -sha256 -days 3650 \
    -out $CA_CERT -subj "/CN=Minha CA Local"
  echo "[✓] CA criada: $CA_CERT"
else
  echo "[✓] CA já existe. Pulando criação."
fi

# Passo 2: Gerar a chave privada do certificado
openssl genrsa -out $CERT_KEY 2048

# Passo 3: Criar config com SAN
cat > $CERT_CONF <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
CN = $DNS_NAME

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $DNS_NAME
IP.1 = $IP_ADDR
EOF

# Passo 4: Gerar o CSR
openssl req -new -key $CERT_KEY -out $CERT_CSR -config $CERT_CONF

# Passo 5: Assinar com a CA
openssl x509 -req -in $CERT_CSR -CA $CA_CERT -CAkey $CA_KEY \
  -CAcreateserial -CAserial $CA_SERIAL \
  -out $CERT_CRT -days 825 -sha256 \
  -extfile $CERT_CONF -extensions req_ext

# Passo 6: Limpeza
rm -f $CERT_CSR $CERT_CONF

echo "==============================="
echo "[✓] Certificado gerado com sucesso!"
echo " - Chave privada:  $CERT_KEY"
echo " - Certificado:    $CERT_CRT"
echo " - Assinado pela CA: $CA_CERT"
echo ""
echo "📥 Agora importe '$CA_CERT' no navegador como uma autoridade confiável."
