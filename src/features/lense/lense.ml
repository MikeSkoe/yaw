module type GetSet = sig
  type t
  type value

  val get: t -> value
  val set: t -> value -> t
end

module Make (T: GetSet) = struct
  let map: T.t -> (T.value -> T.value) -> T.t
    = fun context fn -> T.set context (context |> T.get |> fn)
end

module Compose (AB: GetSet) (BC: GetSet with type t = AB.value):
  GetSet with type t = AB.t and type value = BC.value
= struct
  type t = AB.t
  type value = BC.value

  let get context = context |> AB.get |> BC.get

  let set context value = AB.set context (value |> (BC.set (AB.get context)))
end
