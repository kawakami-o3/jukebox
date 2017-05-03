public enum SongSelector {
	// プレイリストのキューに曲があることを仮定
	
	NORMAL {
		@Override
		public Song next(Playlist p) {
			Song result = p.getNextSong();
			p.removeSong(result);
			p.setCurrentSong(result);
			return result;
		}
	},
	SHUFFLE {
		@Override
		public Song next(Playlist p) {
			Song result = p.getSongRandom();
			p.removeSong(result);
			p.setCurrentSong(result);
			return result;
		}
	};

	abstract public Song next(Playlist p);
}
