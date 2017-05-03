<html>
<head>
<title>ジュークボックスシミュレータ</title>
</head>
<body>
<pre>
<?php
class JukeboxMessed {
	function __construct($artists, $cdNames, $songNames, $songLengthList) {
		$this->artists = $artists;
		$this->cdNames = $cdNames;
		$this->songNames = $songNames;
		$this->songLengthList = $songLengthList;

		$this->playlist = array();
		$this->selector = 'normal';
	}

	public function activateAuto($commands) {
		foreach ($commands as $command) {
			echo "コマンド> $command\n";
			$words = split(' +', $command);
			switch ($words[0]) {
			case 'play':
				echo $this->songNames[$this->playlist[0]], ': ';
				for ($i=0 ; $i<$this->songLengthList[$this->playlist[0]] ; $i++) {
					echo '♪';
				}
				echo "\n";
				break;
			case 'next':
				switch ($this->selector) {
				case 'reverse':
					$this->playlist[0] = $this->playlist[count($this->playlist)-1];
					array_splice($this->playlist, count($this->playlist)-1, 1);
					break;
				case 'random':
					$tmp_i = rand(1, count($this->playlist)-1);
					if ($tmp_i != 1) {
						$tmp_p = $this->playlist[1];
						$this->playlist[1] = $this->playlist[$tmp_i];
						$this->playlist[$tmp_i] = $tmp_p;
					}
					array_splice($this->playlist, 0, 1);
					break;
				case 'normal':
				default:
					array_splice($this->playlist, 0, 1);
				}
				break;
			case "selector":
				$this->selector = $words[1];
				break;
			case "shuffle":
				$this->playlist = array();
				$size = count($words)==1 ? count($this->songNames) : $words[1];
				for ($i=0 ; $i<$size ; $i++) {
					$this->playlist[] = rand(0, count($this->songNames)-1);
				}
				break;
			case "info":
				echo "アーティスト: ", $this->artists[$this->playlist[0]], "\n";
				echo "アルバム: ", $this->cdNames[$this->playlist[0]], "\n";
				echo "タイトル: ", $this->songNames[$this->playlist[0]], "\n";
				echo "長さ: ", $this->songLengthList[$this->playlist[0]], "\n";
				break;
			case "playlist":
				for ($i=0 ; $i<count($this->playlist) ; $i++) {
					echo 'No. ', $this->playlist[$i],
						': アーティスト=', $this->artists[$this->playlist[$i]],
						', タイトル=', $this->songNames[$this->playlist[$i]],
						', 長さ=', $this->songLengthList[$this->playlist[$i]], "\n";
				}
				break;
			case "list":
				if (count($words) > 1) {
					for ($i=1 ; $i<count($words) ; $i++) {
						for ($j=0 ; $j<count($this->songNames) ; $j++) {
							if ($this->cdNames[$j] == $words[$i]) {
								echo $j, ': ', $this->songNames[$j], "\n";
							}
						}
					}
				} else {
					for ($i=0 ; $i<count($this->songNames) ; $i++) {
						echo $i, ': ', $this->songNames[$i], "\n";
					}
				}
				break;
			case "add":
				$this->playlist[] = $words[1];
				break;
			case "remove":
				array_splice($this->playlist, $words[1], 1);
				break;
			case "cd":
				echo '現在のアルバム: ', $this->cdNames[$this->playlist[0]], "\n";
				break;
			default:
				echo "コマンド \"$command\" はサポートされていません。";
			}
		}
	}
}


$artists = array();
$cdNames = array();
$songNames = array();
$songLengthList = array();


$artists[] = 'SiM';
$cdNames[] = 'EViLS';
$songNames[] = 'Blah Blah Blah';
$songLengthList[] = 8;

$artists[] = 'SiM';
$cdNames[] = 'EViLS';
$songNames[] = 'Same Sky';
$songLengthList[] = 3;

$artists[] = 'SiM';
$cdNames[] = 'EViLS';
$songNames[] = 'faith';
$songLengthList[] = 9;

$artists[] = 'Fact';
$cdNames[] = 'burundanga';
$songNames[] = 'FOSS';
$songLengthList[] = 3;

$artists[] = 'Fact';
$cdNames[] = 'burundanga';
$songNames[] = '1000 miles';
$songLengthList[] = 13;

$artists[] = 'Fact';
$cdNames[] = 'burundanga';
$songNames[] = 'pink rolex';
$songLengthList[] = 5;


$jukebox = new JukeboxMessed($artists, $cdNames, $songNames, $songLengthList);
$jukebox->activateAuto(array('list'
	, 'list burundanga EViLS'
	, 'add 1'
	, 'add 3'
	, 'playlist'
	, 'remove 0'
	, 'playlist'
	, 'info'
	, 'play'
	, 'shuffle'
	, 'playlist'
	, 'next'
	, 'playlist'
	, 'selector reverse'
	, 'next'
	, 'playlist'
	, 'selector random'
	, 'next'
	, 'playlist'
	, 'cd'
));

?>
</pre>
</body>
</html>
