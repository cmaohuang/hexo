# I'm using hexo in docker with these versions

* git
* docker 1.8.2
* docker-compose 1.4.2
* hexo@3.1.1
* hexo-deployer-git@0.0.4

## Init your hexo blog

Use docker-compose to build an image which named hexo_hexo

    docker-compose build

Copy hexo's config file, source/ themes/ folder to host, and we could use our favorite editor to edit these files directly on our host not in the container

    # create a temporary container that we could copy files to host
    docker run -d --name=hexo hexo_hexo sleep 5 ;\
    docker cp hexo:/hexo/source . ;\
    docker cp hexo:/hexo/themes . ;\
    docker cp hexo:/hexo/_config.yml .

    # delete temporary container
    docker rm hexo

docker-compose will create a container named hexo_hexo_1

    docker-compose up -d

Now you can see your blog on http://DOCKER-MACHINE-IP:4000/

Create your first blog post named "Hello Hexo"

    docker exec hexo_hexo_1 hexo new "Hello Hexo"

## Deploy your blog to GitHub

Edit _config.yml, change YOUR_GITHUB_ID to your id

    deploy:
      type: git
      repo: git@github.com:YOUR_GITHUB_ID/YOUR_GITHUB_ID.github.io.git
      branch: master

Copy your key into container, not a secure way but an easy way, docker still try to figure out [best practices](https://github.com/docker/docker/issues/13490)

    docker exec hexo_hexo_1 bash -c "mkdir /root/.ssh; chmod 700 /root/.ssh"
    docker cp ~/.ssh/id_rsa hexo_hexo_1:/root/.ssh/id_rsa

Accept GitHub HostKey and setup user.name/user.email for git commit

    # You have to do this once
    docker exec -it hexo_hexo_1 bash
    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
    hexo d -g

    # input yes will create .ssh/know_hosts file
    The authenticity of host 'github.com (192.30.252.129)' can't be established.
    RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48.
    Are you sure you want to continue connecting (yes/no)?

    # Sometimes you'll get "Host key verification failed" as below due to you didn't accept GitHub HostKey
    Host key verification failed.
    fatal: Could not read from remote repository.

    # Now you could deploy your blog on the host
    docker exec hexo_hexo_1 hexo d -g

Visit your GitHub Pages https://YOUR_GITHUB_ID.github.io/

## [theme](https://hexo.io/themes/)

[minos](https://github.com/ppoffice/hexo-theme-minos)

    git clone https://github.com/ppoffice/hexo-theme-minos.git themes/minos

edit _config.yml

    theme: minos

Move themes/minos/_config.yml.example to themes/minos/_config.yml

    mv themes/minos/_config.yml.example themes/minos/_config.yml

Enable custom categories page and tags page

    cp -a themes/minos/_source/* source/

Restart your container

    docker-compose restart

## use Disqus for managing comments

Edit _config.yml

    disqus_shortname: YOUR_DISQUS_SHORTNAME

## Reference

* https://hub.docker.com/r/tommylau/hexo/~/dockerfile/
* https://gist.github.com/JamesPan/23528eeaaaa4120ef637
* https://tommy.net.cn/2015/08/05/upgrade-hexo-from-2-8-3-to-3-1-1/
* http://blog.jamespan.me/2015/04/17/hexo-in-the-docker/
