.PHONY: bump-major bump-minor bump-patch

bump-major:
	@./tools/bump-version.sh -x

bump-minor:
	@./tools/bump-version.sh -m

bump-patch:
	@./tools/bump-version.sh -p
