(* midterm_mini1.ml *)
(* Introduction to Computer Science (YSC1212), Sem2, 2019-2020 *)
(* Olivier Danvy <danvy@yale-nus.edu.sg> *)
(* Version of Thu 5 Mar 2020 *)

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

let parafold_right_nat zero_case succ_case n_given =
  (* parafold_right_nat : 'a -> (int -> 'a -> 'a) -> int -> 'a *)
  let () = assert (n_given >= 0) in
  let rec visit n =
    if n = 0
    then zero_case
    else let n' = n - 1
         in let ih = visit n'
            in succ_case n' ih    (* <-- succ_case takes two arguments *)
  in visit n_given;;

(* Exercise 4*)
(* unit test for sumtorials *)

let test_sumtorial_v0 candidate =
  (* the base case: *)
  let b0 = (candidate 0 = 0)
  (* some intuitive cases: *)
  and b1 = (candidate 1 = 1)
  and b2 = (candidate 2 = 3)
  and b3 = (candidate 3 = 6)
  and b4 = (candidate 4 = 10)
  and b5 = (candidate 5 = 15)
  in b0 && b1 && b2 && b3 && b4 && b5;;

let () = assert (test_sumtorial_v0 (fun n -> (n * n + n)/2));;
(* sanity testing *)

let () = assert (test_sumtorial_v0 (fun n ->
                     if n <= 5 then (n * n + n)/2
                     else 30000));;                   

let test_sumtorial_v1 candidate =
  (* the base case: *)
  let b0 = (candidate 0 = 0)
  (* some intuitive cases: *)
  and b1 = (candidate 1 = 1)
  and b2 = (candidate 2 = 3)
  and b3 = (candidate 3 = 6)
  and b4 = (candidate 4 = 10)
  and b5 = (candidate 5 = 15)
  (* instance of the induction step: *)
  and b6 = (let n = Random.int 20
            in candidate (succ n) = (succ n) + candidate n)
             (* etc. *)
  in b0 && b1 && b2 && b3 && b4 && b5 && b6;;

(* EDITTED TO BE A RECURSIVE FUNCTION *) 
let sumtorial_rec n_given =
  let () = assert (n_given >= 0) in
   let rec visit n =
    if n = 0
    then 0
    else let n' = n - 1
         in let ih = visit n'
            in (succ n') + ih
   in visit n_given;;

let () = assert (test_sumtorial_v1 sumtorial_rec);;

let sumtorial_non_rec n_given =
  (* using a non-recursive function to define a sumtorial function *)
  let () = assert (n_given >= 0) in
  (n_given * (n_given + 1)) / 2;;

let () = assert (test_sumtorial_v1 sumtorial_non_rec);;

(* Exercise 5*)

(* a. Compose a unit-test function for sum, based on its inductive specification. *)

  let test_sum_notation candidate =
  (* applying some intuitive numbers to identity functions *)
  let b0 = (candidate (fun n -> n) 0 = 0)
  and b1 = (candidate (fun n -> n) 1 = 1)
  and b2 = (candidate (fun n -> n) 2 = 3)
  and b3 = (candidate (fun n -> n) 5 = 15) 
  (* applying random integers to identity functions *)
  and b4 = (let i = Random.int 30
            in candidate (fun n -> n) i = sumtorial_rec i)
  (* applying some intuitive numbers to sum of n squared *)
  and b5 = (candidate (fun n -> n * n) 0 = 0)
  and b6 = (candidate (fun n -> n * n) 1 = 1)
  and b7 = (candidate (fun n -> n * n) 2 = 5)
  and b8 = (candidate (fun n -> n * n) 3 = 14)
  (* applying random integers to sum of n squared *)
  and b9 = (let i = Random.int 20
            in candidate (fun n -> n * n) i = (i * (i + 1) * (2 * i + 1)) / 6)
  in b0 && b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8 && b9;;

(* b. Implement this specification as a structurally recursive function expecting a function from int to int and a non-negative integer. *)

let sum_v0 f n_given =
  let () = assert (n_given >= 0) in
  let rec visit n =
    if n = 0
    then f (0)
    else let n' = n - 1
         in let ih = visit n'
            in ih + f (succ n')
  in visit n_given;;

(* c. Verify that this function passes your unit test.*)

let () = assert (test_sum_notation sum_v0);;

(* d. Express your implementation using either fold_right_nat or parafold_right_nat, your choice. Justify this choice, and verify that your new implementation passes your unit test. *)

let sum_using_parafold_right_nat f n =
  parafold_right_nat (f 0) (fun n' ih -> ih + f (succ n')) n;;

let () = assert (test_sum_notation sum_using_parafold_right_nat);;

(* we chose parafold_right_nat over fold_right_nat because by choosing to express the sigma notation through parafold_right_nat, we can directly add the result of the current recursion - ih - to the result of the successive call - f (succ n'). Furthermore, using parafold_right_nat saves us time because the succ_case - (ih + f (succ n')) - matches as the sigma notation is expressed in sum_v0. *)

(* e. Revisit the sumtorial function and express it using sum. *)

let sumtorial_using_sum_v0 n = sum_v0 (fun f -> f) n;;

let () = assert (test_sumtorial_v1 sumtorial_using_sum_v0);;

let identity n = n;;

let sumtorial_using_sum_v1 n = sum_v0 identity n;;

let () = assert (test_sumtorial_v1 sumtorial_using_sum_v1);;

(* f. Revisit Exercise 15 in Week 03 and implement three OCaml functions that given a non-negative integer n, compute the sum of the n+1 first odd numbers. The first should be structurally recursive. The second should use either fold_right_nat or parafold_right_nat, your choice. And the third should operate in constant time. *)

(* unit test for positive_odd_sum *)
let test_positive_odd_sum candidate =
  (* intuitive cases *)
  let b0 = (candidate 0 = 1)
  and b1 = (candidate 1 = 4)
  and b2 = (candidate 2 = 9)
  and b3 = (candidate 3 = 16)
  and b4 = (candidate 4 = 25)
  (* applying random integers *)
  and b5 = let i = Random.int 30 in
	   candidate i = (i + 1) * (i + 1)
  in b0 && b1 && b2 && b3 && b4 && b5;;

let positive_odd_sum_recursive n_given =
  let () = assert (n_given >= 0) in
  let rec visit n =
  if n = 0
  then 1
  else let n' = pred n
       in let ih = visit n'
          in ih + (n' + 1) * 2 + 1
  in visit n_given;;

let () = assert (test_positive_odd_sum positive_odd_sum_recursive);;

let positive_odd_sum_parafold n =
  let () = assert (n >= 0) in
  parafold_right_nat 1 (fun n' ih -> ih + (n' + 1) * 2 + 1) n;;

let () = assert (test_positive_odd_sum positive_odd_sum_parafold);;

let positive_odd_sum_constant_t n =
  let () = assert (n >= 0) in
  (n + 1) * (n + 1);;

let () = assert (test_positive_odd_sum positive_odd_sum_constant_t);;

(* g. identity of fibonacci numbers and updating our unit-test function *)

let fib_v0 n_given =
  let () = assert (n_given >= 0) in
  let rec visit n =
    if n = 0
    then 0
    else (if n = 1
          then 1
          else let n'' = n - 2
               and n' = n - 1
               in let ih'' = visit n''
                  and ih' = visit n'
                  in ih'' + ih')
  in visit n_given;;

let check_fib_identity =
  let b0 = (1 + fib_v0 0 = fib_v0 2)
  and b1 = (1 + fib_v0 0 + fib_v0 1 = fib_v0 3)
  and b2 = (1 + fib_v0 0 + fib_v0 1 + fib_v0 2 = fib_v0 4)
  and b3 = (let i = Random.int 30 in
	    1 + sum_v0 fib_v0 i = fib_v0 (i + 2))
  in b0 && b1 && b2 && b3;;

let () = assert check_fib_identity;;

let test_sum_notation_v1 candidate =
  (* applying some intuitive numbers to identity functions *)
  let b0 = (candidate (fun n -> n) 0 = 0)
  and b1 = (candidate (fun n -> n) 1 = 1)
  and b2 = (candidate (fun n -> n) 2 = 3)
  and b3 = (candidate (fun n -> n) 5 = 15) 
  (* applying random integers to identity functions *)
  and b4 = (let i = Random.int 30
            in candidate (fun n -> n) i = sumtorial_rec i)
  (* applying some intuitive numbers to sum of n squared *)
  and b5 = (candidate (fun n -> n * n) 0 = 0)
  and b6 = (candidate (fun n -> n * n) 1 = 1)
  and b7 = (candidate (fun n -> n * n) 2 = 5)
  and b8 = (candidate (fun n -> n * n) 3 = 14)
  (* applying random integers to sum of n squared *)
  and b9 = (let i = Random.int 20
            in candidate (fun n -> n * n) i = (i * (i + 1) * (2 * i + 1)) / 6)
  and b10 = (let i = Random.int 30 in
            1 + candidate fib_v0 i = fib_v0 (i + 2))
  in b0 && b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8 && b9 && b10;;

let () = assert (test_sum_notation_v1 sum_v0);;
let () = assert (test_sum_notation_v1 sum_using_parafold_right_nat);;

let test_ternaries preternp ternp postternp =
    (* base cases: *)
    let b0 = (preternp 0 = false)
    and b1 = (ternp 0 = true)
    and b2 = (postternp 0 = false)
    (* instances of the induction steps: *)
    and b3 = (let n' = Random.int 100
	      in ternp n' = postternp (succ n'))
    and b4 = (let n' = Random.int 100
	      in postternp n' = preternp (succ n'))
    and b5 = (let n' = Random.int 100
	      in preternp n'  = ternp (succ n'))
    in b0 && b1 && b2 && b3 && b4 && b5;;
(* Exercise 9 *)

let test_ternaries_alt preternp ternp postternp =
    (* base cases: *)
    let b0 = (preternp 0 = false)
    and b1 = (ternp 0 = true)
    and b2 = (postternp 0 = false)
    (* instances of the induction steps: *)
    and b3 = (let n' = Random.int 100
	      in ternp (pred n') = postternp n')
    and b4 = (let n' = Random.int 100
	      in postternp (pred n') = preternp n')
    and b5 = (let n' = Random.int 100
	      in preternp (pred n')  = ternp n')
    in b0 && b1 && b2 && b3 && b4 && b5;;

let rec ternp n =
  let () = assert (0 <= n) in
    if n = 0
    then true
    else let n' = n - 1
	 in preternp n'
  and preternp n =
    if n = 0
    then false
    else let n' = n - 1
	 in postternp n'
  and postternp n =
    if n = 0
    then false
    else let n' = n - 1
	 in ternp n';;

let () = assert (test_ternaries preternp ternp postternp);;
let () = assert (test_ternaries_alt preternp ternp postternp);;

(* EDITTED TO INCLUDE SINGLY RECURSIVE FUNCTIONS *)

let ternp_rec_v0 n_given =
    let () = assert (0 <= n_given) in
    let rec visit n =
    if n = 0 
    then true
    else if (n = 1 || n = 2) 
    then false
    else let n' = n - 3
	 in let ih = visit n'
	    in ih
    in visit n_given;;

let ternp_rec n_given =
    let () = assert (0 <= n_given) in
    let rec visit n =
    if n = 0 
    then true
    else if (n = 1 || n = 2) 
    then false
    else visit (n - 3)
    in visit n_given;;

let preternp_rec n_given =
    let () = assert (0 <= n_given) in
    let rec visit n =
    if n = 2 
    then true
    else if (n = 0 || n = 1) 
    then false
    else let n' = n - 3
	 in let ih = visit n'
	    in ih
    in visit n_given;;

let postternp_rec n_given =
    let () = assert (0 <= n_given) in
    let rec visit n =
    if n = 1 
    then true
    else if (n = 0 || n = 2) 
    then false
    else let n' = n - 3
	 in let ih = visit n'
	    in ih
    in visit n_given;;

let () = assert (test_ternaries preternp_rec ternp_rec postternp_rec);;

(* end of midterm_mini1.ml *)

