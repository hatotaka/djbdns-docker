FROM ubuntu

ENV DAEMONTOOLS_VERSION 0.76
ENV UCSPI_TCP_VERSION 0.88
ENV DJBDNS_VERSION 1.05

RUN apt-get update \
 && apt-get install -y \
   curl \
   make \
   gcc

RUN mkdir -p /package \
 && chmod 1755 /package \
 && cd /package \
 && curl -O http://cr.yp.to/daemontools/daemontools-${DAEMONTOOLS_VERSION}.tar.gz \
 && tar zxvf daemontools-${DAEMONTOOLS_VERSION}.tar.gz \
 && cd admin/daemontools-${DAEMONTOOLS_VERSION} \
 && echo gcc -O2 -include /usr/include/errno.h > src/conf-cc \
 && package/install \
 && cd /package \
 && curl -O https://cr.yp.to/ucspi-tcp/ucspi-tcp-${UCSPI_TCP_VERSION}.tar.gz \
 && tar zxvf ucspi-tcp-${UCSPI_TCP_VERSION}.tar.gz \
 && cd ucspi-tcp-${UCSPI_TCP_VERSION} \
 && echo gcc -O2 -include /usr/include/errno.h > conf-cc \
 && make \
 && make setup check \
 && cd /package \
 && curl -O https://cr.yp.to/djbdns/djbdns-${DJBDNS_VERSION}.tar.gz \
 && tar zxvf djbdns-${DJBDNS_VERSION}.tar.gz \
 && cd djbdns-${DJBDNS_VERSION} \
 && echo gcc -O2 -include /usr/include/errno.h > conf-cc \
 && make \
 && make setup check \
 && rm /package/*.tar.gz


RUN true \
 && tinydns-conf root root /etc/tinydns 0.0.0.0 \
 && ln -s /etc/tinydns /service/tinydns \
 && true

EXPOSE 53 53/udp

ENTRYPOINT /command/svscanboot

