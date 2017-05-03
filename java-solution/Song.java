public class Song {

	private String id;
	private CD cd;
	private String title;
	private int length;

	public Song(String id, String title, int length) {
		this.id = id;
		this.title = title;
		this.length = length;
	}
	
	public String getId() {
		return id;
	}

	public CD getCD() {
		return cd;
	}

	public void setCD(CD cd) {
		this.cd = cd;
	}

	public String getTitle() {
		return title;
	}

	public int getLength() {
		return length;
	}
}
