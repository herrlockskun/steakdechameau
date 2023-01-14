module Runtime = struct
  let section = "Runtime"
end

(*
module Entity = struct
  type t = Paddle | Ball

  let to_key : t -> string = function
    | Chamo -> "Chamo"

  let get_by_guid key =
    Orx.Config.(get get_guid) ~section ~key
    |> Orx.Object.of_guid |> Option.get

  let get what = get_by_guid (to_key what)

  let get_speed what =
    match what with
    | Paddle -> Orx.Config.(get get_float) ~section:"Chamo" ~key:"Speed"
end

module Input = struct
  let check_player () =
    let paddle = Runtime.Entity.get Chamo in
    let paddle_speed = Runtime.Entity.get_speed Paddle in
    let right_speed = Orx.Vector.make ~x:paddle_speed ~y:0.0 ~z:0.0 in
    let left_speed = Orx.Vector.mulf right_speed ~-.1.0 in
    if Orx.Input.is_active "Left" then Orx.Object.set_speed paddle left_speed;
    if Orx.Input.is_active "Right" then Orx.Object.set_speed paddle right_speed
end*)


let init () =
  let _viewport = Orx.Viewport.create_from_config_exn "Viewport" in
  let _chamo = Orx.Object.create_from_config_exn "ChamoObject" in

  
  Ok ()

let run () =
  if Orx.Input.is_active "Quit" then
    Orx.Status.error
  else (
    Orx.Status.ok
  )

let () =
  (* Start the main game engine loop *)
  Orx.Main.start ~config_dir:"data/config" ~init ~run "steakdechameau"
