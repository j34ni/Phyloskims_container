# First build stage
FROM ubuntu:22.04 as builder
LABEL dockerfile.version="1.0.2"
LABEL software="This is a modified version of the Phyloskims recipe by jeani@nris.no from 15th June 2024"

# Install org-annot
RUN apt update --fix-missing && apt upgrade -y && apt install -y build-essential git tcsh bash gawk parallel gettext zlib1g-dev libglib2.0-0
RUN git clone https://git.metabarcoding.org/org-asm/org-annotate.git /var/tmp/org-annotate && \
    cd /var/tmp/org-annotate/src && make
 
# Install Organelle Assembler
RUN apt update && apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt update && apt install -y python3.10 python3.10-dev python3.10-venv python3.10-distutils
RUN git clone https://git.metabarcoding.org/org-asm/org-asm.git /var/tmp/org-asm && \
    python3.10 -m venv /usr/local/org-assembler
SHELL ["/bin/bash", "-c"]
RUN source /usr/local/org-assembler/bin/activate && \
    pip install --upgrade pip && \
    pip install cython==0.29.28 sphinx==7.3.7 && \
    cd /var/tmp/org-asm && python setup.py install --no-serenity

# Install the final image grouping previously compiled software
FROM ubuntu:22.04 as phyloskims
RUN apt update --fix-missing && apt upgrade -y && apt install -y tcsh bash gawk parallel zlib1g libglib2.0-0 curl clustalo muscle cd-hit
COPY --from=builder /var/tmp/org-annotate /org-annotate
RUN rm -rf /org-annotate/src
COPY --from=builder /usr/local/org-assembler /org-assembler
COPY --from=builder /usr/local/org-assembler/bin/oa /bin
COPY --from=builder /usr/local/org-assembler/bin/orgasmi /bin
COPY organnot /bin
RUN  chmod +x /bin/organnot

# Recompile HMMER models
WORKDIR /org-annotate/data/its/ITSx_db/HMMs
RUN rm *.h3*
RUN for f in *.hmm ; do /org-annotate/ports/i386-linux/bin/hmmpress $f ; done
RUN mkdir -p /data
VOLUME /data
WORKDIR /data

