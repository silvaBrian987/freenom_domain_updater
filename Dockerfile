FROM python:3.7-alpine

ENV HOME /tmp/app

# I install the OS package here to reuse the layer more often
RUN apk add --no-cache build-base libxslt-dev libxml2 && \
    mkdir -p $HOME

WORKDIR $HOME

COPY Pipfile Pipfile.lock $HOME/

RUN python -m pip install pipenv && \
    pipenv lock -r > requirements.txt && \
    pip install -r requirements.txt

COPY . $HOME

RUN chmod u+x $HOME/*.sh && \
    $HOME/add-debug-periodic.sh

# USER 1000:1000

CMD ["/bin/sh", "-c", "$HOME/init.sh"]

