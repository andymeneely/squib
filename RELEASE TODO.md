Be sure to remember to do the following for releases. (Copy into a GitHub issue)

 - [ ] CHANGELOG is written for all new changes
 - [ ] README is updated
 - [ ] Samples are updated
 - [ ] Check `sample_regression_spec.rb` regression tests are all enabled (i.e. `overwrite_sample` is commented out)
 - [ ] Bump version.rb
 - [ ] Bump docs/conf.py versions
 - [ ] Do a full rake locally
 - [ ] `rake sanity`, and check visually
 - [ ] Travis is passing on dev branch
 - [ ] Merge master branch
 - [ ] Merge release branch
 - [ ] Push master and release branches
 - [ ] Create GitHub release tag
 - [ ] `gem push pkg/squib-x.y.z.gem`
 - [ ] Github milestone closed
 - [ ] Activate version on squib.readthedocs.org
 - [ ] Bump version.rb to the next alpha
 - [ ] Publish on BoardGameGeek thread
