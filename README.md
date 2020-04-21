# Git Deploy Github Action

This action takes a directories, copies it over to a repo, and deployed the repo
with the committed changes. This action was written to support a workflow for deploying changes
to a github pages repo from another repo that contains the source files.

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

## Example Usage

```yaml
name: deploy changes to a repo
uses: sugatpoudel/git-deploy@v0.1
with:
  changes: public
  repository: git@github.com:<user>/<repo>.git
  ssh_key: ${{ secrets.REPO_DEPLOY_KEY }}
  name: user
  email: user@email.com
```
