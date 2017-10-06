edit MemexSwiftSDK.podspec adn change set the new version to 1.1.9
pod lib lint

git add -A && git commit -m '1.1.9'
git tag '0.0.1'
git push --tags


pod trunk push MemexSwiftSDK.podspec 
