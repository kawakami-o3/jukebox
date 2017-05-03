import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.Random;

public class Playlist {

	private Random rand = new Random();
	private Song song;
	private List<Song> queue;

	public Playlist(Song ... songs) {
		this.queue = new ArrayList<>();
		this.queue.addAll(Arrays.asList(songs));
	}

	public Song getNextSong() {
		return queue.size() == 0 ? null : queue.get(0);
	}

	public Song getSongRandom() {
		return queue.size() == 0 ? null : queue.get(rand.nextInt(queue.size()));
	}

	public void removeSong(Song song) {
		queue.remove(song);
	}

	public void queueUpSong(Song s) {
		queue.add(s);
	}
	
	public Song getCurrentSong() {
		return song;
	}
	
	public void setCurrentSong(Song song) {
		this.song = song;
	}
}
