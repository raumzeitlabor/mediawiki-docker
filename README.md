This is the image we're using for our wiki at https://w.rzl.so. It is based on
[phusion/baseimage-docker](https://github.com/phusion/baseimage-docker).

The mediawiki version being used is 1.23.8 (LTS). The image comes with a
default installation housed in `/data`.

### Requirements

This container requires a running, linked mysql instance, e.g.
[raumzeitlabor/mysql-docker](https://github.com/raumzeitlabor/mysql-docker). It
is intended to be run behind a reverse-proxy and thus comes with an SSL
webserver configuration.

### Setup

To set up this container, simply copy the `mediawiki.service` file to
`/etc/systemd/system` and run `systemctl daemon-reload`, followed by `systemctl
start mediawiki.service`.

The service unit will then take care of creating two containers:

* `mediawiki-data`: The data-only container that exposes a volume called
`/data`. This container immediately exits. It's only purpose is to keep state.
_Don't delete it._
* `mediawiki-web`: The application container that houses an nginx webserver,
and php5-fpm.

### Backup

A script called `/etc/cron.daily/backup-mysql` creates a daily dump of the
database configured for this mediawiki installation. By default, the dump is
placed into `/data/backup` and dumps older than 14 days are deleted.

The idea is to mount the `/data` volume of `mediawiki-data` from another
container and then create an offsite backup of the entire folder.
