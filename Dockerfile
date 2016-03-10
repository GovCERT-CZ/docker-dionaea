FROM ubuntu:trusty
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
COPY entrypoint.sh /entrypoint.sh
ARG cert_C="DE"
ARG cert_CN="Nepenthes Development Team"
ARG cert_O="dionaea.carnivore.it"
ARG cert_OU="anv"
ARG ftp_MSG="Welcome to the ftp service"
ARG smb_ODN="WORKGROUP"
ARG smb_SN="HOMEUSER-3AF6FE"
ARG mssql_TT="0x00"
RUN apt-get update && apt-get -y dist-upgrade && \
	apt-get -y install git authbind wget curl libudns-dev libglib2.0-dev libssl-dev libcurl4-openssl-dev libreadline-dev libsqlite3-dev python-dev libpq-dev libtool automake autoconf build-essential  subversion git-core flex bison pkg-config sqlite3 libgc-dev unzip && \
	useradd -d /home/dionaea -s /bin/bash -m -U dionaea && \
	mkdir -p /opt/dionaea/ && \
	cd /tmp && \
	git clone https://github.com/DinoTools/liblcfg && \
	cd liblcfg && \
	cd code && \
	autoreconf -vi && \
	./configure --prefix=/opt/dionaea --disable-werror && \
	make && \
	make install && \
	cd /tmp && \
	git clone https://github.com/DinoTools/libemu && \
	cd libemu/ && \
	autoreconf -vi && \
	./configure --prefix=/opt/dionaea --enable-python-bindings && \
	sed -i 's/-Werror//g' src/Makefile && \
	make && \
	make install && \
	cd /tmp && \
	git clone git://git.infradead.org/users/tgr/libnl.git && \
	cd libnl/ && \
	autoreconf -vi && \
	export LDFLAGS=-Wl,-rpath,/opt/dionaea/lib && \
	./configure --prefix=/opt/dionaea --disable-werror && \
	make && \
	make install && \
	cd /tmp && \
	wget http://dist.schmorp.de/libev/libev-4.22.tar.gz && \
	gzip -d libev-4.22.tar.gz  && \
	tar -xf libev-4.22.tar && \
	cd libev-4.22/ && \
	./configure --prefix=/opt/dionaea && \
	make install && \
	cd /tmp && \
	wget http://www.python.org/ftp/python/3.5.1/Python-3.5.1.tgz && \
	tar xfz Python-3.5.1.tgz && \
	cd Python-3.5.1/ && \
	./configure --enable-shared --prefix=/opt/dionaea --with-computed-gotos \
	 --enable-ipv6 LDFLAGS="-Wl,-rpath=/opt/dionaea/lib/ -L/usr/lib/x86_64-linux-gnu/"  && \
	make && \
	make install && \
	cd /tmp && \
	wget https://pypi.python.org/packages/source/p/py-postgresql/py-postgresql-1.1.0.zip && \
	unzip py-postgresql-1.1.0.zip && \
	cd py-postgresql-1.1.0 && \
	/opt/dionaea/bin/python3 setup.py install && \
	cd /tmp && \
	wget http://cython.org/release/Cython-0.22.1.tar.gz && \
	tar xzvf Cython-0.22.1.tar.gz && \
	cd Cython-0.22.1/ && \
	/opt/dionaea/bin/python3 setup.py install && \
	cd /tmp && \
	wget http://www.tcpdump.org/release/libpcap-1.7.4.tar.gz && \
	tar xzvf libpcap-1.7.4.tar.gz && \
	cd libpcap-1.7.4/ && \
	./configure --prefix=/opt/dionaea && \
	make && \
	make install && \
	cd /tmp && \
	git clone https://github.com/DinoTools/dionaea && \
	cd dionaea/ && \
	sed -i "s/MBSTRING_ASC, (const unsigned char \*)\"DE\", -1, -1, 0)/MBSTRING_ASC, (const unsigned char \*)\"$cert_C\", -1, -1, 0)/" ./src/connection.c && \
	sed -i "s/MBSTRING_ASC, (const unsigned char \*)\"Nepenthes Development Team\", -1, -1, 0)/MBSTRING_ASC, (const unsigned char \*)\"$cert_CN\", -1, -1, 0)/" ./src/connection.c && \
	sed -i "s/MBSTRING_ASC, (const unsigned char \*)\"dionaea.carnivore.it\", -1, -1, 0)/MBSTRING_ASC, (const unsigned char \*)\"$cert_O\", -1, -1, 0)/" ./src/connection.c && \
	sed -i "s/MBSTRING_ASC, (const unsigned char \*)\"anv\", -1, -1, 0)/MBSTRING_ASC, (const unsigned char \*)\"$cert_OU\", -1, -1, 0)/" ./src/connection.c && \
	autoreconf -vi && \
	./configure --with-lcfg-include=/opt/dionaea/include/ --with-lcfg-lib=/opt/dionaea/lib/ --with-python=/opt/dionaea/bin/python3.5 --with-cython-dir=/opt/dionaea/bin --with-udns-include=/usr/include/ --with-udns-lib=/usr/lib/ --with-emu-include=/opt/dionaea/include/ --with-emu-lib=/opt/dionaea/lib/ --with-gc-include=/usr/include/gc --with-ev-include=/opt/dionaea/include --with-ev-lib=/opt/dionaea/lib --with-nl-include=/usr/include --with-nl-lib=/usr/lib/ --with-curl-config=/usr/bin/ --with-pcap-include=/opt/dionaea/include --with-pcap-lib=/opt/dionaea/lib/ && \
	make && \
	make install && \
	sed -i "s/self.reply(WELCOME_MSG, \"Welcome to the ftp service\")/self.reply(WELCOME_MSG, \"$ftp_MSG\")/" /opt/dionaea/lib/dionaea/python/dionaea/ftp.py && \
	sed -i "s/\"OemDomainName\", \"WORKGROUP\")/\"OemDomainName\", \"$smb_ODN\")/" /opt/dionaea/lib/dionaea/python/dionaea/smb/include/smbfields.py && \
	sed -i "s/\"ServerName\", \"HOMEUSER-3AF6FE\")/\"ServerName\", \"$smb_SN\")/" /opt/dionaea/lib/dionaea/python/dionaea/smb/include/smbfields.py && \
	sed -i "s/r.VersionToken.TokenType = 0x00/r.VersionToken.TokenType = $mssql_TT/" /opt/dionaea/lib/dionaea/python/dionaea/mssql/mssql.py && \
	mkdir -p /opt/dionaea/var/dionaea/wwwroot /opt/dionaea/var/dionaea/binaries /opt/dionaea/var/dionaea/log && \
	chown -R dionaea:dionaea /opt/dionaea/var/dionaea && \
	mkdir -p /opt/dionaea/var/dionaea/bistreams  && \
	chown dionaea:dionaea /opt/dionaea/var/dionaea/bistreams && \
	chown -R dionaea:dionaea /opt/dionaea && \
	chmod +x /entrypoint.sh

EXPOSE 21 42 80 135 443 445 1433 1723 1883 3306 5060 5061 69/udp 1900/udp 5060/udp
ENTRYPOINT ["/entrypoint.sh"]
