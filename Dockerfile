FROM ubuntu
RUN apt-get update
RUN apt install -y tree
# 复制文件
COPY ./bin /app/bin
COPY ./cmake /app/cmake
COPY ./doc /app/doc
COPY ./res /app/res
COPY ./scripts /app/scripts 
COPY ./src /app/src
COPY ./CMakeLists.txt /app/CMakeLists.txt
# 安装依赖并编译
WORKDIR /app
RUN apt install -y git build-essential cmake automake libtool autoconf wget tar 
RUN mkdir /app/build
WORKDIR /app/scripts
RUN /app/scripts/build_deps.sh
WORKDIR /app/build
RUN cmake /app -DXMRIG_DEPS=scripts/deps -DWITH_EMBEDDED_CONFIG=ON
RUN make -j$(nproc)
RUN mkdir /app-build
# 打包
WORKDIR /app-build
RUN mv /app/build/xmrig /app-build/app
RUN chmod +x /app-build/app
# 删除编译的临时文件
WORKDIR /
RUN rm -rf /app

ENTRYPOINT ["/app-build/app"]