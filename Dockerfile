FROM nvidia/cuda:13.0.2-base-ubuntu22.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    curl software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    python3.11 python3.11-distutils python3.11-venv && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv
ENV PATH="${VENV_PATH}/bin:${PATH}"

RUN python3.11 -m venv "${VENV_PATH}"

COPY submodules/parent-images/requirements/torch-cuda-requirements.txt .

RUN pip install --no-cache-dir -r torch-cuda-requirements.txt

FROM nvidia/cuda:13.0.2-base-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    python3.11 && \
    apt-get purge -y --auto-remove software-properties-common && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv
ENV PATH="${VENV_PATH}/bin:${PATH}"

COPY --from=builder --chown=65532:65532 ${VENV_PATH} ${VENV_PATH}

RUN ["/opt/venv/bin/python", "-c", "import torch; assert torch.version.cuda is not None, torch.__version__"]

USER 65532:65532
