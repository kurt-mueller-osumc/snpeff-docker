# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.183.0/containers/python-3-miniconda/.devcontainer/base.Dockerfile
FROM mcr.microsoft.com/vscode/devcontainers/miniconda:0-3

# [Option] Install Node.js
ARG INSTALL_NODE="false"
ARG NODE_VERSION="lts/*"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

RUN apt-get update && \
    apt-get -y install build-essential

RUN chown -R vscode:vscode /opt/conda

# Copy environment.yml (if found) to a temp location so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
COPY environment.yml* .devcontainer/noop.txt /tmp/conda-tmp/

USER vscode

RUN conda install -n base -c conda-forge mamba

# RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then /opt/conda/bin/conda env update -n demo-env -f /tmp/conda-tmp/environment.yml; fi
RUN conda env create -f /tmp/conda-tmp/environment.yml
RUN echo "source activate $(head -1 /tmp/conda-tmp/environment.yml | cut -d' ' -f2)" > ~/.bashrc
RUN PATH=/opt/conda/envs/$CONDA_PREFIX/bin:$PATH

# [Optional] Uncomment to install a different version of Python than the default
# RUN conda install -y python=3.6 \
#     && pip install --no-cache-dir pipx \
#     && pipx reinstall-all

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>