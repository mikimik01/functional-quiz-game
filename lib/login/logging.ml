let create_user login password =
  let filename = "lib/login/users.txt" in
  (* Initialize the flag to check if the user already exists *)
  let exists = ref false in
  (* Read the file if it exists, otherwise catch the exception *)
  (try
     let ic = open_in filename in
     try
       while true do
         let line = input_line ic in
         let user = String.split_on_char ';' line |> List.hd in
         if user = login then exists := true
       done
     with End_of_file ->
       close_in ic
   with Sys_error _ -> ());
  if !exists then
    false
  else
    let oc = open_out_gen [Open_creat; Open_text; Open_append] 0o666 filename in
    output_string oc (login ^ ";" ^ password ^ "\n");
    close_out oc;
    true

let log_user login password =
  (* Funkcja do odczytu linii z pliku *)
  let read_lines filename =
    let ic = open_in filename in
    let rec loop acc =
      match input_line ic with
      | line -> loop (line :: acc)
      | exception End_of_file ->
        close_in ic;
        List.rev acc
    in
    loop []
  in

  (* Funkcja do sprawdzania loginu i hasła *)
  let check_credentials login password line =
    match String.split_on_char ';' line with
    | [stored_login; stored_password] ->
      stored_login = login && stored_password = password
    | _ -> false
  in

  (* Odczyt linii z pliku users.txt *)
  let lines = read_lines "lib/login/users.txt" in

  (* Sprawdzenie, czy istnieje linia z podanym loginem i hasłem *)
  List.exists (check_credentials login password) lines