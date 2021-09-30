FROM datadrone/deeplearn_pytorch:cuda-11.1-runtime

USER root

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-8-jre-headless ca-certificates-java && \
    rm -rf /var/lib/apt/lists/*

# setup scala
ENV SPARK_VERSION=3.1.2
ENV HADOOP_VERSION=3.2
ENV SCALA_VERSION=2.12.13
ENV SBT_VERSION=1.5.1
ENV SCALA_HOME=/usr/share/scala
ENV SPARK_HOME=/spark

RUN cd "/tmp" && \
    wget --no-verbose "https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    rm -rf "/tmp/"*

#Scala instalation
RUN export PATH="/usr/local/sbt/bin:$PATH" &&  apt -y update && \
    apt -y install ca-certificates wget tar && mkdir -p "/usr/local/sbt" && \
    wget -qO - --no-check-certificate "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | tar xz -C /usr/local/sbt --strip-components=1 && sbt sbtVersion

RUN wget --no-verbose https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark \
      && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

ENV SPARK_HOME='/home/jovyan/spark/'

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

## Need to add a conda env flag
# copy over the computer vision one
#
#RUN conda create --name spark --clone computer_vision
#python=3.8 pyspark==3.1.1 conda-pack

SHELL ["conda", "run", "-n", "computer_vision", "/bin/bash", "-c"]

RUN conda install -n computer_vision -c conda-forge -y pyspark==3.1.2 conda-pack 

# this isn't installing in the right folder
#RUN pip install pyspark==3.1.1 conda-pack

# lock in high versions
# main for Deep Learning packages and issues from that
RUN conda config --set channel_priority false


## from jupyter stacks
# Install pyarrow
RUN conda install -n computer_vision --quiet -y 'pyarrow' -c conda-forge && \
    conda clean --all -f -y

# R packages
RUN conda install -n computer_vision --quiet --yes -c conda-forge \
    'r-base' \
    'r-ggplot2' \
    'r-irkernel' \
    'r-rcurl' \
    'r-sparklyr' \
    && \
    conda clean --all -f -y

# Apache Toree kernel
# hadolint ignore=DL3013
# Toree doesn't support Spark 3 currently
#RUN pip install --no-cache-dir \
#    https://dist.apache.org/repos/dist/release/incubator/toree/0.3.0-incubating/toree-pip/toree-0.3.0.tar.gz \
#    && \
#    jupyter toree install --sys-prefix && \
#    rm -rf "/home/${NB_USER}/.local"

# Spylon-kernel
RUN conda install -n computer_vision --quiet --yes 'spylon-kernel=0.4*' -c conda-forge && \
    conda clean --all -f -y && \
    python -m spylon_kernel install --sys-prefix && \
    rm -rf "/home/${NB_USER}/.local"

# RAPIDS Version
ENV RAPIDS_VERSION=21.08.0
ENV CUDF_VERSION=21.08.2

RUN mkdir /opt/sparkRapidsPlugin
RUN wget -O /opt/sparkRapidsPlugin/rapids-4-spark_2.12-${RAPIDS_VERSION}.jar https://repo1.maven.org/maven2/com/nvidia/rapids-4-spark_2.12/${RAPIDS_VERSION}/rapids-4-spark_2.12-${RAPIDS_VERSION}.jar
RUN wget -O /opt/sparkRapidsPlugin/cudf-${CUDF_VERSION}-cuda11.jar https://repo1.maven.org/maven2/ai/rapids/cudf/${CUDF_VERSION}/cudf-${CUDF_VERSION}-cuda11.jar
RUN wget -O /opt/sparkRapidsPlugin/getGpusResources.sh https://raw.githubusercontent.com/apache/spark/master/examples/src/main/scripts/getGpusResources.sh

RUN chmod u+x /opt/sparkRapidsPlugin/getGpusResources.sh \
      && chmod u+x /opt/sparkRapidsPlugin/rapids-4-spark_2.12-${RAPIDS_VERSION}.jar \
      && chmod u+x /opt/sparkRapidsPlugin/cudf-${CUDF_VERSION}-cuda11.jar

RUN chown jovyan:1000 /opt/sparkRapidsPlugin/getGpusResources.sh \
      && chown jovyan:1000 /opt/sparkRapidsPlugin/rapids-4-spark_2.12-${RAPIDS_VERSION}.jar \
      && chown jovyan:1000 /opt/sparkRapidsPlugin/cudf-${CUDF_VERSION}-cuda11.jar

RUN chown jovyan:1000 -R /home/jovyan

USER $NB_USER

WORKDIR $HOME