public class CDPlayer {
	private Playlist p;
	private SongSelector s;

	public CDPlayer(Playlist p, SongSelector s) {
		this.p = p;
		this.s = s;
	}

	public void playSong() {
		System.out.print(p.getCurrentSong().getTitle() + ":");
		
		for (int i=0 ; i<p.getCurrentSong().getLength() ; i++) {
			System.out.print("♪");
		}
		System.out.println();
	}

	public void next() {
		s.next(p);
	}
	
	public Playlist getPlaylist() {
		return p;
	}

	public void setPlaylist(Playlist p) {
		this.p = p;
	}
	
	public void setSongSelector(SongSelector s) {
		this.s = s;
	}

}
