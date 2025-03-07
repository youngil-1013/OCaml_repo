(* midterm_mini3.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2019-2020 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Was version of Wed 4 Mar 2020 *)
(* Version of Wed 18 Mar 2020 *)

(* ********** *)

(* name: Young Il Kim
   email address: youngil.kim@u.yale-nus.edu.sg
   student number: A0207809Y

   other members of the group:
   name: Sewen Thy
   name: Kao Zhao Yuan
   name: Peng Chiao Yin
*)

let fold_right_nat zero_case succ_case n_given =
  (* fold_right_nat : 'a -> ('a -> 'a) -> int -> 'a *)
  let () = assert (n_given >= 0) in
  let rec visit n =
    if n = 0
    then zero_case
    else let n' = n - 1
         in let ih = visit n'
            in succ_case ih    (* <-- succ_case takes one argument *)
  in visit n_given;;

let test_fib candidate =
      (* base cases: *)
  let b0 = (candidate 0 = 0)
  and b1 = (candidate 1 = 1)
      (* intuitive numbers: *)
  and b2 = (candidate 2 = 1)
  and b3 = (candidate 3 = 2)
  and b4 = (candidate 4 = 3)
  and b5 = (candidate 5 = 5)
  and b6 = (candidate 6 = 8)
      (* instance of the induction step: *)
  and b7 = (let n = Random.int 25
            in candidate n + candidate (n + 1) = candidate (n + 2))
  (* etc. *)
  in b0 && b1 && b2 && b3 && b4 && b5 && b6 && b7;;

let fib_v6 n_given =
  let () = assert (n_given >= 0) in
  let (fib_n, fib_succ_n) = fold_right_nat (0, 1) (fun (ih, succ_ih) -> (succ_ih, succ_ih + ih)) n_given
  in fib_n;;

let () = assert (test_fib fib_v6);;

let indent i =
  String.make (2 * i) ' ';;

let traced_fib_v4 n_given =
  let () = Printf.printf "fib_v4 %d ->\n" n_given in
  let () = assert (n_given >= 0) in
  let rec visit n i =
    let () = Printf.printf "%svisit %d ->\n" (indent i) n in
    let result = if n = 0
                 then 0
                 else (if n = 1
                       then 1
                       else visit (n - 2) (i + 1) + visit (n - 1) (i + 1))
    in let () = Printf.printf "%svisit %d <- %d\n" (indent i) n result in
       result
  in let final_result = visit n_given 1
     in let () = Printf.printf "fib_v4 %d <- %d\n" n_given final_result in
        final_result;;

let traced_fib_v0 n_given =
  let () = Printf.printf "fib_v0 %d ->\n" n_given in
  let () = assert (n_given >= 0) in
  let rec visit n i =
    let () = Printf.printf "%svisit %d ->\n" (indent i) n in
    let result = if n = 0
                 then 0
                 else (if n = 1
                       then 1
                       else let n'' = n - 2
                            and n' = n - 1
                            in let ih'' = visit n'' (i + 1)
                               and ih' = visit n' (i + 1)
                               in ih'' + ih')
    in let () = Printf.printf "%svisit %d <- %d\n" (indent i) n result in
       result
  in let final_result = visit n_given 1
     in let () = Printf.printf "fib_v0 %d <- %d\n" n_given final_result in
        final_result;;

(* end of midterm_mini3.ml *)
