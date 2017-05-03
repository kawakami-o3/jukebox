import System.IO
import System.Random

data Jukebox = Jukebox {
		artists :: [String]
	, cdNames :: [String]
	, songNames :: [String]
	, songLengthList :: [Int]
	, playlist :: [Int]
	, selector :: String
	} deriving (Show)


activateAuto :: Jukebox -> [String] -> IO ()
activateAuto jukebox [] = putStr ""
activateAuto jukebox (command:restCommands) = do
	putStrLn $ "コマンド> " ++ command
	case (words command) !! 0 of
		"play" -> do
			putStrLn "hello play"
			activateAuto jukebox restCommands
		"next" -> case (selector jukebox) of
			"reverse" -> activateAuto (Jukebox {artists=artists jukebox, cdNames=cdNames jukebox,
										songNames=songNames jukebox, songLengthList=songLengthList jukebox,
										playlist=(init $ (last $ playlist jukebox):(tail $ playlist jukebox)),
										selector=selector jukebox}) restCommands
			"random" -> do
				i <- getStdRandom $ randomR (1,(length $ playlist jukebox)-1) :: IO Int
				activateAuto (Jukebox {artists=artists jukebox, cdNames=cdNames jukebox,
					songNames=songNames jukebox, songLengthList=songLengthList jukebox,
					playlist=((playlist jukebox) !! i):(tail $ (take i $ playlist jukebox) ++ (drop (i+1) $ playlist jukebox)),
					selector=selector jukebox}) restCommands
			"normal" -> activateAuto (Jukebox {artists=artists jukebox, cdNames=cdNames jukebox,
										songNames=songNames jukebox, songLengthList=songLengthList jukebox,
										playlist=(tail $ playlist jukebox),
										selector=selector jukebox}) restCommands
			_ -> activateAuto (Jukebox {artists=artists jukebox, cdNames=cdNames jukebox,
						songNames=songNames jukebox, songLengthList=songLengthList jukebox,
						playlist=(tail $ playlist jukebox),
						selector=selector jukebox}) restCommands
		"selector" -> activateAuto (Jukebox {artists=artists jukebox, cdNames=cdNames jukebox,
										songNames=songNames jukebox, songLengthList=songLengthList jukebox,
										playlist=(playlist jukebox),
										selector=((words command) !! 1)}) restCommands
		"shuffle" -> do
			gen <- getStdGen
			activateAuto (Jukebox {artists=artists jukebox, cdNames=cdNames jukebox
				,songNames=songNames jukebox, songLengthList=songLengthList jukebox
				,playlist= map (\i -> i `mod` (length $ songNames jukebox)) $ take (
						if (length $ words command) == 1
							then length $ songNames jukebox
							else (read ((words command) !! 1) :: Int)
					) $ (randoms gen :: [Int])
				,selector=selector jukebox}) restCommands
		"info" -> do
			putStrLn $ "アーティスト : " ++ ((artists jukebox) !! ((playlist jukebox) !! 0))
			putStrLn $ "アルバム : " ++ ((cdNames jukebox) !! ((playlist jukebox) !! 0))
			putStrLn $ "タイトル : " ++ ((songNames jukebox) !! ((playlist jukebox) !! 0))
			putStrLn $ "長さ : " ++ (show $ (songLengthList jukebox) !! ((playlist jukebox) !! 0))
			activateAuto jukebox restCommands
	 	"playlist" -> do
			mapM (\i -> do
					putStr $ "No." ++ (show i) ++ ": "
					putStr $ "アーティスト=" ++ ((artists jukebox) !! i) ++ ", "
					putStr $ "アルバム=" ++ ((cdNames jukebox) !! i) ++ ", "
					putStr $ "タイトル=" ++ ((songNames jukebox) !! i) ++ ", "
					putStr $ "長さ=" ++ (show $ (songLengthList jukebox) !! i)
					putStrLn ""
				) $ playlist jukebox
			activateAuto jukebox restCommands
	 	"list" -> do
			if (length $ words command) > 1
			then do
				mapM (\i -> do
						mapM (\j -> do
								if ((words command) !! i) == ((cdNames jukebox) !! j)
								then putStrLn $ (show j) ++ ": " ++ ((songNames jukebox !! j))
								else putStr ""
							) [0..((length (songNames jukebox))-1)]
					) [1..((length (words command))-1)]
				putStr ""
			else do
				mapM (\i -> do
						putStrLn ((show i) ++ ": " ++ ((songNames jukebox) !! i))
					) [0..((length (songNames jukebox))-1)]
				putStr ""
			activateAuto jukebox restCommands
	 	"add" -> do
			activateAuto (Jukebox {artists=artists jukebox, cdNames=cdNames jukebox,
				songNames=songNames jukebox, songLengthList=songLengthList jukebox,
				playlist=(playlist jukebox) ++ [(read ((words command) !! 1) :: Int)],
				selector=selector jukebox}) restCommands
	 	"remove" -> do
			activateAuto (Jukebox {artists=artists jukebox, cdNames=cdNames jukebox,
				songNames=songNames jukebox, songLengthList=songLengthList jukebox,
				playlist= (fst $ splitAt (read ((words command) !! 1) :: Int) (playlist jukebox))
 					++ (snd $ splitAt ((read ((words command) !! 1) :: Int)+1) (playlist jukebox)),
				selector=selector jukebox}) restCommands
		"cd" -> do
			putStrLn $ "現在のアルバム: " ++ ((cdNames jukebox) !! ((playlist jukebox) !! 0))
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

genJukebox = Jukebox {artists=genArtists, cdNames=genCdNames, songNames=genSongNames, songLengthList=genSongLengthList, playlist=[], selector="normal"}

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
	putStrLn $ show genJukebox
	activateAuto genJukebox genCommands

