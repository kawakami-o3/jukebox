import java.util.ArrayList;
import java.util.List;

public class CD {

	private String id;
	private String artistName;
	private String name;
	private List<Song> songs;

	public CD(String id, String artistName, String name, Song ... songs) {
		this.id = id;
		this.artistName = artistName;
		this.name = name;
		this.songs = new ArrayList<>();
		for (Song s : songs) {
			this.songs.add(s);
			s.setCD(this);
		}
	}

	public String getId() {
		return id;
	}

	public String getArtistName() {
		return artistName;
	}

	public String getName() {
		return name;
	}
	
	public List<Song> getSongs() {
		return songs;
	}
}
