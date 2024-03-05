#!/bin/bash

#Primero, se procede a crear un directorio destinado a alojar el certificado:
sudo mkdir /etc/nginx/ssl

# A continuación, se genera un archivo de clave privada:
sudo openssl genrsa -out /etc/nginx/ssl/example.com.key 2048

# Posteriormente, se crea un archivo de solicitud de firma de certificado (CSR):
sudo openssl req -new -key /etc/nginx/ssl/example.com.key -out /etc/nginx/ssl/example.com.csr

# Durante este proceso, se deben proporcionar los detalles necesarios, incluyendo el nombre de dominio o 
# la dirección IP que se utilizará para HTTPS, en el campo "Common Name".
Finalmente, se genera el certificado autofirmado:

sudo openssl x509 -req -days 365 -in /etc/nginx/ssl/example.com.csr -signkey /etc/nginx/ssl/example.com.key -out /etc/nginx/ssl/example.com.crt

