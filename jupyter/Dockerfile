FROM cuckoohello/pytorch
ENV USER jupyter
ENV UID 1000

RUN apt-get update && apt-get install -y gosu && apt-get clean && \
    pip install jupyter
COPY entrypoint.sh /
VOLUME /workspace

ENTRYPOINT ["/entrypoint.sh"]
CMD ["notebook", "--ip=0.0.0.0"]
