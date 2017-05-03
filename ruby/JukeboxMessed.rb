# -*- coding: utf-8 -*-
class JukeboxMessed
	def initialize artists, cdNames, songNames, songLengthList
		@artists = artists
		@cdNames = cdNames
		@songNames = songNames
		@songLengthList = songLengthList

		@playlist = []
		@selector = "normal"
	end

	def activateAuto commands
		commands.each do |command|
			puts "コマンド> #{command}"
			words = command.split
			case words[0]
			when "play"
				print "#{@songNames[@playlist[0]]}: "
				@songLengthList[@playlist[0]].times do
					print "♪"
				end
				puts
			when "next"
				case @selector
				when "reverse"
					@playlist[0] = @playlist[@playlist.length - 1]
					@playlist.delete_at(@playlist.length - 1)
				when "random"
					@playlist.delete_at(0)
					i = rand(@playlist.length)
					if i != 0
						tmp = @playlist[0]
						@playlist[0] = @playlist[i]
						@playlist[i] = tmp
					end
				when "normal"
					@playlist.delete_at(0)
				else
					@playlist.delete_at(0)
				end
			when "selector"
				@selector = words[1]
			when "shuffle"
				@playlist = []
				size = words.length == 1 ? @songNames.length : words[1].to_i
				size.times do
					@playlist << rand(@songNames.length)
				end
			when "info"
				puts "アーティスト : #{@artists[@playlist[0]]}"
				puts "アルバム : #{@cdNames[@playlist[0]]}"
				puts "タイトル : #{@songNames[@playlist[0]]}"
				puts "長さ : #{@songLengthList[@playlist[0]]}"
			when "playlist"
				@playlist.each do |i|
					print "No. #{i}: "
					print "アーティスト=#{@artists[i]}, "
					print "アルバム=#{@cdNames[i]}, "
					print "タイトル=#{@songNames[i]}, "
					puts "長さ=#{@songLengthList[i]}"
				end
			when "list"
				if words.length > 1
					words[1..words.length-1].each do |target|
						@songNames.length.times do |i|
							if @cdNames[i] == target
								puts "#{i}: #{@songNames[i]}"
							end
						end
					end
				else
					@songNames.length.times do |i|
						puts "#{i}: #{@songNames[i]}"
					end
				end
			when "add"
				@playlist << words[1].to_i
			when "remove"
				@playlist.delete_at(words[1].to_i)
			when "cd"
				puts "現在のアルバム: #{@cdNames[@playlist[0]]}"
			else
				puts "コマンド \"#{command}\" はサポートされていません。"
			end
		end
	end
end


artists = []
cdNames = []
songNames = []
songLengthList = []

artists << "SiM"
cdNames << "EViLS"
songNames << "Blah Blah Blah"
songLengthList << 8

artists << "SiM"
cdNames << "EViLS"
songNames << "Same Sky"
songLengthList << 3


artists << "SiM"
cdNames << "EViLS"
songNames << "faith"
songLengthList << 9

artists << "Fact"
cdNames << "burundanga"
songNames << "FOSS"
songLengthList << 7

artists << "Fact"
cdNames << "burundanga"
songNames << "1000 miles"
songLengthList << 13

artists << "Fact"
cdNames << "burundanga"
songNames << "pink rolex"
songLengthList << 5

JukeboxMessed.new(artists, cdNames, songNames, songLengthList).activateAuto(["list",
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
]);

