FROM python:3
WORKDIR /data
COPY coronavirusco.json /data
COPY fromJSON2CSV.py /data
CMD [ "python" , "/data/fromJSON2CSV.py", "/data/coronavirusco.json" ]
#ENTRYPOINT [ "python" ]
