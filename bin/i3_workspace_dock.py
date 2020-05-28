'''Tool to save and restore i3 workspace mappings when docking with external monitors'''

import i3, pickle, os, sys

PATH = '/home/dan/.i3/workspace_save'
LAPTOP = 'eDP1'

def undock():
	workspaces = i3.get_workspaces()
	# check path
	if not os.path.exists(os.path.dirname(PATH)):
		os.mkdir(os.path.dirname(PATH))
	# pickle workspaces
	with open(PATH,'wb') as savefile:
		pickle.dump(workspaces,savefile)
	#move all workspaces to laptop
	for workspace in workspaces:
		i3.command('[workspace={}] move workspace to output {}'.format(workspace['name'],LAPTOP)) 

def dock():
	#check for pickle
	if os.path.exists(PATH):
		with open(PATH,'rb') as savefile:
			workspace_mapping = pickle.load(savefile)
	#restore pickled active workspaces
		for workspace in workspace_mapping:
			i3.command('[workspace={}] move workspace to output {}'.format(workspace['name'],workspace['output']))
	else:
		#TODO: use default workspace mapping
		pass

if __name__ == '__main__':
	if sys.argv[1] == 'dock':
		dock()
	elif sys.argv[1] == 'undock':
		undock()
	else:
		print('ya fucked up')
