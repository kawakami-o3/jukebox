import System.IO
import System.Random

--data Artist = String deriving (Show)
--data CD = String deriving (Show)
data Song = Song {
		artist :: String
	, cd :: String
	, name :: String
	, len :: Int
	} deriving (Show)

data Jukebox = Jukebox {
		songs :: Songs
	, playlist :: Playlist
	, selector :: Selector
	} deriving (Show)

data Field = Songs | Playlist | Selector
data Songs = [Song]
data Playlist = [Song]
data Selector = String

updatePlaylist :: Jukebox -> [Song] -> Jukebox
updatePlaylist jukebox playlist = Jukebox {
	songs=songs jukebox,
	playlist=playlist,
	selector=selector jukebox}


activateAuto :: Jukebox -> [String] -> IO ()
activateAuto jukebox [] = putStr ""
activateAuto jukebox (command:restCommands) = do
	putStrLn $ "コマンド> " ++ command
	case (words command) !! 0 of
		"play" -> do
			putStrLn "hello play"
			activateAuto jukebox restCommands
		"next" -> case (selector jukebox) of
			"reverse" ->  activateAuto (updatePlaylist jukebox (init $ (last $ playlist jukebox):(tail $ playlist jukebox))) restCommands
			"random" -> do
				i <- getStdRandom $ randomR (1,(length $ playlist jukebox)-1) :: IO Int
				activateAuto (updatePlaylist jukebox
						(((playlist jukebox) !! i):(tail $ (take i $ playlist jukebox) ++ (drop (i+1) $ playlist jukebox)))
					) restCommands
			"normal" -> activateAuto (updatePlaylist jukebox (tail $ playlist jukebox)) restCommands
			_ -> activateAuto (Jukebox {songs=songs jukebox,
						playlist=(tail $ playlist jukebox),
						selector=selector jukebox}) restCommands
		"selector" -> activateAuto (Jukebox {songs=songs jukebox,
										playlist=(playlist jukebox),
										selector=((words command) !! 1)}) restCommands
		"shuffle" -> do
			gen <- getStdGen
			activateAuto (updatePlaylist jukebox
						(map (\i->(songs jukebox) !! i) $
						map (\i -> i `mod` (length $ songs jukebox)) $ take (
						if (length $ words command) == 1
							then length $ songs jukebox
							else (read ((words command) !! 1) :: Int)
					) $ (randoms gen :: [Int]))
				) restCommands
		"info" -> do
			putStrLn $ "アーティスト : " ++ (artist ((playlist jukebox) !! 0))
			putStrLn $ "アルバム : " ++ (cd ((playlist jukebox) !! 0))
			putStrLn $ "タイトル : " ++ (name ((playlist jukebox) !! 0))
			putStrLn $ "長さ : " ++ (show $ len ((playlist jukebox) !! 0))
			activateAuto jukebox restCommands
	 	"playlist" -> do
			mapM (\i -> do
					putStr $ "No." ++ (show i) ++ ": "
					putStr $ "アーティスト=" ++ (artist i) ++ ", "
					putStr $ "アルバム=" ++ (cd i) ++ ", "
					putStr $ "タイトル=" ++ (name i) ++ ", "
					putStr $ "長さ=" ++ (show $ len i)
					putStrLn ""
				) $ playlist jukebox
			activateAuto jukebox restCommands
	 	"list" -> do
			if (length $ words command) > 1
			then do
				mapM (\i -> do
						mapM (\j -> do
								if ((words command) !! i) == (cd $ (songs jukebox) !! j)
								then putStrLn $ (show j) ++ ": " ++ (name $ (songs jukebox !! j))
								else putStr ""
							) [0..((length (songs jukebox))-1)]
					) [1..((length (words command))-1)]
				putStr ""
			else do
				mapM (\i -> do
						putStrLn ((show i) ++ ": " ++ (name $ (songs jukebox) !! i))
					) [0..((length (songs jukebox))-1)]
				putStr ""
			activateAuto jukebox restCommands
	 	"add" -> do
			activateAuto (Jukebox {songs=songs jukebox,
				playlist=(playlist jukebox) ++ [(songs jukebox)!!(read ((words command) !! 1) :: Int)],
				selector=selector jukebox}) restCommands
	 	"remove" -> do
			activateAuto (Jukebox {songs=songs jukebox,
				playlist= (fst $ splitAt (read ((words command) !! 1) :: Int) (playlist jukebox))
					++ (snd $ splitAt ((read ((words command) !! 1) :: Int)+1) (playlist jukebox)),
				selector=selector jukebox}) restCommands
		"cd" -> do
			putStrLn $ "現在のアルバム: " ++ (cd $ (playlist jukebox) !! 0)
			activateAuto jukebox restCommands
		_ -> do
			putStrLn $ "コマンド \"" ++ command ++ "\" がサポートされていません"
			activateAuto jukebox restCommands



genArtists :: [String]
genArtists = ["SiM", "SiM", "SiM", "Fact", "Fact", "Fact"]

genCdNames :: [String]
genCdNames = ["EViLS", "EViLS", "EViLS", "burundanga", "burundanga", "burundanga"]

genSongNames :: [String]
genSongNames = ["Blah Blah Blah", "Same Sky", "faith", "FOSS", "1000 miles", "pink rolex"]

genSongLengthList :: [Int]
genSongLengthList = [8, 3, 9, 7, 13, 5]

--	artist :: String
--, cd :: String
--, name :: String
--, len :: Int
--} deriving (Show)


genSongs :: [Song]
genSongs = map (\i -> Song {
			artist=genArtists !! i
		, cd=genCdNames !! i
		, name=genSongNames !! i
		, len=genSongLengthList !! i
	} ) [0..(length genArtists)-1]

--genJukebox = Jukebox {artists=genArtists, cdNames=genCdNames, songNames=genSongNames, songLengthList=genSongLengthList, playlist=[], selector="normal"}
genJukebox = Jukebox {songs=genSongs, playlist=[], selector="normal"}

genCommands = ["list"
		,"list burundanga EViLS"
		,"add 1"
		,"add 3"
		,"playlist"
		,"remove 0"
		,"playlist"
		,"info"
		,"play"
		,"shuffle"
		,"playlist"
		,"shuffle 10"
		,"playlist"
		,"next"
		,"playlist"
		,"selector reverse"
		,"next"
		,"playlist"
		,"selector random"
		,"next"
		,"playlist"
		,"cd"
	]

main = do
	putStrLn $ show genArtists
	putStrLn $ show genSongs
	putStrLn $ show genJukebox
	--putStrLn $ show genJukebox
	activateAuto genJukebox genCommands

