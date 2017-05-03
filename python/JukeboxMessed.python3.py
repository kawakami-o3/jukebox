#!/usr/bin/python
# -*- coding: utf-8 -*-
import random

class JukeboxMessed:

	def __init__(self, artists, cdNames, songNames, songLengthList):
		self.artists = artists
		self.cdNames = cdNames
		self.songNames = songNames
		self.songLengthList = songLengthList

		self.playlist = []
		self.selector = "normal"


	def activateAuto(self, commands):
		for command in commands:
			words = command.split()
			print("コマンド> " + command)
			if words[0] == "play":
				print(self.songNames[self.playlist[0]]+":",end="")
				for i in range(0, self.songLengthList[self.playlist[0]]):
					print("♪",end="")
				print()
			elif words[0] == "next":
				if self.selector == "reverse":
					self.playlist[0] = self.playlist[len(self.playlist)-1]
					self.playlist.pop()
				elif self.selector == "random":
					self.playlist.pop(0)
					i = random.randint(0,len(self.playlist)-1)
					if i != 0:
						tmp = self.playlist[0]
						self.playlist[0] = self.playlist[i]
						self.playlist[i] = tmp
				elif self.selector == "normal":
					self.playlist.pop(0)
				else:
					self.playlist.pop(0)
			elif words[0] == "shuffle":
				self.playlist = []
				size = len(self.songNames) if len(words) == 1 else int(words[1])
				for i in range(0,size):
					self.playlist.append(random.randint(0,len(self.songNames)-1))
			elif words[0] == "selector":
				self.selector = words[1]
			elif words[0] == "info":
				print("アーティスト : " + self.artists[self.playlist[0]])
				print("アルバム : " + self.cdNames[self.playlist[0]])
				print("タイトル : " + self.songNames[self.playlist[0]])
				print("長さ : " + str(self.songLengthList[self.playlist[0]]))
			elif words[0] == "playlist":
				for i in self.playlist:
					print("No. " + str(i) + ":",end="")
					print("アーティスト=" + self.artists[i] + ",",end="")
					print("アルバム=" + self.cdNames[i] + ",",end="")
					print("タイトル=" + self.songNames[i] + ",",end="")
					print("長さ=" + str(self.songLengthList[i]))
			elif words[0] == "list":
				if len(words) > 1:
					for target in words[1:len(words)]:
						for i in range(0, len(self.songNames)):
							if self.cdNames[i] == target:
								print(str(i) + ": " + self.songNames[i])
				else:
					for i in range(0, len(self.songNames)):
						print(str(i) + ": " + self.songNames[i])
			elif words[0] == "add":
				self.playlist.append(int(words[1]))
			elif words[0] == "remove":
				self.playlist.pop(int(words[1]))
			elif words[0] == "cd":
				print("現在のアルバム: "+self.cdNames[self.playlist[0]])
			else:
				print("コマンド \"" + command + "\" はサポートされていません。")


if __name__ == '__main__':
	artists = []
	cdNames = []
	songNames = []
	songLengthList = []

	artists.append("SiM")
	cdNames.append("EViLS")
	songNames.append("Blah Blah Blah")
	songLengthList.append(8)

	artists.append("SiM")
	cdNames.append("EViLS")
	songNames.append("Same Sky")
	songLengthList.append(3)

	artists.append("SiM")
	cdNames.append("EViLS")
	songNames.append("faith")
	songLengthList.append(9)



	artists.append("Fact")
	cdNames.append("burundanga")
	songNames.append("FOSS")
	songLengthList.append(7)


	artists.append("Fact")
	cdNames.append("burundanga")
	songNames.append("1000 miles")
	songLengthList.append(13)


	artists.append("Fact")
	cdNames.append("burundanga")
	songNames.append("pink rolex")
	songLengthList.append(5)

	JukeboxMessed(artists, cdNames, songNames, songLengthList).activateAuto(["list",
		"list burundanga EViLS",
		"add 1",
		"add 3",
		"playlist",
		"remove 0",
		"playlist",
		"info",
		"play",
		"shuffle",
		"playlist",
		"shuffle 10",
		"playlist",
		"next",
		"playlist",
		"selector reverse",
		"next",
		"playlist",
		"selector random",
		"next",
		"playlist",
		"cd",
		])

