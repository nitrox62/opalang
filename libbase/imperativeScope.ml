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
(**
   Management of imperative scope
   @author Vincent Benayoun
*)


module type IMPERATIVE_SCOPE =
sig
  (**
     The mutable type of the instance
  *)
  type 'a t
    
  type elt

  (** create a new structure given a size for blocks *)
  val create : int -> 'a t

  (** reset the structure to its initial state *)
  val reset : 'a t -> unit
    
  (** push a new block *)
  val push : 'a t -> unit
    
  (** pop the top block *)
  val pop : 'a t -> unit

  (** fold the top block *)
  val fold : (elt -> 'a -> 'acc -> 'acc) -> 'a t -> 'acc -> 'acc
   
  (** bind the elt to 'a in the top block *)
  val bind : 'a t -> elt -> 'a -> unit

  (** unbind the elt from the top block *)
  val unbind : 'a t -> elt -> unit

  (** find the first binded data to the elt (top down) *)
  val find_opt : 'a t -> elt -> 'a option
 
end

module type ARG =
sig
  type elt
  type 'a block

  val create : int -> 'a block
  val fold   : (elt -> 'a -> 'acc -> 'acc) -> 'a block -> 'acc -> 'acc
  val bind   : 'a block -> elt -> 'a -> unit
  val unbind : 'a block -> elt -> unit
  val find_opt: 'a block -> elt -> 'a option
end


module Make(Arg : ARG) : IMPERATIVE_SCOPE  with type elt = Arg.elt =
struct

  type 'a t = 'a Arg.block list ref
  type elt = Arg.elt

  let block_size = ref 0

  let new_stack() = [Arg.create !block_size]

  let create n = block_size := n; ref (new_stack())
  let reset s = s := new_stack()
  let push s = s := (Arg.create !block_size)::!s
  let pop s  =
    match !s with
    | [_] -> s := new_stack()
    | _   -> s := List.tl !s
  let fold f s = Arg.fold f (List.hd !s)
  let bind s e v = Arg.bind (List.hd !s) e v
  let unbind s e = Arg.unbind (List.hd !s) e

  let rec find_opt s e =
    let rec aux l =
      match l with
      | [] -> None
      | hd::tl ->
          let found = Arg.find_opt hd e in
          match found with
          | Some _ -> found
          | None -> aux tl
    in
    aux !s
end


module Default (Arg : sig type elt end) = Make(
struct
  type elt = Arg.elt
  type 'a block = (elt, 'a) Hashtbl.t

  let create n = Hashtbl.create n

  let fold f = Hashtbl.fold f

  let bind b e v = Hashtbl.add b e v
  let unbind b e = Hashtbl.remove b e

  let find_opt b e =
    try
      Some (Hashtbl.find b e)
    with
    | Not_found -> None

end
)
