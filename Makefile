YARN_LOCK_MANIFEST := $(abspath node_modules/yarn.lock)
PODFILE_LOCK_MANIFEST := $(abspath ios/Pods/Manifest.lock)

all:
	$(error No default target deinfed)

$(YARN_LOCK_MANIFEST): package.json yarn.lock
	yarn install && cp yarn.lock $(YARN_LOCK_MANIFEST)

.PHONY: node
node: $(YARN_LOCK_MANIFEST)

$(PODFILE_LOCK_MANIFEST): $(YARN_LOCK_MANIFEST) ios/Podfile ios/Podfile.lock
	cd ios && pod install && touch $(PODFILE_LOCK_MANIFEST)

.PHONY: pods
pods: $(PODFILE_LOCK_MANIFEST)

.PHONY: deps
deps: node pods
