#!/user/bin/python

import sys
import re
import urllib2
import urllib, sgmllib
from parser import * 
import sets
# read configuration from file
f = open('configure', 'r')
params = {}
for line in f:
	[name, opr, value] = line.strip().partition("=")
	if len(value)==0:
		print "configuration error\n"
		sys.exit()
	params[name] = value	

# start fetching url
response = urllib2.urlopen(params['start_url'])
html = response.read()

# Try and process the page.
# The class should have been defined first, remember.
myparser = MyParser()
myparser.parse(html)

# Get the hyperlinks.
links = sets.Set(myparser.get_hyperlinks())
links_to_use = []
for link in links:
	matchObj = re.search( params['target_url_pattern'], link, re.M|re.I)
	if matchObj:
		links_to_use.append(link)

# Try to get all the resources need
for link in links_to_use:
	response = urllib2.urlopen(link)
	html = response.read()
	myparser = MyParser()
	myparser.parse(html)
	resource_links = sets.Set(myparser.get_resources())
	for resource_link in resource_links:
		matchObj = re.search( params['resource_pattern'], resource_link, re.M|re.I)
		if matchObj:
			print resource_link
