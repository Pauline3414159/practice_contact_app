# Shared Repository Process

Clone the repository to begin

## Short Version

When you want to work on something, make a new branch for your feature. Once you've implemented your thing, commit it to that local branch. Then, push that branch to the GitHub remote and make a pull request.

## Long Version
Create branch (based on feature/issue??)
```
git branch feature_one
```

Checkout the branch to work on feature
```
git checkout feature_one
```

Do your awesome work!
When you think it's complete

```
git add feature_one
git commit -m"nice description of what I did"
```

To push it to the remote repository as a non-master branch, run
```
git push origin feature_one
```
This will, by default, create a feature_one  branch on the origin repository, ie. the repository on GitHub.

Pushes to branches will accumulate commits.

## Git fetch / Git merge / Git Pull
