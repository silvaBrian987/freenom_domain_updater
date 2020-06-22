FROM python:3.7-alpine

ENV HOME /tmp/app

RUN mkdir -p $HOME

WORKDIR $HOME

COPY . $HOME

RUN apk add --no-cache build-base libxslt-dev libxml2 &&\
python -m pip install pipenv && \
pipenv lock -r > requirements.txt && \
pip install -r requirements.txt

CMD ["/bin/sh", "-c", "$HOME/init.sh"]

