An attempt to get `renv` to work with the cache mounts provided by docker buildkit.

[Link to renv documentation](https://rstudio.github.io/renv/articles/renv.html)

[Link to buildx project, which seems active location for this feature in docker](https://github.com/docker/buildx)

As I understand it, docker buildkit (aka buildx) has the concept of a "builder" which can either be the local docker or a docker container.

[This buildx issue](https://github.com/docker/buildx/issues/156) helped me to understand that cache is overloaded with two meanings in buildx land: the instruction cache and the mount cache.  The instruction cache is the docker caching of unchanged lines in Docker files (also used with multi-stage builds, buildx provides some additional capabilities I don't understand here).  The mount cache creates some sort of disk space (is it a docker volume? I dunno) which persists across build runs.  I don't entirely understand, but my working mental model is that there is a docker container with a docker volume in which building occurs.

`renv` provides [documentation for using renv with docker](https://rstudio.github.io/renv/articles/docker.html) and has two modes suggested. 

The first is at build time where renv is creating a new cache for that container alone, so that seems to operate just like having an install.R file and everything would be re-downloaded at container build-time. I can't see the advantage of that, perhaps just being able to use `renv::restore()` to read a `renv.lock` file?  
The second mode is having a renv cache on the host, and mounting the package cache at container run time (`docker run`), and using renv::restore() to copy the private library into the container. I think what we want is the second mode, but instead of building up the renv cache on the host, we do it in the buildx docker-container building, saving the cache in the cache mount.  So then we need to tell renv to use the mount cache.

Telling renv to use the mount cache seems to involve https://rstudio.github.io/renv/articles/docker.html
```
Sys.setenv(RENV_PATHS_CACHE = "~/path/to/cache")
```
