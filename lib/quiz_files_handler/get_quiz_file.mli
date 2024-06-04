(* get_quiz_file.mli *)
(* Folder w katalogu pliku wykonywalnego którego ma program szukać *)
val directory : string

(* Roszerzenie plików z quizami > cqf - caml quiz file *)
val extension : string

(** Public: Zwraca ścieżkę do folderu z quizami w formacie [string] **)
val get_quiz_dir : string

(** Sprawdza katalog pliku wykonywalnego w poszukiwaniu folderu z quizami [directory] i zwraca listę [string list] z nazwami tych plików [extension] **)
val get_quiz_list : string list

(** Zamienia listę plików [string list] na format odpowiedni do jej wypisania [string list] **)
val printable_quiz_list : string list -> string list