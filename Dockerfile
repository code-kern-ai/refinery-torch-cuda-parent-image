FROM nvidia/cuda:11.6.0-base-ubuntu20.04

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    curl software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    python3.9 python3.9-distutils && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9

COPY submodules/parent-images/requirements/torch-cuda-requirements.txt .

RUN pip3 install --no-cache-dir -r torch-cuda-requirements.txt