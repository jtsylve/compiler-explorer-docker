FROM ubuntu
LABEL maintainer "joe.sylve@gmail.com"

# Update and install packages
RUN apt-get update && apt-get install -y \
        curl \
        xz-utils \
        npm \
        git \
    && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Download and unpack compilers
RUN mkdir -p /opt/compilers
WORKDIR /opt/compilers
RUN curl -sL https://s3.amazonaws.com/compiler-explorer/opt/gcc-7.1.0.tar.xz | tar Jxf - && \
    curl -sL https://s3.amazonaws.com/compiler-explorer/opt/clang-4.0.0.tar.xz | tar Jxf -

# Create user and create working directories 
RUN useradd ceuser && \
    mkdir -p /home/ceuser /opt/compiler-explorer && \
    chown ceuser /home/ceuser /opt/compiler-explorer

# Do the initial checkout of the source and install prereqs
USER ceuser
WORKDIR /opt/compiler-explorer
RUN git clone --single-branch --branch release \
    https://github.com/mattgodbolt/compiler-explorer.git . && \
    make prereqs

# Copy the config files
USER root
COPY *.properties /opt/compiler-explorer/etc/config/
RUN chown -R ceuser /opt/compiler-explorer/etc/config/

# Copy the startup script
COPY run-ce.sh /
RUN chmod +x /run-ce.sh

# Set startup entrypoint
USER ceuser
EXPOSE 10240
ENTRYPOINT /run-ce.sh

