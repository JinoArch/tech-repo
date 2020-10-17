
#!/bin/sh

if [ "`git status -s`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "checkout to gh-pages"
git checkout origin/gh-pages
echo "branch status"
git branch
echo "checkout to master"
git checkout master
echo "gh-pages pointed to public directory"
git worktree add -B gh-pages public origin/gh-pages
echo "removing contents from public folder"
rm -rf public/*
echo "removed contents ...Now lets build it"
git submodule add -f https://github.com/zwbetz-gh/cupper-hugo-theme.git themes/cupper-hugo-theme
hugo
echo "adding the changes"
cd public && git add --all && git commit -m "latest_gh_pages" && cd ..
echo "Lets push this..."
git push origin gh-pages

