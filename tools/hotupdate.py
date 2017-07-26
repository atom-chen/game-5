# coding:utf-8
import os,shutil,filecmp,hashlib,json


QUICK_V3_ROOT 	= os.getenv("QUICK_V3_ROOT")

BACKUP_PATH 	= os.path.join(os.getcwd(),"../backup")
PROJECT_PATH	= os.path.join(os.getcwd(),"../")
SVN_PATH		= os.path.join(os.getcwd(),"../svn")
ONLINE_VERSION	= "1.0.0"
OUT_VERSION		= "1.0.1"
BUILD_NUM		= None
PROJECT_NAME	= "phz"


def backup():
	if OUT_VERSION == None:
		print "havn't out version"
		return 

	dst = os.path.join(BACKUP_PATH,"{0}_{1}".format(PROJECT_NAME,OUT_VERSION))
	if os.path.exists(dst):
		shutil.rmtree(dst)
	os.mkdir(dst)

	shutil.copytree(os.path.join(PROJECT_PATH,"src"),os.path.join(dst,"src"))
	shutil.copytree(os.path.join(PROJECT_PATH,"res"),os.path.join(dst,"res"))

def md5(path):
	m0=hashlib.md5()
	m0.update(path)
	return (m0.hexdigest(),os.path.getsize(path))

def getDiff(oldversion,newversion):
	if oldversion == None:
		return None
	
	
	files = {}
	root = os.path.join(BACKUP_PATH,"{0}_{1}/res".format(PROJECT_NAME,newversion)).replace("\\","/")
	if root[-1] != "/":
		root += "/"
	size = 0
	count = 0
	for parent,dirnames,filenames in os.walk(root):
		for filename in filenames:                        #输出文件信息
			if filename != ".DS_Store":
				fullpath = os.path.join(parent,filename).replace("\\","/")
				relative = fullpath.replace(root,"")
				
				info = md5(fullpath)
				files[relative] = info
				count += 1
				size += info[1]

	conf = {"verion":newversion,"files":files,"size":size,"count":count}


	with open(os.path.join(SVN_PATH,"{0}.package".format(PROJECT_NAME)),"w+") as f:
		f.write(json.dumps(conf))


def upload():
	pass


def main():
	backup()
	diff = getDiff(ONLINE_VERSION,OUT_VERSION)

if __name__ == "__main__":
	main()