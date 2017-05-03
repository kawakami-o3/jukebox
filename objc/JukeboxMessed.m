#import<stdio.h>
#import<Foundation/Foundation.h>

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

@interface JukeboxMessed : NSObject
{
	NSMutableArray* _artists;
  NSMutableArray* _cdNames;
  NSMutableArray* _songNames;
  NSMutableArray* _songLengthList;
  
  NSMutableArray* _playlist;
  NSString* _selector;
}

- (id)initWithArtists:(NSMutableArray*)artists withCdNames:(NSMutableArray*)cdNames
        withSongNames:(NSMutableArray*)songNames withSongLengthList:(NSMutableArray*)songLengthList;
- (void)activateAuto:(NSArray*)commands;


@property (nonatomic, retain) NSMutableArray* _artists;
@property (nonatomic, retain) NSMutableArray* _cdNames;
@property (nonatomic, retain) NSMutableArray* _songNames;
@property (nonatomic, retain) NSMutableArray* _songLengthList;
@property (nonatomic, retain) NSMutableArray* _playlist;
@property (nonatomic, retain) NSString* _selector;

@end

@implementation JukeboxMessed
- (id)initWithArtists:(NSMutableArray*)artists withCdNames:(NSMutableArray*)cdNames
        withSongNames:(NSMutableArray*)songNames withSongLengthList:(NSMutableArray*)songLengthList
{
	self = [super init];
  _artists = artists;
  _cdNames = cdNames;
  _songNames = songNames;
  _songLengthList = songLengthList;
  
  _playlist = [[NSMutableArray alloc] init];
  _selector = @"normal";
  srand(time(NULL));
	return self;
}

- (void)activateAuto:(NSArray *)commands
{
  for (NSString* cmd in commands) {
    printf("コマンド> %s\n",[cmd UTF8String]);
    NSArray* words = [cmd componentsSeparatedByString:@" "];

    if ([[words objectAtIndex:0] isEqualToString:@"play"]) {
      printf("%s: ", [[_songNames objectAtIndex:[[_playlist objectAtIndex:0] intValue]] UTF8String]);
      for (int i=0 ; i<[[_songLengthList objectAtIndex:0] intValue] ; i++) {
        printf("♪");
      }
      puts("");
    } else if ([[words objectAtIndex:0] isEqualToString:@"next"]) {
      if ([_selector isEqualToString:@"reverse"]) {
        [_playlist exchangeObjectAtIndex:0 withObjectAtIndex:[_playlist count]-1];
        [_playlist removeObjectAtIndex:[_playlist count]-1];
      } else if ([_selector isEqualToString:@"random"]) {
        int target = 1 + (rand() % ((int)[_playlist count]-1));
        [_playlist exchangeObjectAtIndex:1 withObjectAtIndex:target];
        [_playlist removeObjectAtIndex:0];
      } else {
        [_playlist removeObjectAtIndex:0];
      }
    } else if ([[words objectAtIndex:0] isEqualToString:@"selector"]) {
      _selector = [words objectAtIndex:1];
    } else if ([[words objectAtIndex:0] isEqualToString:@"shuffle"]) {
      _playlist = [NSMutableArray array];
      int size = [words count] > 1
                  ? [[words objectAtIndex:1] intValue]
                  : (int)[_songNames count];

      for (int i=0 ; i<size ; i++) {
        [_playlist addObject:[NSNumber numberWithInt:(rand() % (int)[_songNames count])]];
      }
    } else if ([[words objectAtIndex:0] isEqualToString:@"info"]) {
      printf("アーティスト : %s\n", [[_artists objectAtIndex:[[_playlist objectAtIndex:0] intValue]] UTF8String]);
      printf("アルバム : %s\n", [[_cdNames objectAtIndex:[[_playlist objectAtIndex:0] intValue]] UTF8String]);
      printf("タイトル : %s\n", [[_songNames objectAtIndex:[[_playlist objectAtIndex:0] intValue]] UTF8String]);
      printf("長さ : %d\n", [[_songLengthList objectAtIndex:[[_playlist objectAtIndex:0] intValue]] intValue]);
    } else if ([[words objectAtIndex:0] isEqualToString:@"playlist"]) {
      for (NSNumber* i in _playlist) {
        printf("No. %d: ", [i intValue]);
        printf("アーティスト=%s, ", [[_artists objectAtIndex:[i intValue]] UTF8String]);
        printf("アルバム=%s, ", [[_cdNames objectAtIndex:[i intValue]] UTF8String]);
        printf("タイトル=%s, ", [[_songNames objectAtIndex:[i intValue]] UTF8String]);
        printf("長さ=%d\n", [[_songLengthList objectAtIndex:[i intValue]] intValue]);
      }
    } else if ([[words objectAtIndex:0] isEqualToString:@"list"]) {
      if ([words count] > 1) {
        for (int i=1 ; i<[words count] ; i++) {
          for (int j=0 ; j<[_songNames count] ; j++) {
            if ([[_cdNames objectAtIndex:j] isEqualToString:[words objectAtIndex:i]]) {
              printf("%d: %s\n", j, [[_songNames objectAtIndex:j] UTF8String]);
            }
          }
        }
      } else {
        for (int i=0 ; i<[_songNames count] ; i++) {
          printf("%d: %s\n", i, [[_songNames objectAtIndex:i] UTF8String]);
        }
      }
    } else if ([[words objectAtIndex:0] isEqualToString:@"add"]) {
      [_playlist addObject:[NSNumber numberWithInt:[[words objectAtIndex:1] intValue]]];
    } else if ([[words objectAtIndex:0] isEqualToString:@"remove"]) {
      [_playlist removeObjectAtIndex:[[words objectAtIndex:1] intValue]];
    } else if ([[words objectAtIndex:0] isEqualToString:@"cd"]) {
      printf("現在のアルバム: %s\n", [[_cdNames objectAtIndex:[[_playlist objectAtIndex:[[words objectAtIndex:1] intValue]] intValue]] UTF8String]);
    } else {
      printf("not supported\n");
    }
  }
}


@synthesize _artists;
@synthesize _cdNames;
@synthesize _songNames;
@synthesize _songLengthList;
@synthesize _playlist;
@synthesize _selector;
@end

int main(void) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSMutableArray* artists = [NSMutableArray array];
  NSMutableArray* cdNames = [NSMutableArray array];
  NSMutableArray* songNames = [NSMutableArray array];
  NSMutableArray* songLengthList = [NSMutableArray array];

	[artists addObject:@"SiM"];
	[cdNames addObject:@"EViLS"];
  [songNames addObject:@"Blah Blah Blah"];
  [songLengthList addObject:[NSNumber numberWithInt:8]];
  
  [artists addObject:@"SiM"];
	[cdNames addObject:@"EViLS"];
  [songNames addObject:@"Same Sky"];
  [songLengthList addObject:[NSNumber numberWithInt:3]];

  [artists addObject:@"SiM"];
	[cdNames addObject:@"EViLS"];
  [songNames addObject:@"faith"];
  [songLengthList addObject:[NSNumber numberWithInt:9]];
  
  [artists addObject:@"Fact"];
	[cdNames addObject:@"burundanga"];
  [songNames addObject:@"FOSS"];
  [songLengthList addObject:[NSNumber numberWithInt:3]];
  
  [artists addObject:@"Fact"];
	[cdNames addObject:@"burundanga"];
  [songNames addObject:@"1000 miles"];
  [songLengthList addObject:[NSNumber numberWithInt:13]];
  
  [artists addObject:@"Fact"];
	[cdNames addObject:@"burundanga"];
  [songNames addObject:@"pink rolex"];
  [songLengthList addObject:[NSNumber numberWithInt:5]];


	JukeboxMessed* jukebox = [[JukeboxMessed alloc ]
                            initWithArtists:artists
                            withCdNames:cdNames
                            withSongNames:songNames
                            withSongLengthList:songLengthList];
  [jukebox activateAuto:[NSArray arrayWithObjects:@"list",@"list EViLS",@"shuffle",@"playlist",@"info",
                         @"play",nil]];


  [pool release];
}
