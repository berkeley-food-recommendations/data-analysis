from PhrasesModel import *

if __name__=="__main__":
	pModel = PhrasesModel('rest-berk-names.tsv')
	print pModel.getMatchesFor("I like to go to lavalspizaa to eat")
