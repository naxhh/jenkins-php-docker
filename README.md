Jenkins-PHP Docker
=========

Here is another Jenkins-php template docker.
With the difference that **this one works**.

Is based on the Jenkins official docker image.


Installing
----

Saddly you just can't run the docker image and start working. You need to clone this repo. This is because the Jenkins image sets a volume for the jenkins home folder. And you will need to add the php template to that folder.

- Clone this [repo] where you want. Like: /var/docker/jenkins-php-docker
- Or you can just copy the files from the [repo]
- - Give `rwx` rights for the `jenkins` user in that folder
- Run the image `docker run -d -P -v /var/docker/jenkins-php-docker:/var/jenkins_home:rw naxhh/jenkins-php-docker`

Docker exposes the port `8080` so just go to `http://<yourip>:8080`

Configure a project
-----------

Now you have a Jenkins working.
So you just need to configure your project. You can Follow the instructions in [jenkins-php] guide.

For a quick test you can set up a project for the [Money] project

- Create a new work
- Configure it as git and add the [Money] project clone url
- You can save the work without any modification
- Build the project and see the results.


Common problems or errors
---
- Remember to add privileges for the `jenkins` user.
- Job description by default have two images, you need to configure html rendering in the security options


[jenkins-php]:http://jenkins-php.org/integration.html
[Money]:https://github.com/sebastianbergmann/money
[repo]:https://github.com/naxhh/jenkins-php-docker.git