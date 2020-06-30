FROM ubuntu:18.04

LABEL maintainer="diego@mundoit.com.ar" \
	  version.ubuntu="18.04"

ENV DEBIAN_FRONTEND noninteractive

# Utils
RUN apt update && \
    apt install -y --no-install-recommends \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
    wget \
    unzip \
    dos2unix \
    libreoffice \
    libreoffice-writer \
    libreoffice-java-common \
    libreoffice-core \
    libreoffice-common \
    openjdk-8-jre \
    fonts-opensymbol \
    hyphen-es \
    hyphen-fr \
    hyphen-de \
    hyphen-en-us \
    hyphen-it \
    hyphen-ru \
    ure \
	fontconfig \
	fonts-ipafont-gothic \
	fonts-wqy-zenhei \
	fonts-thai-tlwg \
	fonts-kacst \
	fonts-symbola \
	fonts-noto \
	fonts-freefont-ttf \
    fonts-dejavu \
    fonts-dejavu-core \
    fonts-dejavu-extra \
    fonts-droid-fallback \
    fonts-dustin \
    fonts-f500 \
    fonts-fanwood \
    fonts-liberation \
    fonts-lmodern \
    fonts-lyx \
    fonts-sil-gentium \
    fonts-texgyre \
    fonts-tlwg-purisa \
    barcode \
    pdf2svg \
    #pdftk \
    libxml2-dev && \
    apt remove -y -q libreoffice-gnome && \
    apt autoremove -y && rm -rf /var/lib/apt/lists/*

# Chrome
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
	echo "deb https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
	apt update && apt install -y --no-install-recommends google-chrome-beta && \
	apt autoremove -y && rm -rf /var/lib/apt/lists/*

# Install dependencies for running web service
RUN apt update && apt install -y python3.6 python3-pip

RUN pip3 install Flask Flask-API Flask_httpauth

# Cleanup
RUN apt-get -y clean && \
    apt-get -y purge && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# PCL2PDF AND OTHER UTILS
COPY ./bin /usr/local/bin

ADD app.py /app.py

RUN chmod +x /usr/local/bin/magicspooler.sh

ENV MAGICSPOOLER_USER ""
ENV MAGICSPOOLER_PASSWORD ""

VOLUME ["/tmp"]

WORKDIR "/tmp"

EXPOSE 5000

ENTRYPOINT [ "python3.6" ]

CMD [ "/app.py" ]

