function Jukebox(artists, cdNames, songNames, songLengthList) {
	this.artists = artists;
	this.cdNames = cdNames;
	this.songNames = songNames;
	this.songLengthList = songLengthList;

	this.playlist = new Array();
	this.selector = "normal";
}

Jukebox.prototype.activateAuto = function(commands) {
	for (var i in commands) {
		console.log('コマンド> '+commands[i]);
		var words = commands[i].split(" ");
		switch (words[0]) {
			case "play":
				var output = this.songNames[this.playlist[0]] + ': ';
				for (var j=0 ; j<this.songLengthList[this.playlist[0]] ; j++) {
					output += "♪";
				}
				console.log(output);
				break;
			case "next":
				switch (this.selector) {
					case "reverse":
						this.playlist[0] = this.playlist[this.playlist.length-1];
						this.playlist.splice(this.playlist.length-1, 1);
						break;
					case "random":
						var tmp_i = 1 + Math.floor(Math.random()*(this.playlist.length-1));
						if (tmp_i != 1) {
							var tmp_p = this.playlist[1];
							this.playlist[1] = this.playlist[tmp_i]
							this.playlist[tmp_i] = tmp_p;
						}
						this.playlist.splice(0,1);
						break;
					case "normal":
					default:
						this.playlist.splice(0,1);
				}
				break;
			case "selector":
				this.selector = words[1];
				break;
			case "shuffle":
				this.playlist = [];
				var size = words.length == 1 ? this.songNames.length : Number(words[1]);
				for (var j=0 ; j<size ; j++) {
					this.playlist[this.playlist.length] = Math.floor(Math.random() * this.songNames.length);
				}
				break;
			case "info":
				console.log('アーティスト : ' + this.artists[this.playlist[0]]);
				console.log('アルバム : ' + this.cdNames[this.playlist[0]]);
				console.log('タイトル : ' + this.songNames[this.playlist[0]]);
				console.log('長さ : ' + this.songLengthList[this.playlist[0]]);
				break;
			case "playlist":
				for (var j=0 ; j<this.playlist.length ; j++) {
					var output = 'No. ' + this.playlist[j] + ': ';
					output += 'アーティスト=' + this.artists[this.playlist[j]] + ', ';
					output += 'タイトル=' + this.songNames[this.playlist[j]] + ', ';
					output += '長さ=' + this.songLengthList[this.playlist[j]];
					console.log(output);
				}
				break;
			case "list":
				if (words.length > 1) {
					for (var j=1 ; j<words.length ; j++) {
						for (var k=0 ; k<this.songNames.length ; k++) {
							if (this.cdNames[k] === words[j]) {
								console.log('' + k + ': ' + this.songNames[k]);
							}
						}
					}
				} else {
					for (var j=0 ; j<this.songNames.length ; j++) {
						console.log('' + j + ': ' + this.songNames[j]);
					}
				}
				break;
			case "add":
				this.playlist[this.playlist.length] = words[1];
				break;
			case "remove":
				this.playlist.splice(words[1],1);
				break;
			case "cd":
				console.log('現在のアルバム: ' + this.cdNames[this.playlist[0]]);
				break;
			default:
				console.log("コマンド \"" + commands[i] + "\" はサポートされていません。");
		}
	}
};


var artists = [];
var cdNames = [];
var songNames = [];
var songLengthList = [];

artists.push('SiM');
cdNames.push('EViLS');
songNames.push('Blah Blah Blah');
songLengthList.push(8);

artists.push('SiM');
cdNames.push('EViLS');
songNames.push('Same Sky');
songLengthList.push(3);


artists.push('SiM');
cdNames.push('EViLS');
songNames.push('faith');
songLengthList.push(9);


artists.push('Fact');
cdNames.push('burundanga');
songNames.push('FOSS');
songLengthList.push(6);


artists.push('Fact');
cdNames.push('burundanga');
songNames.push('1000 miles');
songLengthList.push(13);

artists.push('Fact');
cdNames.push('burundanga');
songNames.push('pink rolex');
songLengthList.push(5);




new Jukebox(artists, cdNames, songNames, songLengthList).activateAuto(['list'
	,'list burundanga EViLS'
	,'add 1'
	,'add 5'
	,'playlist'
	,'remove 0'
	,'playlist'
	,'info'
	,'play'
	,'shuffle'
	,'playlist'
	,'next'
	,'playlist'
	,'selector reverse'
	,'next'
	,'playlist'
	,'selector random'
	,'next'
	,'playlist'
	,'cd'
	]);

