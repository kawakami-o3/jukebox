
type jukebox = {artists: string list; cdNames: string list;
  songNames: string list; songLengthList: int list}


let genArtists = ["SiM";"SiM";"SiM";"Fact";"Fact";"Fact"]
let genCdNames = ["EViLS";"EViLS";"EViLS";"burundanga";"burundanga";"burundanga"]
let genSongNames = ["Blah Blah Blah";"Same Sky";"faith";"FOSS";"1000 miles";"pink rolex"]
let genSongLengthList = [8;3;9;6;13;5]
let genJukebox = {artists=genArtists; cdNames=genCdNames;
  songNames=genSongNames; songLengthList=genSongLengthList}

let genCommands = ["list"; "list burundanga EViLS"]

let activateAuto jukebox commands = (
  print_string "jukebox activated\n"
)

let rec print_string_list a = match a with
    [] -> ()
  | h::[] -> (
      print_string h;
    )
  | h::t -> (
      print_string h;
      print_string ", ";
      print_string_list t
    )


let rec print_int_list a = match a with
    [] -> ()
  | h::[] -> (
      print_int h;
    )
  | h::t -> (
      print_int h;
      print_string ", ";
      print_int_list t
    )



let print_jukebox j = (
  print_string "Jukebox\n";
  print_string "artists=";
  print_string_list j.artists;
  print_string "\n";
  print_string "cdNames=";
  print_string_list j.cdNames;
  print_string "\n";
  print_string "songNames=";
  print_string_list j.songNames;
  print_string "\n";
  print_string "songLengthList=";
  print_int_list j.songLengthList;
  print_string "\n";
  activateAuto genJukebox genCommands;
  print_string "\n"
)


let main = (
  print_jukebox genJukebox
)

