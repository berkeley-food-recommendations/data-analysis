import re
import nltk
from nltk import ngrams

# try out ngrams form nltk

class PhrasesModel:
	def __init__(self,phrasesFile):
		pF = open(phrasesFile,'r')
		self.phrases = [phrase.strip().lower() for phrase in pF.readlines()]
		self.regexDict = self._getRegexDict()
	
	def _getRegexDict(self,):
		regexDict={}
		for phrase in self.phrases:
			sPhrase = phrase.replace("'","('|)").split(" ")
			ngs = []
			for i in range(len(sPhrase)):
				ngs.extend(ngrams(sPhrase,i+1))
			#print sPhrase
			#print ngs
			ngsRegexes = [re.compile("(\s+|)".join(ng)) for ng in ngs] 
			#wordsRegexes = [re.compile(p) for p in  phrase.replace("'","('|)").split(" ")]
			regexDict[phrase]=ngsRegexes	
		return regexDict

	def getMatchesFor(self,query,num=4):
		matches = []	
		for phrase in self.phrases:
			m = self._matchCount(query,phrase)
			if m:
				matches.append(m)
		if matches==[]:
			return None
		matches.sort(key=lambda m : m[1])
		reversed=matches[::-1]
		return reversed[:num]
			

	def _matchCount(self,query,phrase):
		ct=0.0
		regexes = self.regexDict[phrase]
		for regex in regexes:
			if regex.search(query):
				ct=ct+1.0
		if ct==0.0:
			return None
		return (phrase,ct/len(regexes))
