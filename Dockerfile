ARG DHI_CUDA_BUILD=dhi.io/nvidia-cuda:12.2.2-base-ubuntu22.04-dev
ARG DHI_CUDA_RUNTIME=dhi.io/nvidia-cuda:12.2.2-base-ubuntu22.04

FROM ${DHI_CUDA_BUILD} AS cuda-builder

USER root

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    curl software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    python3.11 python3.11-venv python3.11-distutils && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv
ENV PATH="${VENV_PATH}/bin:${PATH}"

RUN python3.11 -m venv "${VENV_PATH}" && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | "${VENV_PATH}/bin/python"

COPY submodules/parent-images/requirements/torch-cuda-requirements.txt .

RUN pip3 install --no-cache-dir -r torch-cuda-requirements.txt

FROM ${DHI_CUDA_RUNTIME}

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv
ENV PATH="${VENV_PATH}/bin:${PATH}"

COPY --from=cuda-builder --chown=65532:65532 ${VENV_PATH} ${VENV_PATH}

USER 65532:65532
