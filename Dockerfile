# Use the Ubuntu base image
FROM ubuntu:22.04

# Set non-interactive mode for apt-get to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    xorg \
    openbox \
    xterm \
    tigervnc-standalone-server \
    tigervnc-common \
    locales \
    && apt-get clean

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Download and install VNC viewer
RUN wget -qO /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

# Set up environment variables
ENV DISPLAY=:1
ENV PORT=8080
ENV USERNAME=admin
ENV PASSWORD=admin

# Create a startup script for the VNC server
RUN echo '#!/bin/bash\n\
vncserver :1 -geometry 1280x720 -depth 24\n\
openbox &\n\
sleep 5\n\
xterm\n\
exec /usr/local/bin/ttyd -p $PORT -c $USERNAME:$PASSWORD /usr/bin/xterm' > /startup.sh && \
    chmod +x /startup.sh

# Expose the port for the web interface
EXPOSE $PORT

# Start the VNC server and the ttyd service
CMD ["/bin/bash", "/startup.sh"]
