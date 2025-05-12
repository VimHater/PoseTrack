FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    libopencv-dev \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    git \
    nodejs \
    wget \
    && rm -rf /var/lib/apt/lists/*


RUN curl -o miniconda.sh -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash miniconda.sh -b -f -p /opt/miniconda \
    && rm miniconda.sh \
    pip install openmim

ENV PATH /opt/miniconda/bin:$PATH


RUN conda create -n aic24 python=3.9 pytorch torchvision pytorch-cuda=11.8 -c pytorch -c nvidia \
    && conda activate aic24 \
    && pip install -r requirements.txt \
    && pip install -e track/aic_cpp \
    && pip install openmim \
    && mim install "mmengine>=0.6.0" \
    && mim install "mmcv==2.0.1" \
    && mim install "mmpose>=1.1.0" \
    && pip3 install 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'

COPY . /app

CMD ["python", "bash"]
