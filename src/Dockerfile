FROM anaconda/miniconda:latest
WORKDIR /data

# Copy Conda environment definition
COPY environment.yml .

# Accept Anaconda Terms of Service for the specified channels
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

RUN conda env create -f environment.yml && \
    conda clean -afy

# Create Conda environment
RUN conda env remove -n gatk-pipeline -y || true && \
    conda env create -f environment.yml && \
    conda clean -afy

# Activate environment for subsequent commands
ENV PATH=/opt/miniconda3/envs/gatk-pipeline/bin:${PATH}

# Disable automatic activation of the base environment
RUN conda config --system --set auto_activate_base false

# Automatically activate gatk-pipeline in interactive Bash shells
RUN echo "source /opt/miniconda3/etc/profile.d/conda.sh && conda activate gatk-pipeline" >> ~/.bashrc

# Copy project scripts into the image
COPY scripts/ /data/scripts/

# Make shell scripts executable
RUN chmod +x /data/scripts/*

# Start an interactive shell by default
CMD ["/bin/bash"]