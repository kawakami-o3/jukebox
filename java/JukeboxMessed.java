import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class JukeboxMessed {
	/*
	 * ジュークボックスエミュレータ
	 * 仕様
	 * - ジュークボックスは複数の楽曲データを所持している
	 * - 一つの楽曲データには、アーティスト名、アルバム名、タイトル、曲の長さが含まれている
	 * - ユーザが入力するコマンドに応じて以下の操作を行う
	 *   1. 曲の再生
	 *   2. プレイリストの自動生成
	 *   3. プレイリストの曲飛ばし
	 *   4. プレイリストへ曲を追加
	 *   5. プレイリストから曲を削除
	 *   6. 曲飛ばし方法の変更(順送り、ランダム)
	 *   7. 現在の曲情報の表示
	 *   8. 楽曲データ一覧の表示
	 *   9. アルバム情報の表示
	 */
	public JukeboxMessed(List<String> artists, List<String> cdNames, List<String> songNames, List<Integer> songLengthList) {
		this.artists = new ArrayList<>(artists);
		this.cdNames = new ArrayList<>(cdNames);
		this.songNames = new ArrayList<>(songNames);
		this.songLengthList = new ArrayList<>(songLengthList);

		playlist = new ArrayList<>();
		selector = "normal";
		rnd = new Random();
	}

	private Random rnd;
	private List<String> artists;
	private List<String> cdNames;
	private List<String> songNames;
	private List<Integer> songLengthList;

	private List<Integer> playlist;
	private String selector;

	public void activateAuto(String... commands) {
		for (String cmd : commands) {
			System.out.println("コマンド> " + cmd);
			List<String> words = Arrays.asList(cmd.split(" "));
			switch (words.get(0)) {
			case "play":
				System.out.print(songNames.get(playlist.get(0)) + ": ");
				for (int i = 0; i < songLengthList.get(playlist.get(0)) ; i++) {
					System.out.print("♪");
				}
				System.out.println();
				break;
			case "next":
				switch (selector) {
				case "reverse":
					playlist.set(0, playlist.get(playlist.size() - 1));
					playlist.remove(playlist.size()-1);
					break;
				case "random":
					int i = 1 + rnd.nextInt(playlist.size() - 1);
					if (i != 1) {
						Integer tmp_b = playlist.get(1);
						playlist.set(1, playlist.get(i));
						playlist.set(i, tmp_b);
					}
					playlist.remove(0);
					break;
				case "normal":
				default:
					playlist.remove(0);
				}
				break;
			case "selector":
				selector = words.get(1);
				break;
			case "shuffle":
				playlist = new ArrayList<>();
				int size = words.size() == 1 ? songNames.size() : Integer.parseInt(words.get(1));
				for (int i = 0; i < size; i++) {
					playlist.add(rnd.nextInt(songNames.size()));
				}
				break;
			case "info":
				System.out.println("アーティスト : " + artists.get(playlist.get(0)));
				System.out.println("アルバム : " + cdNames.get(playlist.get(0)));
				System.out.println("タイトル : " + songNames.get(playlist.get(0)));
				System.out.println("長さ : " + songLengthList.get(playlist.get(0)));
				break;
			case "playlist":
				for (int i = 0; i < playlist.size(); i++) {
					System.out.print("No. " + playlist.get(i) + ": ");
					System.out.print("アーティスト=" + artists.get(playlist.get(i)) + ", ");
					System.out.print("アルバム=" + cdNames.get(playlist.get(i)) + ", ");
					System.out.print("タイトル=" + songNames.get(playlist.get(i)) + ", ");
					System.out.println("長さ=" + songLengthList.get(playlist.get(i)));
				}
				break;
			case "list":
				if (words.size() > 1) {
					for (String target : words.subList(1, words.size())) {
						for (int i = 0; i < songNames.size(); i++) {
							if (cdNames.get(i).equals(target)) {
								System.out.println("" + i + ": " + songNames.get(i));
							}
						}
					}
				} else {
					for (int i = 0; i < songNames.size(); i++) {
						System.out.println("" + i + ": " + songNames.get(i));
					}
				}
				break;
			case "add":
				playlist.add(Integer.parseInt(words.get(1)));
				break;
			case "remove":
				playlist.remove(Integer.parseInt(words.get(1)));
				break;
			case "cd":
				System.out.println("現在のアルバム: " + cdNames.get(playlist.get(0)));
				break;
			default:
				System.out.println("コマンド \"" + cmd + "\" はサポートされていません。");
			}
		}
	}

	public static void main(String[] args) {
		List<String> artists = new ArrayList<>();
		List<String> cdNames = new ArrayList<>();
		List<String> songNames = new ArrayList<>();
		List<Integer> songLengthList = new ArrayList<>();

		artists.add("SiM");
		cdNames.add("EViLS");
		songNames.add("Blah Blah Blah");
		songLengthList.add(8);

		artists.add("SiM");
		cdNames.add("EViLS");
		songNames.add("Same Sky");
		songLengthList.add(3);
		
		
		artists.add("SiM");
		cdNames.add("EViLS");
		songNames.add("faith");
		songLengthList.add(9);

		artists.add("Fact");
		cdNames.add("burundanga");
		songNames.add("FOSS");
		songLengthList.add(3);

		artists.add("Fact");
		cdNames.add("burundanga");
		songNames.add("1000 miles");
		songLengthList.add(13);

		artists.add("Fact");
		cdNames.add("burundanga");
		songNames.add("pink rolex");
		songLengthList.add(5);

		// JukeboxMessed(songs).activateAuto("shuffle 3","info","playlist","selector random","play","next","play");
		new JukeboxMessed(artists, cdNames, songNames, songLengthList)
			.activateAuto("list", "add 1", "add 3", "remove 0", "playlist", "cd", "list burundanga");
	}
}
