Docker: Consistent Builds
=========================

Do you work on multiple machines? Ever notice that the text gets rendered differently on different machines?
Or, has installing Ruby gems been a painful process for you in the past? Or, maybe you've got some local fonts you want to use.

Docker can help all those issues.

`Docker <https://www.docker.com>`_ is a *containerization* platform that allows you to spin up a virtual system. Like a lightweight alternative to virtual machines, Docker containers can lets us create a build environment. Software engineers use Docker for all kinds of things today. It's a great tool in your toolbox for all kinds of purposes.

.. note::

  Docker is great and magical when it works. When it doesn't, it can be painful. That said, it's getting better every release. If you ask for help, be sure to ask in a public forum where Docker experts can jump in and help.

Run Directly
------------

We have a pre-built Squib container on Dockerhub that has everything you need for a basic Squib installation. Once you install Docker, you can just run a Squib build directly without ever having to install Ruby+Squib locally. Here's how you run the command ``ruby deck.rb``.

Windows:

.. code-block:: sh

  $ docker run -it --rm -v "%cd%":/usr/src/app andymeneely/squib ruby deck.rb

Mac:

.. code-block:: sh

  $ docker run -it --rm -v "$PWD":/usr/src/app andymeneely/squib ruby deck.rb

The first time you run this command, Docker will go out to Dockerhub and pull the ``andymeneely/squib`` image to your machine. After that, the output will be from what ``ruby deck.rb`` was within the container. Here's what each option means:

* ``docker run`` - invoke Docker to run a particular command inside a container, in this case that's ``ruby deck.rb``, but it could be anything. (See `docs for docker run <https://docs.docker.com/engine/reference/run/>`_)
* ``--it`` - make it act like a regular command line program
* ``--rm`` - delete any modifications to the container after this run. This keeps the container clean so you get the same build every time
* ``-v "$PWD":/usr/src/app`` - map my current directory to the container's ``/usr/src/app`` directory. This allows Docker to be able to read ``deck.rb`` and write any outputs to your current directory.

Your Own Dockerfile
-------------------

Squib's Docker container is based on the standard Ruby container, which in turn is based on Debian Linux. So you're essentially running Squib inside Linux when you're running a Docker container.

The Squib container is pretty minimal, so you'll probably run into various things you want to add to your container. Here's a quick list from my experience:

* Extra gems like Guard, Launchy, etc.
* Obscure fonts
* Extra tools like wkhtmltopdf

A Dockerfile is the way you do this. Here's an example one:

.. code-block:: docker

  FROM andymeneely/squib:latest

  # If you add additional gems, this will run those installations there
  COPY Gemfile /usr/src/app/
  RUN gem install bundler && \
      cd /usr/src/app && \
      bundle install

  # Add in custom font files
  RUN mkdir ~/.fonts
  COPY fonts/*.otf /usr/share/fonts/
  COPY fonts/*.ttf /usr/share/fonts/
  RUN fc-cache -f -v /usr/share/fonts/

* ``FROM`` line - your Docker container is based on Squib's container.
* ``COPY Gemfile...`` lines  - copy your existing Gemfile into the container and install those gems with Bundler.
* ``RUN mkdir ~/.fonts`` lines - copy your font files from your existing directory to the container and register them in the container's OS.

You can also add calls to ``apt install`` to install other packages you might need.

To build your docker container, you'll need to **build** it and **tag** it. Like this:

.. code-block:: sh

  $ docker build . -t my-game-builder

And then to run it you use similar syntax as above:

.. code-block:: sh

  # Windows
  $ docker run -it --rm -v "%cd%":/usr/src/app andymeneely/squib ruby deck.rb
  # Mac
  $ docker run -it --rm -v "$PWD":/usr/src/app andymeneely/squib ruby deck.rb

Those run commands are kinda clunky. I like to put that long command in a shell file (Mac) or batch file (Windows). Like this:

.. code-block:: batch

  REM docker-run.bat
  REM note the %* syntax - that's "everything argument"
  docker run -it --rm -v "%cd%":/usr/src/app my-game-builder %*

.. code-block:: sh

  # docker-run.bat
  # note the $* syntax - that's "everything argument"
  docker run -it --rm -v "$PWD":/usr/src/app my-game-builder $*

And then to run those files it's a little easier to remember:

.. code-block:: sh

  # Windows
  $ ./docker-build.bat ruby deck.rb
  # Mac
  $ ./docker-build.sh ruby deck.rb
