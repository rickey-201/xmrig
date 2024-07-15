FROM ubuntu
RUN apt-get update
RUN apt install -y tree
COPY ./bin /app/bin
COPY ./cmake /app/cmake
COPY ./doc /app/doc
COPY ./res /app/res
COPY ./scripts /app/scripts 
COPY ./src /app/src
WORKDIR /app
RUN cat /app/scripts/build_deps.sh
RUN apt install -y git build-essential cmake automake libtool autoconf
RUN mkdir /app/build
WORKDIR /app/scripts
RUN /app/scripts/build_deps.sh
WORKDIR /app/build
RUN cmake /app -DXMRIG_DEPS=scripts/deps -DWITH_EMBEDDED_CONFIG=ON
RUN make -j$(nproc)
RUN mkdir /app-build
WORKDIR /app-build
RUN mv /app/build/xmrig /app-build/app
RUN chmod +x /app-build/app
ENTRYPOINT ["/app-build/app"]