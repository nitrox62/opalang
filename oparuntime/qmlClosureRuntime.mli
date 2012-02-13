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
   Runtime library for qmlClosure in caml

   Meant for QmlClosure, for backends (to allow the bsl to
   manipulate directly the closure through the server lib)
   and for the closure bsl
*)

module AnyArray : sig
  type t = Obj.t array
  val create : int -> t
  val set : t -> int -> 'a -> unit
  val get : t -> int -> 'a
  val length : t -> int
  val append_sub : t -> int -> t -> t
  val sub : t -> int -> t
  val sub2 : t -> int -> int -> t
  val append : t -> t -> t
end

(**/**)
type t_extra
#<Ifstatic:CPS_WITH_ML_CLOSURE .*>
type t
#<Else>
(* this type is exposed for manipulation ONLY by the code generated by QmlClosure *)
type t = {
  arity : int;
  mutable identifier : Obj.t option;
  args: AnyArray.t;
  mutable func: Obj.t;
  extra : t_extra;
}
#<End>
(**/**)

(** {6 Debug} *)

val check : 'a -> bool
val assert_ : 'a -> t
val show : 'a -> string

(** {6 Allocation} *)

val create : 'ml_closure -> int -> 'record -> t
val create_no_ident : 'ml_closure -> int -> t
val create_no_ident1 : 'ml_closure -> t
val create_no_ident2 : 'ml_closure -> t
val create_no_function : int -> 'record -> t
val create_anyarray : 'ml_closure -> int -> 'record -> t
val define_function : t -> 'ml_closure -> unit

(** {6 Application} *)

(** full application of a closure  *)
val args_apply : t -> AnyArray.t -> 'result
val args_apply1 : t -> 'arg1 -> 'result
val args_apply2 : t -> 'arg1 -> 'arg2 -> 'result

(** partial application of a closure  *)
val env_apply : t -> AnyArray.t -> t
val env_apply1 : t -> 'arg1 -> t
val env_apply2 : t -> 'arg1 -> 'arg2 -> t

(** partial application of a closure with type information about pushed args *)
val env_apply_with_ty : t -> AnyArray.t -> AnyArray.t -> t
val env_apply1_with_ty : t -> 'arg1 -> 'ty_arg1 -> t
val env_apply2_with_ty : t -> 'arg1 -> 'arg2 ->  'ty_arg1 -> 'ty_arg1 -> t


(** {6 Interface for serialization} *)

val is_empty : 'closure -> bool
val get_identifier : 'closure -> 'ident option
val set_identifier : t -> 'ident -> unit
val get_args   : t -> AnyArray.t
val get_tyargs : t -> AnyArray.t

(** {6 Interface for bsl projections} *)

val import : 'ml_closure -> int -> t
val export : t -> 'ml_closure
