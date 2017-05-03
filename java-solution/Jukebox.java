import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Set;
import java.util.HashSet;

public class Jukebox {
	// 仕様メモ
	// クラシカルなジュークボックスのエミュレータ
	// 無料
	//
	// 構成
	// ジュークボックス
	// 曲
	// アーティスト
	// プレイリスト
	// ディスプレイ
	//
	// 動作
	// プレイリストの再生(追加、削除、シャッフル)
	// CDの選択
	// 曲の選択
	// 再生待ちへ曲を追加
	// プレイリストから次の曲を得る
	//

	private CDPlayer cdPlayer;
	private Set<CD> cdCollection;

	public Jukebox(CDPlayer cdPlayer, Set<CD> cdCollection) {
		this.cdPlayer = cdPlayer;
		this.cdCollection = cdCollection;
	}
	
	public CDPlayer getCDPlayer() {
		return cdPlayer;
	}
	
	public Set<CD> getCDs() {
		return cdCollection;
	}

	public void play() {
		cdPlayer.playSong();
	}

	private enum Command {
		play{
			@Override
			public void execute(Jukebox jukebox, List<String> args) {
				jukebox.play();
			}
		},
		next{
			@Override
			public void execute(Jukebox jukebox, List<String> args) {
				jukebox.cdPlayer.next();
			}
		},
		selector {
			@Override
			public void execute(Jukebox jukebox, List<String> args) {
				jukebox.getCDPlayer().setSongSelector(SongSelector.valueOf(args.get(0)));
				
			}
		},
		info {

			@Override
			public void execute(Jukebox jukebox, List<String> args) {
				Song song = jukebox.getCDPlayer().getPlaylist().getCurrentSong();
				
				System.out.println("Title: "+song.getTitle());
				System.out.println("Length: "+song.getLength());
				System.out.println("CD name: "+song.getCD().getName());
				System.out.println("Artist name: "+song.getCD().getArtistName());
			}
			
		};
		abstract public void execute(Jukebox jukebox, List<String> args);
	}

	private void execute(String line) {
		List<String> words = Arrays.asList(line.split(" "));
		try {
			Command cmd = Command.valueOf(words.get(0));
		 	cmd.execute(this, words.size() > 1 ? words.subList(1,words.size()) : new ArrayList<String>());
		} catch (IllegalArgumentException e) {
			System.out.println("コマンド "+words.get(0)+" はサポートされていません。");
		}
	}

	public void activate() {
		BufferedReader stdReader = new BufferedReader(new InputStreamReader(System.in));
		String line;

		try {
			System.out.print("> ");
			while ((line = stdReader.readLine()) != null) {
				execute(line);
				System.out.print("> ");
			}
			stdReader.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public void activateAuto() {
		//for (String cmd : new String[]{"next","play"}) {
		//for (String cmd : new String[]{"next","info"}) {
		for (String cmd : new String[]{"selector SHUFFLE","next","play"}) {
			System.out.println(cmd);
			execute(cmd);
		}
	}

	public static void main(String[] args) {
		// コマンド入力方式
		// 曲の検索
		// プレイリストへの追加
		// プレイリストの表示
		// 再生開始、一曲だけとかプレイリストが終わるまでとか
		// 再生順の変更、順送りとシャッフル
		// 一曲終わるごとにコマンド入力へ
		// プレイリストの自動生成とか

		Set<CD> cdset = new HashSet<>();
		cdset.add(new CD("c0", "SiM", "EViLS",
				new Song("s0", "Blah Blah Blah", 8),
				new Song("s1", "Same Skey", 3),
				new Song("s2", "faith", 9)));
		cdset.add(new CD("c2", "Fact", "burundanga",
				new Song("s10", "FOSS", 3),
				new Song("s11", "1000 miles", 13),
				new Song("s12", "pink rolex", 5)));
		CDPlayer cdPlayer = new CDPlayer(new Playlist(), SongSelector.NORMAL);
		
		for (CD cd : cdset) {
			for (Song s : cd.getSongs()) {
				cdPlayer.getPlaylist().queueUpSong(s);
			}
		}
		new Jukebox(cdPlayer, cdset).activateAuto();

	}
}
