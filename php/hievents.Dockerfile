# Hi.Events all-in-one with php and php-fpm from the patched official image
# (PHP2Shell, CVE-2026-109618/109619; fixed in 8.5.12). Same Alpine release,
# same extension API, so the image's own extensions keep loading.
FROM php:8.5.12-fpm-alpine3.24 AS php
FROM daveearley/hi.events-all-in-one:latest
COPY --from=php /usr/local/bin/php /usr/local/bin/php
COPY --from=php /usr/local/sbin/php-fpm /usr/local/sbin/php-fpm
RUN php -v | grep -q '^PHP 8\.5\.12 ' && php-fpm -v | grep -q '^PHP 8\.5\.12 ' && php -m | grep -qx pdo_pgsql
