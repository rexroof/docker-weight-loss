FROM alpine

RUN wget -q -O /cmatrix.tar https://github.com/abishekvashok/cmatrix/releases/download/v2.0/cmatrix-v2.0-Butterscotch.tar \
 && tar -xf /cmatrix.tar \
 && apk add --no-cache autoconf build-base ncurses-dev ncurses \
 && cd /cmatrix \
 && ./configure && make \
 && rm -f /cmatrix.tar \
 && apk del --no-cache autoconf build-base ncurses-dev

CMD ["/cmatrix/cmatrix"]
