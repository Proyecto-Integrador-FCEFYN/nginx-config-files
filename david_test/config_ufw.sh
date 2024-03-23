# Permitir tráfico en los puertos 80, 443 y 22
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp

# Denegar todo el tráfico entrante
sudo ufw default deny incoming

# Habilitar UFW para aplicar las reglas
sudo ufw enable
