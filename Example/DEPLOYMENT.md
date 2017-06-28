cd ~/code/Pods/NAME
edit NAME.podspec
set the new version to 0.0.1
pod lib lint
git add -A && git commit -m "0.0.1"
git tag '0.0.1'
git push --tags
