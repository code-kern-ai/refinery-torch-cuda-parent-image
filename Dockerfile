FROM nvidia/cuda:13.0.2-base-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    curl software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    python3.11 python3.11-distutils && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

COPY submodules/parent-images/requirements/torch-cuda-requirements.txt .

RUN pip3 install --no-cache-dir -r torch-cuda-requirements.txt