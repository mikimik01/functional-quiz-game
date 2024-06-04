(* get_quiz_file.ml *)
(* Public: Folder w katalogu pliku wykonywalnego którego ma program szukać *)
let directory = "/quizes/"

(* Public: Roszerzenie plików z quizami > cqf - caml quiz file *)
let extension = ".cqf"

(* Public: Zwraca ścieżkę do folderu z quizami *)
let get_quiz_dir =
  Sys.getcwd() ^ directory

(* Public: Sprawdza katalog pliku wykonywalnego w poszukiwaniu folderu z quizami i zwraca listę z nazwami tych plików *)
let get_quiz_list = 
  Sys.readdir get_quiz_dir
  |> Array.to_list
  |> List.filter (fun x -> Filename.extension x = extension)

(* Private: Formatuje pojedyńczą nazwę pliku na format odpowiedni do wypisania *)
let format_file_name file_name = 
  let partial = String.map(
      fun symbol -> if symbol = '_' then ' ' else symbol
    ) file_name in
  let file_name_length = String.length partial in
  String.sub partial 0 (file_name_length - 4)

(* Public: Zamienia listę plików na format odpowiedni do jej wypisania *)
let printable_quiz_list files_list =
  List.mapi(
    fun index file -> string_of_int (index + 1) ^ ". " ^ format_file_name file
  ) files_list