(*
    Copyright © 2011 MLstate

    This file is part of OPA.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)
(*
    @author Rudy Sicard
    @author Pascal Rigaux
    @author Mehdi Bouaziz
    @author Mathieu Barbin
    @author François-Régis Sinot
    @author Henri Binsztok
*)

val default : 'a -> 'a option -> 'a
val default_lazy : 'a Lazy.t -> 'a option -> 'a
(** true if the argument is None*)
val is_none : 'a option -> bool
(** true if the argument is Some _*)
val is_some : 'a option -> bool

(**
   [if_none o a b] {[if is_none then a else b]}
*)
val if_none : 'a option -> 'b -> 'b -> 'b

(**
   if_some o a b <=> if is_some then a else b
*)
val if_some : 'a option -> 'b -> 'b -> 'b
val get : 'a option -> 'a
val get_exn : exn -> 'a option -> 'a
val map : ('a -> 'b) -> 'a option -> 'b option
val map2 : ('a -> 'b -> 'c) -> 'a option -> 'b option -> 'c option

(** apply the optional function *)
val apply : ('a -> 'a) option -> 'a -> 'a


val fold : ('a -> 'b -> 'a) -> 'a -> 'b option -> 'a
val fold_right : ('b -> 'acc -> 'acc) -> 'b option -> 'acc -> 'acc
val foldmap : ('a -> 'b -> 'a * 'c) -> 'a -> 'b option -> 'a * 'c option

(** Like foldmap but returns the same object physically if
    the traverse function returns the same object.
    Used for optimizing traversal constructions *)
val foldmap_stable :
  ('a -> 'b -> 'a * 'b) -> 'a -> 'b option -> 'a * 'b option

val iter : ('a -> unit) -> 'a option -> unit

(**
   Like map but can change a [Some(v)] to a [none]
*)
val bind : ('a -> 'b option) -> 'a option -> 'b option
val to_list : 'a option -> 'a list
val default_map : 'a -> ('b -> 'a) -> 'b option -> 'a
val default_lazy_map : 'a Lazy.t -> ('b -> 'a) -> 'b option -> 'a
val join : 'a option option -> 'a option
val make_compare : ('a -> 'b -> int) -> 'a option -> 'b option -> int
val merge : ('a -> 'a -> 'a) -> 'a option -> 'a option -> 'a option
val to_string : ('a -> string) -> 'a option -> string

(**
   [pp_none] Print [none] or directly the value if Some
*)
val pp_none :
  (Format.formatter -> 'a -> unit) -> Format.formatter -> 'a option -> unit

(**
   [pp] does not print anything for [None], and print the value if [Some]
*)
val pp : ('a -> 'b -> unit) -> 'a -> 'b option -> unit

(**
   [pp_sep sep pp fmt opt]
   Does not print anything for [None].
   Print the separator, and the value if [Some]
*)
val pp_sep :
  (unit, Format.formatter, unit) format ->
  (Format.formatter -> 'a -> unit) ->
  Format.formatter -> 'a option -> unit

(**
   Print the default if [None], and the value if [Some]
*)
val pp_default : 'a -> ('b -> 'a -> 'c) -> 'b -> 'a option -> 'c

(**
   Print [None] and [Some value]
*)
val pp_meta :
  (Format.formatter -> 'a -> unit) -> Format.formatter -> 'a option -> unit

val exists : ('a -> bool) -> 'a option -> bool
val for_all : ('a -> bool) -> 'a option -> bool
