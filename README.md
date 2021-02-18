# Tor Downloader

Auto-restartable downloads via tor proxy. This can run in parallel and uses a different tor proxy for each download. Does name resolution via the proxy to support onion URLs. Built for use on linux, may work elsewhere with minor tweaks.

## Getting started

1. Clone this repository and build the tor-proxy image:
    
    ```
    git clone https://github.com/dhrubins/tor-proxy-downloader
    cd tor-proxy-downloader
    docker build -t tor-proxy .
    ```

1. Use as follows:
    ```
    sh ./curl_tor.sh http://superlongurl.onion/reallybigfile.zip
    ```

1. Profit!