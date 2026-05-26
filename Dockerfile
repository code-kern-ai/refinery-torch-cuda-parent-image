ARG DHI_PYTHON_BUILD=dhi.io/python:3.11.11-debian12-dev
ARG DHI_PYTHON_RUNTIME=dhi.io/python:3.11.11-debian12

FROM ${DHI_PYTHON_BUILD} AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv
ENV PATH="${VENV_PATH}/bin:${PATH}"

RUN python -m venv "${VENV_PATH}"

COPY submodules/parent-images/requirements/torch-cuda-requirements.txt .

RUN pip install --no-cache-dir -r torch-cuda-requirements.txt

FROM ${DHI_PYTHON_RUNTIME}

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV VENV_PATH=/opt/venv
ENV PATH="${VENV_PATH}/bin:${PATH}"

COPY --from=builder --chown=65532:65532 ${VENV_PATH} ${VENV_PATH}

USER 65532:65532
