edit MemexSwiftSDK.podspec adn change set the new version to 1.2.3

git add -A && git commit -m '1.3.3'
git tag '1.3.3'
git push --tags


pod trunk push MemexSwiftSDK.podspec 
