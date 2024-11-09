# Proxy Server Solution

This project sets up a proxy server that listens on port 80 and forwards requests to an Apache2 web server running on port 10000. The proxy server script 
determines which HTML page (either `index.html` or `error.html`) to return to the client based on calculations derived from system data.

## Features:
- Apache2 web server running on port 10000.
- Proxy server on port 80 that dynamically decides which page to serve (`index.html` or `error.html`) based on system calculations.
- Secure access to the Apache2 server via local connections only.
- Systemd service for automatically starting the proxy server on boot.

## Files in this repository:
1. `configureSystem.sh`: A script to set up the environment on a fresh Ubuntu 24.04 installation.
2. `index.html`: HTML file to be served on a success condition.
3. `error.html`: HTML file to be served on a failure condition.
4. `proxyServer.sh`: Proxy server script that forwards traffic to the Apache server.
5. `proxyServer.service`: systemd service file to run the proxy server automatically.

## Prerequisites:
- A fresh installation of **Ubuntu 24.04** (or a compatible version).
- Sudo privileges for installing dependencies and modifying system configurations.

## Setup Instructions:

1. **Download and Extract the Files**:
   Download the repository zip file, extract it to your desired location, and navigate to the extracted directory.

2. **Run the Setup Script**:
   The `configureSystem.sh` script will install all necessary dependencies, configure Apache2, and set up the proxy server.

   In the terminal, navigate to the extracted directory and run:
   ```bash
   chmod +x configureSystem.sh  # Make the script executable
   ./configureSystem.sh         # Run the setup script
   curl http://localhost        # Run to see response   
