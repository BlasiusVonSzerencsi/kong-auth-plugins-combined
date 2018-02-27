FROM debian:latest

ARG LUA_VERSION=5.3.4
ARG LUAROCKS_VERSION=2.4.3

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get install -y \
    build-essential \
    libreadline-dev \
    libssl-dev \
    unzip \
    wget

# download and install Lua
RUN wget https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz

RUN tar xf lua-${LUA_VERSION}.tar.gz
RUN cd /lua-${LUA_VERSION} \
    && make linux \
    && ln -s /lua-${LUA_VERSION}/src/lua /usr/bin/lua

# download and install LuaRocks
RUN wget http://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz

RUN tar xf luarocks-${LUAROCKS_VERSION}.tar.gz
RUN cd /luarocks-${LUAROCKS_VERSION} \
    && ./configure --with-lua-include=/lua-${LUA_VERSION}/src/ \
    && make bootstrap

RUN luarocks install lua-requests
