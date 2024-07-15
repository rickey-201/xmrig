FROM ubuntu
RUN mkdir /app
WORKDIR /app
COPY ./* /app/
RUN rm -rf /app/build
RUN apt-get update
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