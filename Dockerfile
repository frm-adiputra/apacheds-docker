FROM java:7-jre

ENV APACHEDS_VERSION 2.0.0-M21
ENV APACHEDS_ARCH amd64
ENV APACHEDS_ARCHIVE apacheds-${APACHEDS_VERSION}-${APACHEDS_ARCH}.deb

RUN wget http://www.apache.org/dist/directory/KEYS \
 && wget http://archive.apache.org/dist/directory/apacheds/dist/${APACHEDS_VERSION}/${APACHEDS_ARCHIVE}.asc \
 && wget http://mirror.wanxp.id/apache//directory/apacheds/dist/${APACHEDS_VERSION}/${APACHEDS_ARCHIVE} \
 && gpg --import KEYS \
 && gpg --verify ${APACHEDS_ARCHIVE}.asc \
 && dpkg -i apacheds-${APACHEDS_VERSION}-amd64.deb \
 && rm -f \
  KEYS \
  ${APACHEDS_ARCHIVE}.asc \
  ${APACHEDS_ARCHIVE}

ENV APACHEDS_DATA /var/lib/apacheds-${APACHEDS_VERSION}
ENV APACHEDS_USER apacheds
ENV APACHEDS_GROUP apacheds
ENV APACHEDS_INSTANCE default
ENV APACHEDS_BOOTSTRAP /bootstrap

RUN mkdir -p ${APACHEDS_BOOTSTRAP} \
 && cp -rv ${APACHEDS_DATA}/default/* ${APACHEDS_BOOTSTRAP} \
 && chown -v -R ${APACHEDS_USER}:${APACHEDS_GROUP} ${APACHEDS_BOOTSTRAP}

VOLUME ${APACHEDS_DATA}

COPY run.sh /run.sh
RUN chown ${APACHEDS_USER}:${APACHEDS_GROUP} /run.sh \
    && chmod u+rx /run.sh

CMD ["/run.sh"]
