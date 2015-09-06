FROM node:slim
MAINTAINER James Huang <cmao.huang@gmail.com>

RUN apt-get update && apt-get install -y git ssh-client rsync --no-install-recommends && rm -r /var/lib/apt/lists/*
RUN echo "Asia/Taipei" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
RUN npm install hexo-cli -g
RUN mkdir /hexo && cd /hexo && \
  npm install hexo-cli -g && \
  hexo init && npm install && \
  npm install hexo-deployer-git --save

WORKDIR /hexo

EXPOSE 4000
CMD ["hexo", "server"]
