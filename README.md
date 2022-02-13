# Git Deploy Github Action

![check action](https://github.com/tagus/git-deploy/workflows/check%20action/badge.svg?branch=master)

This action takes a directory, copies it over to an existing repo, and deploys (pushes) the repo
with the committed changes. This action was written to support a workflow for deploying changes
to a github pages repo from another repo that contains the source files.

Note that the commit message for each deployment is statically defined as the following:

```
auto-update - <year-month-day hour:minute:second>
```

## Inputs

### `repository`

**Required** The SSH url of the target repository.

### `changes`

**Required** The path to the directory containing the changes to deploy. Since
the current workspace will be mounted as the action root. A relative path is all
you need for `git-deploy` to pick up the `changed` directory.

### `ssh_key`

**Required** The SSH key used to push to the registry. The SSH key is
configured with the local git config, enabling this action to run
authenticated git commands.

Follow [these](https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys)
instructions to create and integrate a deploy key with the target repo.

### `ssh_known_hosts`

The known hosts to run SSH commands against. By default, `github.com` is used
as the known host.

### `name`

**Required** A name for the git user create the git commit.

### `email`

**Required** An email for the git user creating the git commit.

### `branch`

The branch name of the remote repo to push to. By default, `master` is used.
Note that this branch must already exist in the remote repo.

### `message`

The commit message used for the commit. By default, a standard format is used
e.g. `auto-deploy: 2020-10-03 16:54:59`.

### `clean_repo`

A boolean that specifies whether to remove all files in repository that are not present
in the specified `changes` directory.

## Example Usage

```yaml
name: deploy changes to a repo
uses: tagus/git-deploy@v0.3.2
with:
  changes: public
  repository: git@github.com:<user>/<repo>.git
  ssh_key: ${{ secrets.REPO_DEPLOY_KEY }}
  name: user
  email: user@email.com
  clean_repo: true
```
