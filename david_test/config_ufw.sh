# Permitir tráfico en los puertos 80 y 443
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp

# Habilitar UFW para aplicar las reglas
sudo ufw enable
