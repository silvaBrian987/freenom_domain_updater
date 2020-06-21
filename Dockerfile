FROM python:3.7-alpine

ENV HOME /tmp/app

RUN mkdir -p $HOME

WORKDIR $HOME

COPY . $HOME

CMD ["/bin/sh", "-c", "$HOME/init.sh"]

