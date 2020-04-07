FROM python:3.8-slim-buster as base

#FROM base as builder

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		build-essential \
	&& rm -rf /var/lib/apt/lists/*


COPY requirements.txt /
#RUN pip install --install-option="--prefix/install" -r /requirements.txt
RUN pip install -r requirements.txt

#FROM base

#COPY --from=builder /install /usr/local

RUN useradd --create-home appuser
WORKDIR /home/appuser
USER appuser

CMD [ "/usr/local/bin/openstack" ]
