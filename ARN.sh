#!/bin/bash
cd /home/alex/AuReiNand #Switching to the repo's directory
mkdir source #Creates the source directory in case it's not present
cd source/ #Switches to the source directory
git clone --recursive https://github.com/AuroraWright/AuReiNand.git #Clones ARN repo
cd ./AuReiNand #Switch to ARN repo
commit=$(git rev-parse --short HEAD) #Get latest commit hash
message=$(git log -1 --pretty=%B | head -n1)
if [ $commit = $(cat ../../lastCommit) ] #Check to see if there's a new commit
then #If there is...
	cd ../ #Clean the directory
	rm -rf AuReiNand #Clean the directory
	echo No updates found! #Echo debug message (The results of crontabs are mailed to you)
	exit #Quit
fi #Will only continue if there's a new commit
echo $commit > ../../lastCommit
make #Build ARN
zip -r "ARN-$(date +"%Y-%m-%d").zip" ./out #Zip the release with the current date
rm -rf ./out #Delete the release folder
mv ARN*.zip ../../builds #Move the zipped release to the builds directory
cd /home/alex/AuReiNand/ #switch to the root of the directory
cat current.html > /tmp/tmpcur #Copy the current list of table elements
echo "<tr><td><p><a href="/builds/ARN-$(date +"%Y-%m-%d").zip">ARN-$(date +"%Y-%m-%d").zip</a></p></td><td>${commit}</td><td>$(date +"%Y-%m-%d")</td><td>${message}</td></tr>" > current.html #Add a new table data element to the top of the list
cat /tmp/tmpcur >> current.html #Add the old table elements to the bottom of the list
cat top.html > index.html #Copy the top half of the webpage to index
cat current.html >> index.html #Copy the list of table elements to the index
cat bottom.html >> index.html #Copy the bottom half of the webpage to index
git add /home/alex/AuReiNand/builds/* #Add all new build files
git commit -a -m "Updated builds - Automated Commit Message" #Commit the new build and index
git push #Push to repo
rm -rf /home/alex/AuReiNand/source/AuReiNand #Delete the ARN repo to clean up
