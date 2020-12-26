YARN_LOCK_MANIFEST := $(abspath node_modules/yarn.lock)
PODFILE_LOCK_MANIFEST := $(abspath ios/Pods/Manifest.lock)
GEMS_MANIFEST := $(abspath vendor/Gemfile.lock)

all:
	$(error No default target deinfed)

.PHONY: bundle-config
bundle-config:
	@bundle config --local path vendor


$(GEMS_MANIFEST): Gemfile Gemfile.lock | bundle-config 
	bundle install && cp Gemfile.lock $(GEMS_MANIFEST)

.PHONY: gems
gems: $(GEMS_MANIFEST)

.PHONY: clean/gems
clean/gems:
	rm -rf .bundle vendor

$(YARN_LOCK_MANIFEST): package.json yarn.lock
	yarn install && cp yarn.lock $(YARN_LOCK_MANIFEST)

.PHONY: node
node: $(YARN_LOCK_MANIFEST)

.PHONY: clean/node
clean/node:
	rm -rf node_modules

$(PODFILE_LOCK_MANIFEST): $(YARN_LOCK_MANIFEST) $(GEMS_MANIFEST) ios/Podfile ios/Podfile.lock
	cd ios && bundle exec pod install --repo-update && touch $(PODFILE_LOCK_MANIFEST)

.PHONY: pods
pods: $(PODFILE_LOCK_MANIFEST)

.PHONY: clean/pods
clean/pods:
	rm -rf ios/Pods

.PHONY: deps
deps: node pods gems

.PHONY: clean
clean: clean/gems clean/node clean/pods
