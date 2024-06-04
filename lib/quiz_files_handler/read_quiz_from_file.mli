(* read_quiz_from_file.mli *)
(** struktura do przechowywania danych pojedyńczego zapytania w formacie pytanie [string], poprawna odpowiedź [string], niepoprawne odpowiedzi [list string] **)
type question = {
  question_text : string;
  correct_answer : string;
  wrong_answers : string list;
}

(** Wczytuje pytania z pliku o pełnej ścieżce [string] i zwraca je jako listę struktur typu [list question] **)
val read_questions_from_file : string -> question list

(** Pobiera dane w formacie [list question] i wypisuje je na standardowym wyjściu **)
val print_questions : question list -> unit

val start_quiz : string -> string -> question list -> unit
