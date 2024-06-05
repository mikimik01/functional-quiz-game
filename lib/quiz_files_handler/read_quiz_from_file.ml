(* read_quiz_from_file.ml *)
(* Public: struktura do przechowywania danych pojedyńczego zapytania *)
type question = {
  question_text : string;
  correct_answer : string;
  wrong_answers : string list;
}

(* Public: Wczytuje pytania z pliku pod wzkazaną ścieżką a nastepnie zwraca je w liście z wartościami wpisanymi w strukturze question *)
let read_questions_from_file filename =
  let file_channel = open_in filename in
  let rec read_questions acc =
    try
      let line = input_line file_channel in
      match String.split_on_char ';' line with
      | question_text:: correct_answer:: wrong_answer ->
          let question = {
            question_text = question_text;
            correct_answer = correct_answer;
            wrong_answers = wrong_answer;
          } in
          read_questions (question :: acc)
      | _ -> read_questions acc
    with End_of_file ->
      close_in file_channel;
      List.rev acc
  in
  read_questions []

(* Public: Funkcja do wypiswyania pytań w quizie *)
let print_questions questions =
  List.iter (fun q ->
    Printf.printf "Question: %s\nCorrect answer: %s\nWrong answers: %s\n\n"
      q.question_text q.correct_answer (String.concat ", " q.wrong_answers)
  ) questions



(* Funkcja do mieszania listy *)
let shuffle lst =
  let nd = List.map (fun c -> (Random.bits (), c)) lst in
  let sond = List.sort compare nd in
  List.map snd sond

(* Funkcja do mieszania odpowiedzi w pytaniu *)
let shuffle_answers question =
  let all_answers = question.correct_answer :: question.wrong_answers in
  shuffle all_answers

(* Funkcja pomocnicza do znajdowania indeksu elementu *)
let findi p lst =
  let rec aux i = function
    | [] -> raise Not_found
    | x :: xs -> if p x then (i, x) else aux (i + 1) xs
  in aux 0 lst

(* Funkcja pomocnicza do sprawdzania, czy podciąg znajduje się w stringu *)
let string_contains str substr =
  let len = String.length str in
  let sub_len = String.length substr in
  let rec aux i =
    if i + sub_len > len then false
    else if String.sub str i sub_len = substr then true
    else aux (i + 1)
  in
  aux 0

(* Funkcja do dodawania użytkownika do pliku winners.txt *)
let add_winner quiz_name user =
  let filename = "lib/winners.txt" in
  let ic = try Some (open_in filename) with Sys_error _ -> None in
  let lines = match ic with
    | Some ic -> let rec loop acc =
                   try
                     let line = input_line ic in
                     loop (line :: acc)
                   with End_of_file ->
                     close_in ic;
                     List.rev acc
                 in loop []
    | None -> [] in
  let oc = open_out filename in
  let quiz_found = ref false in
  let user_found = ref false in
  List.iter (fun line ->
    if String.starts_with ~prefix:quiz_name line then
      begin
        quiz_found := true;
        if string_contains line user then
          user_found := true;
        if not !user_found then
          Printf.fprintf oc "%s, %s\n" line user
        else
          Printf.fprintf oc "%s\n" line
      end
    else
      Printf.fprintf oc "%s\n" line
  ) lines;
  if not !quiz_found then
    Printf.fprintf oc "%s: %s\n" quiz_name user;
  close_out oc


(* Funkcja do uruchomienia quizu z pomieszanymi pytaniami i odpowiedziami *)
let start_quiz quiz_name user questions =
  let shuffled_questions = shuffle questions in
  let correct_count = ref 0 in  (* Zmienna do przechowywania liczby poprawnych odpowiedzi *)

  List.iter (fun q ->
    let answers = shuffle_answers q in
    let correct_index = fst (findi (fun ans -> ans = q.correct_answer) answers) in
    Printf.printf "Pytanie: %s\n" q.question_text;
    List.iteri (fun i ans -> Printf.printf "%d. %s\n" (i + 1) ans) answers;

    (* Pobranie odpowiedzi od użytkownika *)
    print_string "Twoja odpowiedź (1-3): ";
    let user_answer = read_int () in

    (* Sprawdzenie odpowiedzi *)
    if user_answer = (correct_index + 1) then
      begin
        Printf.printf "Poprawna odpowiedź!\n\n";
        incr correct_count  (* Zwiększenie liczby poprawnych odpowiedzi *)
      end
    else
      Printf.printf "Niepoprawna odpowiedź! Poprawna odpowiedź to: %s\n\n" q.correct_answer
  ) shuffled_questions;

  (* Wyświetlenie wyniku na końcu quizu *)
  Printf.printf "Poprawnie odpowiedziałeś na %d z %d pytań.\n" !correct_count (List.length questions);

  (* Dodanie użytkownika do pliku winners.txt, jeśli odpowiedział poprawnie na wszystkie pytania *)
  if !correct_count = List.length questions then
    add_winner quiz_name user

