# Działanie aplikacji

## 1. Logowanie
Na ekranie pojawia się wybór - zaloguj się lub zakończ program.
W celu zalogowania, użytkowwnik proszony jest o podanie loginu i hasła.
Następnie następuje sprawdzenie czy użytkownik już istnieje w systemie w danym momencie:
- jeżeli tak - następuje logowanie,
- jeżeli nie - następuje dodanie i logowanie.

## 2. Wybór quizu
Po zalogowaniu użytkownik użytkownik dostaje listę quizów do wyboru, oraz możliwość wylogowania.

## 3. Quiz:
### Przebieg quizu
Po wyborze quizu, użytkownik zostanie poproszony o zaznacznie odpowiedzi na pytanie, a następnie przejdzie do następnego pytania - aż do ich końca w danym quizie.
### Zakończnie quizu
Po zakończeniu quizu, następuje:
- zapis punktacji,
- przekierowanie użytkownika do etapu wyboru (2. Wybór quizu).

# Kompilacja i uruchomienie
- opam exec -- dune build
- opam exec -- dune exec Take_It_Caml_Quiz
