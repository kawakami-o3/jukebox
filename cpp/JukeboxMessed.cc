#include<sstream>
#include<iostream>
#include<vector>
#include<cstdlib>

using namespace std;

void print(vector<string> ss) {
	for (int i=0 ; i<ss.size() ; i++) {
		cout << ss.at(i) << endl;
	}
}

class Jukebox {
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
	private:
		vector<string> artists;
		vector<string> cdNames;
		vector<string> songNames;
		vector<int> songLengthList;

		vector<int> playlist;
		string selector;
	public:
		Jukebox(vector<string> artists, vector<string> cdNames,
			 	vector<string> songNames, vector<int> songLengthList);

		void activateAuto(vector<string> commands);
};


Jukebox::Jukebox(vector<string> artists, vector<string> cdNames,
	 	vector<string> songNames, vector<int> songLengthList) {
	this->artists = artists;
	this->cdNames = cdNames;
	this->songNames = songNames;
	this->songLengthList = songLengthList;

	this->selector = "normal";
	srand(time(NULL));
}

void Jukebox::activateAuto(vector<string> commands) {
	vector<string>::iterator it = commands.begin();
	while (it != commands.end()) {
		string tmp_str;
		string cmd = *it;
		cout << "コマンド> " << cmd << endl;


		vector<string> words;
		int cutAt;
		tmp_str = cmd;
		while ((cutAt = tmp_str.find_first_of(" ")) != tmp_str.npos) {
			if (cutAt > 0) {
				words.push_back(tmp_str.substr(0, cutAt));
			}
			tmp_str = tmp_str.substr(cutAt + 1);
		}
		if (tmp_str.length() > 0) {
			words.push_back(tmp_str);
		}

		if (words.at(0) == "play") {
			cout << songNames.at(playlist.at(0)) << ": ";
			for (int i=0 ; i<songLengthList.at(playlist.at(0)) ; i++) {
				cout << "♪";
			}
			cout << endl;
		} else if (words.at(0) == "next") {
			if (selector == "reverse") {
				playlist[0] = playlist.back();
				playlist.pop_back();
			} else if (selector == "random") {
				int target = 1 + (rand() % (playlist.size()-1));
				if (target != 1) {
					int tmp = playlist[1];
					playlist[1] = playlist[target];
					playlist[target] = tmp;
				}
				playlist.erase(playlist.begin());
			} else {
				playlist.erase(playlist.begin());
			}
		} else if (words.at(0) == "selector") {
			selector = words.at(1);
		} else if (words.at(0) == "shuffle") {
			playlist.clear();
			int size = songNames.size();
			if (words.size() > 1) {
				istringstream is(words.at(1));
				is >> size;
			}
			for (int i=0 ; i<size ; i++) {
				playlist.push_back(rand() % songNames.size());
			}
		} else if (words.at(0) == "info") {
			cout << "アーティスト : " << artists.at(playlist.at(0)) << endl;
			cout << "アルバム : " << cdNames.at(playlist.at(0)) << endl;
			cout << "タイトル : " << songNames.at(playlist.at(0)) << endl;
			cout << "長さ : " << songLengthList.at(playlist.at(0)) << endl;
		} else if (words.at(0) == "playlist") {
			for (int i=0 ; i<playlist.size() ; i++) {
				cout << "No. " << playlist.at(i) << ": ";
				cout << "アーティスト=" << artists.at(playlist.at(i)) << ", ";
				cout << "アルバム=" << cdNames.at(playlist.at(i)) << ", ";
				cout << "タイトル=" << songNames.at(playlist.at(i)) << ", ";
				cout << "長さ=" << songLengthList.at(playlist.at(i)) << endl;
			}
		} else if (words.at(0) == "list") {
			if (words.size() > 1) {
				for (int i=1 ; i<words.size() ; i++) {
					for (int j=0 ; j<songNames.size() ; j++) {
						if (cdNames.at(j) == words.at(i)) {
							cout << j << ": " << songNames.at(j) << endl;
						}
					}
				}
			} else {
				for (int i=0 ; i<songNames.size() ; i++) {
					cout << i << ":" << songNames.at(i) << endl;
				}
			}
		} else if (words.at(0) == "add") {
			int id;
			istringstream is(words.at(1));
			is >> id;
			playlist.push_back(id);
		} else if (words.at(0) == "remove") {
			int id;
			istringstream is(words.at(1));
			is >> id;
			if (id>=playlist.size()-1) {
				playlist.pop_back();
			} else {
				playlist.push_back(id);
			}
		} else if (words.at(0) == "cd") {
			cout << "現在のアルバム: " << cdNames.at(playlist.at(0)) << endl;
		} else {
			cout << "not supported" << endl;
		}


		it++;
	}
}

int main() {
	vector<string> artists;
	vector<string> cdNames;
	vector<string> songNames;
	vector<int> songLengthList;

	artists.push_back("SiM");
	cdNames.push_back("EViLS");
	songNames.push_back("Blah Blah Blah");
	songLengthList.push_back(8);

	artists.push_back("SiM");
	cdNames.push_back("EViLS");
	songNames.push_back("Same Sky");
	songLengthList.push_back(3);
	
	
	artists.push_back("SiM");
	cdNames.push_back("EViLS");
	songNames.push_back("faith");
	songLengthList.push_back(9);

	artists.push_back("Fact");
	cdNames.push_back("burundanga");
	songNames.push_back("FOSS");
	songLengthList.push_back(3);

	artists.push_back("Fact");
	cdNames.push_back("burundanga");
	songNames.push_back("1000 miles");
	songLengthList.push_back(13);

	artists.push_back("Fact");
	cdNames.push_back("burundanga");
	songNames.push_back("pink rolex");
	songLengthList.push_back(5);


	Jukebox jukebox(artists, cdNames, songNames, songLengthList);

	vector<string> commands;
	commands.push_back("list");
	commands.push_back("shuffle");
	commands.push_back("playlist");
	commands.push_back("play");
	commands.push_back("next");
	commands.push_back("play");
	commands.push_back("selector random");
	commands.push_back("next");
	commands.push_back("play");
	commands.push_back("next");
	commands.push_back("play");
	commands.push_back("info");
	commands.push_back("list burundanga");
	commands.push_back("add 0");
	commands.push_back("add 0");
	commands.push_back("playlist");
	commands.push_back("remove 5");
	commands.push_back("playlist");

	jukebox.activateAuto(commands);

	return 0;
}
