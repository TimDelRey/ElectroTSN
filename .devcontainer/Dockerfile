FROM mcr.microsoft.com/devcontainers/ruby:1-3.3-bullseye

# [Optional] Install OS packages.
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        tar \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV GO_VERSION=1.25.1
ENV GO_ARCH=arm64

RUN wget https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz -O /tmp/go.tar.gz \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

ENV PATH=/usr/local/go/bin:$PATH

# Install Rails
RUN su vscode -c "gem install rails webdrivers"
RUN su vscode -c "/usr/local/rvm/bin/rvm fix-permissions"

WORKDIR /workspaces
COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains 
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"

# [Optional] Uncomment this line to install additional gems.
# RUN su vscode -c "gem install <your-gem-names-here>"

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
