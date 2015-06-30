# Run it like
# sh -c '. ./lilybin-build.sh'
set -e

if git status --porcelain | grep -q '^M\|^ M'
then
	echo 'Tree not clean. Exiting.'
	exit 1
fi

rm -rf tmp
node make minified
mkdir -p tmp
cp -a build/minified/* tmp/
git checkout dist
rm -rf LICENSE web build
cp -a tmp/* .
rm -rf tmp

cd web
cleancss viewer.css    >viewer.min.css
mv       viewer.min.css viewer.css
sed -i '/^#/d;/^$/d' locale/en-US/viewer.properties
cd ..
git add -A LICENSE web build

git commit -m 'Regen'
git push
git reset --hard
git checkout master
