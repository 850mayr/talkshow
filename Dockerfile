#builder
FROM python:3.6-slim as builder

WORKDIR  /app
ARG USERNAME

COPY . /app/

RUN pip install -e '.[dev]' && pip install email_validator
RUN flask adduser -u ${USERNAME} -p 1234
RUN flask addevent -n "Flask Conf" -d "2018-08-25"

FROM qnib/pytest as test

WORKDIR /test
COPY --from=builder /app /test

RUN py.test  -v --cov-config .coveragerc --cov=talkshow -l --tb=short --maxfail=1 tests/

FROM builder as serve

CMD ["flask", "run"]
