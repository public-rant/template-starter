# FeatureName.guid.spec.ts
# | map({ guid: .[0].guid, id: .[0].id, title: .[0].title, tags: [.[].tags], time: .[0].time, url: .[0].url})'
# playwright.config.ts.json: bookmarks_from_sql.py
# 	@python $< | duckcli -D ':memory' -e "select id,title,guid,unnest(tags) as tags,last_modified as time,url from read_json('/dev/stdin')" --csv | mlr --icsv --ojson cat | jq -s 'group_by(.id) | map({ name: .[0].title, dependencies: [.[0].id], testMatch: [.[] | "*.\(.guid).spec.ts"] })'

# - [ ] I restore a snapshot by applying a devcontainer template and include optional files
# snapshots are also restored on container start (latest src tree)
# ~~each release needs to create a snapshot of the current state~~
# - [ ] additional snapshots are normalised bookmarks_from_sql, via pkl snapshots.pkl
# - [ ] projects are a tree representing dependencies and test match
# (there is room for hledger maybe, forecasting from bookmark timestamps and cookies)
# devcontainer.json (mounts,and optional files)
# There are common files based on actors or projects MASERIPODSPT mounted at points declared by pkl logic
# JSON representing the test/story are mounted relative to common file so they can be loaded
# results are visisble in playwright test --list which is run when building container for release. examples given in TDD
# The common file templates Actor.spec.ts/Actor.stories.ts, can be modified in a container and snapshotted which feeds into git butler esque UI
# snapshots created by kill sigterm on container shutdown
# A running container can deploy directly to prod or stag via netlify. Built containers can do something else. whatever from ghcr
# Pro/Free chromium stroybook/playwright.
# Passwords via GITHUB_SECRETS
# Room for improvement with serverless deploy or collab via chromatic (not devcontainer)

# config: ./src/color/.devcontainer/devcontainer.json


# ./src/color/.devcontainer/devcontainer.json:
# 	./src/color/pkl eval $@.pkl
	

# snapshots.json:
# 	restic 

# playwright.config.ts.json:
# 	echo $(actor) | fx 

all:
	@zx README.md