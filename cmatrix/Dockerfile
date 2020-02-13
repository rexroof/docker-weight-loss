FROM alpine
ADD \
  https://github.com/abishekvashok/cmatrix/releases/download/v2.0/cmatrix-v2.0-Butterscotch.tar \
  cmatrix-v2.0-Butterscotch.tar
RUN tar -xf cmatrix-v2.0-Butterscotch.tar
RUN apk add autoconf build-base ncurses-dev ncurses
RUN cd /cmatrix && ./configure && make
RUN rm -f cmatrix-v2.0-Butterscotch.tar
RUN strip /cmatrix/cmatrix
RUN apk del autoconf build-base ncurses-dev
CMD ["/cmatrix/cmatrix"]
