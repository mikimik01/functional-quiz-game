open Printf
open Stdlib



(* Przechowuje numer wybranego quizu, ustawiony jako referencja ze wzgledu na funkcje read_int *)
let quiz_number = ref(-1);;
let loginRef = ref("");;

(* Przechowuje listę dostępnych quizów *)
let quiz_list = QuizLib.QuizFilesHandler.get_quiz_list;;

(* Funkcja do wczytywania danych od użytkownika *)
let read_input prompt =
    print_string prompt;
    read_line ()

let read_and_match_user_input () =
    let input = read_line () in
    match input with
    | "1" -> 1
    | "2" -> 2
    | _ -> 
    begin
        Printf.printf "Błędna opcja.\n\n";
        exit 0;
    end
let show_winners () =
    let filename = "lib/winners.txt" in
    try
        let ic = open_in filename in
        try
        while true do
            let line = input_line ic in
            print_endline line
        done
        with End_of_file ->
        close_in ic
    with Sys_error _ ->
        print_endline "Nie udało się otworzyć pliku winners.txt."

let rec main_menu () =
    ignore (Sys.command "clear");
    Printf.printf "Menu (%s):\n" !loginRef;
    print_endline "1. Rozpocznij quiz";
    print_endline "2. Zobacz tablicę wyników";
    print_endline "3. Wyjdź";
    print_string "Wybierz opcję (1-3): ";
    match read_int_opt () with
    | Some 1 -> 
        ignore (Sys.command "clear");
        while !quiz_number < 1 || !quiz_number > (List.length quiz_list) do
            print_endline "Dostępne quizy: \n";
    
            (* Sekwencja do uzyskiwania i pobierania listy dostępnych quizów [String List] i wypisania ich na wyjściu dla użytkownika *)
            QuizLib.QuizFilesHandler.printable_quiz_list quiz_list |>
            List.iter(printf "%s\n");
            
            print_string "\nWybierz numer quizu: ";
            try
                quiz_number := Stdlib.read_int();
                ignore (Sys.command "clear");
            with
                | Failure _ ->
                    ignore (Sys.command "clear");
                    print_endline "Podaj numer quizu !\n";
                    quiz_number := -1
        done;
        (* Sekwencja do uzyskiwania i pobierania listy pytań z pliku quizu [QuizLib.Question List] i wypisania ich na wyjściu dla użytkownika *)
        let quiz_questions = QuizLib.QuizFilesReader.read_questions_from_file (QuizLib.QuizFilesHandler.get_quiz_dir ^ List.nth quiz_list (!quiz_number - 1)) in
        Random.self_init ();
        let name = (List.nth quiz_list (!quiz_number - 1)) in
        let len = String.length name in
        let cut_name = String.sub name 0 (len - 4) in
        QuizLib.QuizFilesReader.start_quiz cut_name !loginRef quiz_questions;
        print_endline "\nNaciśnij dowolny klawisz, aby kontynuować...";
        ignore (read_line ());
        quiz_number := -1;
        main_menu ()
    | Some 2 -> 
        ignore (Sys.command "clear");
        Printf.printf "Nazwa quizu: lista osób, które go rozwiązały w całości\n------------------------\n\n";
        show_winners ();
        print_endline "\nNaciśnij dowolny klawisz, aby kontynuować...";
        ignore (read_line ());
        main_menu ()
    | Some 3 -> 
        ignore (Sys.command "clear");
        print_endline "Do widzenia!"
    | _ -> 
        print_endline "Niepoprawna opcja, spróbuj ponownie.";
        main_menu ()


let _ =
    ignore (Sys.command "clear");

    Printf.printf "1.Logowanie\n2.Tworzenie konta\n\nPodaj numer swojego wyboru:";
    
    let user_choice = read_and_match_user_input () in
    ignore (Sys.command "clear");
    (* Pobieranie loginu i hasła od użytkownika *)
    let login = read_input "Podaj login: " in
    loginRef := login;
    let password = read_input "Podaj hasło: " in
    ignore (Sys.command "clear");
    (* Próba stworzenia użytkownika *)
    if user_choice = 2 then
        begin
            let isAdded = QuizLib.Logining.create_user login password in
                if isAdded then
                    Printf.printf "\nDodano nowego użytkownika: %s\n\n" login
                else
                    begin
                        Printf.printf "\nBłąd tworzenia konta\n\n";
                        exit 0
                    end
        end
    else if user_choice = 1 then
        begin
            let isLogged = QuizLib.Logining.log_user login password in
                if isLogged then
                    Printf.printf "Zalogowano jako: %s\n\n" login
                else
                    begin
                        Printf.printf "Błąd logowania!\n\n";
                        exit 0
                    end
        end;

        Random.self_init ();  (* Inicjalizacja generatora liczb losowych *)
        main_menu ()