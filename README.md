An attempt to get `renv` to work with the cache mounts provided by docker buildkit.

[Link to renv documentation](https://rstudio.github.io/renv/articles/renv.html)

[Link to buildx project, which seems active location for this feature in docker](https://github.com/docker/buildx)

As I understand it, docker buildkit (aka buildx) has the concept of a "builder" which can either be the local docker or a docker container. One can specify "cachemounts" using 

```
RUN --mount=type=cache,target=/path/to/cache/mount 
```

These are special volume-like docker objects (called `exec.cachemount`) which are attached to the docker builder when a RUN command with the ``--mount=type,cache`` flag is provided.

[This buildx issue](https://github.com/docker/buildx/issues/156) helped me to understand that cache is overloaded with two meanings in buildx land: the instruction cache and the mount cache.  The instruction cache is the docker caching of unchanged lines in Docker files (also used with multi-stage builds, buildx provides some additional capabilities I don't understand here).  The mount cache creates some sort of disk space (is it a docker volume? I dunno) which persists across build runs.  I don't entirely understand, but my working mental model is that there is a docker container with a docker volume in which building occurs.

`renv` provides [documentation for using renv with docker](https://rstudio.github.io/renv/articles/docker.html) and has two modes suggested: 

The first is at build time where renv is creating a new cache for that container alone, so that seems to operate just like having an install.R file and everything would be re-downloaded at container build-time. I can't see the advantage of that, perhaps just being able to use `renv::restore()` to read a `renv.lock` file?  
The second mode is having a renv cache on the host, and mounting the package cache at container run time (`docker run`), and using renv::restore() to copy the private library into the container. I think what we want is the second mode, but instead of building up the renv cache on the host, we do it in the buildx docker-container building, saving the cache in the cache mount.  So then we need to tell renv to use the mount cache.

In this repo the Dockerfile uses the buildx cache so that a file system `/buildx_cache/renv_cache/' is attached to the docker build environment. Previously downloaded and built r packages are located there. `renv` is activated, and any new r packages specified in install.R are installed to that cache, and symlinked in the project directory. Finally, renv provides the `renv::isolate` command which converts the symlinks to files, leaving the project directory fully operational.  That is crucial because the container then does not need access to the `renv` central cache location at run time.

Docker layer caching still works, but now if a package is added to `install.R` just that new package is downloaded and installed. If an earlier RUN command (say a new Debian package in `apt.txt`) changes, then the Docker layer cache is invalidated but the unchanged R packages do not re-download and install, they just check the downloads and copy to the cache.


The Dockerfile manages this by telling renv to use the mount cache requires setting an R environment variable: https://rstudio.github.io/renv/reference/paths.html
```
Sys.setenv(RENV_PATHS_ROOT = "/buildx_cache/renv_cache")
```
