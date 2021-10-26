---
name: Release TODO list
about: Use this checklist when we release
title: Release v0.XYZ
labels: release
assignees: andymeneely
---

Be sure to remember to do the following for releases.

 - [ ] CHANGELOG is written for all new changes
 - [ ] README is updated
 - [ ] Samples are updated
 - [ ] Are all the dependencies up to date?
 - [ ] Check `sample_regression_spec.rb` regression tests are all enabled (i.e. `overwrite_sample` is commented out)
 - [ ] Bump version.rb
 - [ ] Bump docs/conf.py versions
 - [ ] Do a full rake locally
 - [ ] `rake sanity`, and check visually
 - [ ] GitHub Actions is passing on dev branch
 - [ ] Merge master branch
 - [ ] Merge release branch
 - [ ] Push master and release branches
 - [ ] Create GitHub release tag
 - [ ] `gem push pkg/squib-x.y.z.gem`
 - [ ] Github milestone closed
 - [ ] Activate version on squib.readthedocs.org (Versions)
 - [ ] Set default version on squib.readthedocs.org (Advanced Settings)
 - [ ] Bump version.rb to the next alpha
 - [ ] Publish on BoardGameGeek thread
 - [ ] Anything else to add to this checklist?

 # Docker
 - [ ] Check Dockerfile for updates
 - [ ] `docker build .`
 - [ ] `docker tag XYZ andymeneely/squib:latest`
 - [ ] `docker tag XYZ andymeneely/squib:version-0.XYZ.0`
 - [ ] `docker push andymeneely/squib:latest`
 - [ ] `docker push andymeneely/squib:version-0.XYZ.0`
 - [ ] Check Docker build on Dockerhub: https://hub.docker.com/repository/docker/andymeneely/squib
 - [ ] Check Docker docker pull: docker pull andymeneely/squib:latest
 - [ ] Check Docker build locally in samples:
  * Delete `samples/_output/basic_*.png`
  * `docker run --rm -v c:\code\squib\samples:/usr/src/app -w /usr/src/app andymeneely/squib:latest ruby basic.rb`
  * Check that the files were made
 - [ ] Anything else to add to this checklist?