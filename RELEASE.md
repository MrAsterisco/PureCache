# Release

To release a new version of PureCache, follow these steps:

## Prerequisites

- PureCache follows [git-flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow). You should initiate a release only from a `hotfix/*` or `release/*` branch.
- If you made any changes to the documentation, you'll need [Jazzy](https://github.com/realm/jazzy).
- Make sure that the `PureCache` target builds and runs and that all tests are passing.

## Steps
- If you made any change that affects the documentation, run the following command in a Terminal in the PureCache root folder:

```bash
jazzy --clean
```

- Commit all your changes, push them and finish the `hotfix` or `release` branch using a git-flow compatible client. Some clients let you tag a release/hotfix immediately: make sure to follow the naming convention when creating your tag (eg. `v1.0.0`).
- Push all branches (you may have commits to push on either `develop`, `master` or `both`).
- Head to GitHub to [create a new release](https://github.com/MrAsterisco/PureCache/releases/new). If you haven't created a tag already, make sure to follow the naming convention describe two steps above.
- Insert the tag name and the version name (which is exactly the version number, without the initial "v").
- Detail the changes using three categories: "Added", "Improved" and "Fixed". *When referencing bugs, make sure to include a link to the GitHub issue.*.
- Once ready, publish the release.
