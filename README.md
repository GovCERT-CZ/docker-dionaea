# docker-dionaea

This is Docker image for honeypot Dionaea (https://github.com/DinoTools/dionaea).

Build docker image
    
    $ git clone https://github.com/GovCERT-CZ/docker-dionaea
    $ cd docker-dionaea
    $ docker build -t <repository>/<name> .
    

Build of docker image supports several custom build arguments for specifying certain parameters:
- cert_C: C field of generated certificate (default: DE)
- cert_CN: CN field of generated certificate (default: Nepenthes Development Team)
- cert_O: O field of generated certificate (default: dionaea.carnivore.it)
- cert_OU: OU field of generated certificate (default: anv)
- ftp_MSG: Welcome message of ftp service (default: Welcome to the ftp service)
- smb_ODN: OemDomainName of smb service (default: WORKGROUP)
- smb_SN: ServerName of smb service (default: HOMEUSER-3AF6FE)
- mssql_TT: VersionToken TokenType of mssql service (default: 0x00)

Build docker image with custom build args
    
    $ git clone https://github.com/GovCERT-CZ/docker-dionaea
    $ cd docker-dionaea
    $ docker build [--build-arg cert_C=<value>] [--build-arg cert_CN=<value>] [--build-arg cert_O=<value>] [--build-arg cert_OU=<value>] [--build-arg ftp_MSG=<value>] [--build-arg smb_ODN=<value>] [--build-arg smb_SN=<value>] [--build-arg mssql_TT=<value>] -t <repository>/<name> .
    

Run docker container with custom configuration
    
    $ wget https://raw.githubusercontent.com/DinoTools/dionaea/master/conf/dionaea.conf.dist -O dionaea.conf
    update dionaea.conf file with your settings
    $ docker run [--name <container name>] [-d] -p 21:21 -p 42:42 -p 80:80 -p 135:135 -p 443:443 -p 445:445 -p 1433:1433 -p 1723:1723 -p 1883:1883 -p 3306:3306 -p 5060:5060 -p 5061:5061 -p 69:69/udp -p 1900:1900/udp -p 5060:5060/udp [-v <host path>:/opt/dionaea/var/log] [-v <host path>/dionaea.conf:/opt/dionaea/etc/dionaea/dionaea.conf] <repository>/<name>
