# Archivos de configuración de NGINX 

## How to create an HTTPS certificate for localhost domains

This focuses on generating the certificates for loading local virtual hosts hosted on your computer, for development only.

**Do not use self-signed certificates in production !**
For online certificates, use Let's Encrypt instead ([tutorial](https://gist.github.com/cecilemuller/a26737699a7e70a7093d4dc115915de8)).

### Certificate authority (CA)

Generate `RootCA.pem`, `RootCA.key` & `RootCA.crt`:

 openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout RootCA.key -out RootCA.pem -subj "/C=AR/CN=Laboratorio de Arquitecturas de Computadoras"
 openssl x509 -outform pem -in RootCA.pem -out RootCA.crt

Note that `Example-Root-CA` is an example, you can customize the name.

### Domain name certificate

Let's say you have two domains `fake1.local` and `fake2.local` that are hosted on your local machine
for development (using the `hosts` file to point them to `127.0.0.1`).

First, create a file `domains.ext` that lists all your local domains:

 authorityKeyIdentifier=keyid,issuer
 basicConstraints=CA:FALSE
 keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
 subjectAltName = @alt_names
 [alt_names]
 DNS.1 = localhost
 DNS.2 = fake1.local
 DNS.3 = fake2.local

Generate `localhost.key`, `localhost.csr`, and `localhost.crt`:

 openssl req -new -nodes -newkey rsa:2048 -keyout localhost.key -out localhost.csr -subj "/C=AR/ST=Cordoba/L=Cordoba/O=Nuestra-Certificacion/CN=ingreso.lac"
 openssl x509 -req -sha256 -days 1024 -in localhost.csr -CA RootCA.pem -CAkey RootCA.key -CAcreateserial -extfile domains.ext -out localhost.crt

Note that the country / state / city / name in the first command  can be customized.

You can now configure your webserver, for example with Apache:

 SSLEngine on
 SSLCertificateFile "C:/example/localhost.crt"
 SSLCertificateKeyFile "C:/example/localhost.key"

### Trust the local CA

At this point, the site would load with a warning about self-signed certificates.
In order to get a green lock, your new local CA has to be added to the trusted Root Certificate Authorities.

#### Windows 10: Chrome, IE11 & Edge

Windows 10 recognizes `.crt` files, so you can right-click on `RootCA.crt` > `Install` to open the import dialog.

Make sure to select "Trusted Root Certification Authorities" and confirm.

You should now get a green lock in Chrome, IE11 and Edge.

#### Windows 10: Firefox

There are two ways to get the CA trusted in Firefox.

The simplest is to make Firefox use the Windows trusted Root CAs by going to `about:config`,
and setting `security.enterprise_roots.enabled` to `true`.

The other way is to import the certificate by going
to `about:preferences#privacy` > `Certificats` > `Import` > `RootCA.pem` > `Confirm for websites`.

### NOTES

Note that if you are generating for localhost, in the commands for "Generate localhost.key, localhost.csr, and localhost.crt:" the CN in the first command should be ".../CN=localhost", not ".../CN=localhost.local" otherwise Chrome (and maybe others) won't like it.  

if i need to add more hosts in the future, i have to update the domain.ext file and re-generate the certificates with the two instructions

```bash
openssl req -new -nodes -newkey rsa:2048 -keyout localhost.key -out localhost.csr -subj "/C=US/ST=YourState/L=YourCity/O=Example-Certificates/CN=localhost.local"
openssl x509 -req -sha256 -days 1024 -in localhost.csr -CA RootCA.pem -CAkey RootCA.key -CAcreateserial -extfile domains.ext -out localhost.crt
```

## Configuracion nginx

Crear un link simbolico del archivo etc_nginx_sites-enabled_default
a la carpeta de configuracion de nginx:

```bash
sudo ln -s /home/agustin/tesis/nginx-config-files/etc_nginx_sites-enabled_default default
```

### Certificados nginx

Copiar los certificados generados en la API Central y modificar la ruta.

### Autenticación Basica

To create username-password pairs, use a password file creation utility, for example, apache2-utils or httpd-tools

```bash
sudo apt install apache2-utils
```

Verify that apache2-utils (Debian, Ubuntu) or httpd-tools (RHEL/CentOS/Oracle Linux) is installed.

Create a password file and a first user. Run the htpasswd utility with the -c flag (to create a new file), the file pathname as the first argument, and the username as the second argument:

```bash
sudo htpasswd -c htpasswd usuario-api
```

Press Enter and type the password for user1 at the prompts.

Create additional user-password pairs. Omit the -c flag because the file already exists:

```bash
sudo htpasswd htpasswd user2
```

### Datos usuario de prueba

- Usuario: usuario-api
- Password: password-api

### Configuracion IP estatica

```bash
   nmcli con show
   sudo nmcli device wifi connect tesis password mediamaquina ifname wlxf4f26d09b2ff
   sudo nmcli con mod "VALENTINA " ipv4.addresses "192.168.1.253/24" ipv4.gateway "192.168.1.1" ipv4.dns "192.168.1.1,8.8.8.8" ipv4.method "manual"
```

### Configuracion ARCHIVOS ESTATICOS

<https://gist.github.com/XUJiahua/ab64998268952d590f8447029e6105ea>

<https://stackoverflow.com/questions/10631933/nginx-static-file-serving-confusion-with-root-alias>

```bash
location /static/ 
{
    alias /var/www/example.com/current/static/;
    gzip_static on;
    expires max;
    add_header Cache-Control public;
}
```
