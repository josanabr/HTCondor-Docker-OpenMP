FROM ubuntu
WORKDIR /run
RUN apt update && apt -y install build-essential
COPY fibonacci /run/fibonacci
COPY time_fibo.sh /run/time_fibo.sh
CMD ["./time_fibo.sh"]
ENTRYPOINT ["/bin/bash"]
