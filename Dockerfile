FROM broadinstitute/gatk:4.5.0.0

# alternate method could involve using gramine docker image as base and copying gatk directory containing necessary executables
#   from 'app' image into our final image
# FROM enclaive/gramine-os:latest

# install necessary softwares for gatk to run
#RUN apt-get update \
#    && apt-get install -y libprotobuf-c1 openjdk-17-jre-headless r-base \
#    && ln -s /usr/bin/python3 /usr/bin/python \
#    && rm -rf /var/lib/apt/lists/*
#COPY --from=app /gatk /gatk/

# install gramine
RUN curl -fsSLo /usr/share/keyrings/gramine-keyring.gpg https://packages.gramineproject.io/gramine-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/gramine-keyring.gpg] https://packages.gramineproject.io/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/gramine.list
RUN curl -fsSLo /usr/share/keyrings/intel-sgx-deb.asc https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-sgx-deb.asc] https://download.01.org/intel-sgx/sgx_repo/ubuntu $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/intel-sgx.list
RUN apt-get update && apt-get install -y gramine openjdk-17-jre-headless
RUN rm /usr/bin/java
RUN chmod 777 /usr/lib/python3.10
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/lib/jvm/java-17-openjdk-amd64/bin/java /usr/bin/java

COPY ./manifest.template /app/
COPY ./entrypoint.sh /app/
COPY ./gatk.sh /app/

WORKDIR /app

RUN chmod u+x gatk.sh
RUN gramine-sgx-gen-private-key
RUN gramine-manifest -Dlog_level=error -Dexecdir=/usr/bin \
	-Darch_libdir=/lib/x86_64-linux-gnu manifest.template bash.manifest
RUN gramine-sgx-sign --manifest bash.manifest --output bash.manifest.sgx

ENTRYPOINT ["sh", "entrypoint.sh"]
