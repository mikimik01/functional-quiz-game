(* Funkcja do sprawdzania, czy dana linia już istnieje w pliku *)
let line_exists_in_file filename line_to_check =
  let ic = open_in filename in
  let rec loop () =
    try
      let line = input_line ic in
      if line = line_to_check then true
      else loop ()
    with End_of_file ->
      close_in ic;
      false
  in
  loop ();;

(* Funkcja do zapisywania tekstu do pliku, jeśli jeszcze nie istnieje *)
let append_to_file_if_new filename text =
  if not (line_exists_in_file filename text) then begin
    let oc = open_out_gen [Open_creat; Open_text; Open_append] 0o666 filename in
    output_string oc text;
    output_string oc "\n";
    close_out oc;
    (* print_endline "Tekst został dodany do pliku."; *)
    true
  end else begin
    print_endline "Ten tekst już istnieje w pliku.";
    false
    (* print_endline "Ten tekst już istnieje w pliku."; *)
  end

(* Funkcja do pobierania danych od użytkownika *)
let rec user_input_and_append filename =
  print_endline "Wprowadź nazwę użytkownika: ";
  let input = read_line () in
  if input = "exit" then
    print_endline "Zakończenie pracy programu."
  else begin
    if not (append_to_file_if_new filename input) then begin
      user_input_and_append filename
    end
  end;;

(* Główna funkcja programu *)
let () =
  let filename = "output.txt" in
  user_input_and_append filename;;
