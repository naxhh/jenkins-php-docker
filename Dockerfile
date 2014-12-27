# Official images are cool.
FROM jenkins
MAINTAINER Ignacio Tolstoy <arkantos798@gmail.com>

# Jenkins is using jenkins user, we need root to install things.
USER root

RUN mkdir -p /tmp/WEB-INF/plugins

# Install required jenkins plugins.
RUN curl -L https://updates.jenkins-ci.org/latest/checkstyle.hpi -o /tmp/WEB-INF/plugins/checkstyle.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/cloverphp.hpi -o /tmp/WEB-INF/plugins/cloverphp.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/crap4j.hpi -o /tmp/WEB-INF/plugins/crap4j.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/dry.hpi -o /tmp/WEB-INF/plugins/dry.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/htmlpublisher.hpi -o /tmp/WEB-INF/plugins/htmlpublisher.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/jdepend.hpi -o /tmp/WEB-INF/plugins/jdepend.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/plot.hpi -o /tmp/WEB-INF/plugins/plot.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/pmd.hpi -o /tmp/WEB-INF/plugins/pmd.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/violations.hpi -o /tmp/WEB-INF/plugins/violations.hpi
RUN curl -L https://updates.jenkins-ci.org/latest/xunit.hpi -o /tmp/WEB-INF/plugins/xunit.hpi

# Install Docker plugin for docker deploy.
RUN curl -L https://updates.jenkins-ci.org/latest/docker-build-publish.hpi -o /tmp/WEB-INF/plugins/docker-build-publish.hpi

# Add all to the war file.
RUN cd /tmp; \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/checkstyle.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/cloverphp.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/crap4j.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/dry.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/htmlpublisher.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/jdepend.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/plot.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/pmd.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/violations.hpi && \
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/xunit.hpi
  zip --grow /usr/share/jenkins/jenkins.war WEB-INF/plugins/docker-build-publish.hpi

# Install php packages.
RUN apt-get update
RUN apt-get -y -f install php5-cli php5-dev php5-curl curl php-pear ant

# Install docker
RUN apt-get -y -f install docker.io

# Create a jenkins "HOME" for composer files.
RUN mkdir /home/jenkins
RUN chown jenkins:jenkins /home/jenkins

USER jenkins

#### This don't work as $JENKINS_HOME is a volume ####
# Install php template.
#RUN mkdir "$JENKINS_HOME/jobs/php-template"
#RUN curl -L https://raw.github.com/sebastianbergmann/php-jenkins-template/master/config.xml -o "$JENKINS_HOME/jobs/php-template/config.xml"
####                sad panda is sad              ####


# Install composer, yes we can't install it in $JENKINS_HOME :(
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/home/jenkins

# Install required php tools.
RUN /home/jenkins/composer.phar --working-dir="/home/jenkins" -n require phing/phing:2.6.1 notfloran/phing-composer-security-checker:~1.0 \
    phploc/phploc:* phpunit/phpunit:~4.1 pdepend/pdepend:~1.1 phpmd/phpmd:~1.4 sebastian/phpcpd:* \
    squizlabs/php_codesniffer:* mayflower/php-codebrowser:~1.1
#RUN echo "export PATH=$PATH:/home/jenkins/.composer/vendor/bin" >> $JENKINS_HOME/.bashrc # Keep dreaming!

USER root
RUN apt-get clean -y

# Go back to jenkins user.
USER jenkins
