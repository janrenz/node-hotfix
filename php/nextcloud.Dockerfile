# LinuxServer Nextcloud with Alpine's patched php85 packages (8.5.12).
FROM lscr.io/linuxserver/nextcloud:latest
RUN apk upgrade --no-cache 'php85*' && php -v | grep -q '^PHP 8\.5\.12 '
