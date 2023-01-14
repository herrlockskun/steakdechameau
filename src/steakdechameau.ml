module Runtime = struct
  let section = "Runtime"

  module Spawner = struct
    let key = "BlockSpawnerGUID"

    let set spawner =
      Orx.Config.(set set_guid) ~section ~key (Orx.Object.to_guid spawner)

    let no_more_blocks =
      let spawner_finished = ref false in
      fun () ->
        let all_blocks_spawned =
          if !spawner_finished then true
          else
            let block_spawner =
              Orx.Config.(get get_guid) ~section ~key |> Orx.Object.of_guid
            in
            spawner_finished := Option.is_none block_spawner;
            !spawner_finished
        in
        if all_blocks_spawned then
          match (Orx.Object.get_group (Group "blocks")) () with
          | Nil -> true
          | Cons _ -> false
        else false
  end

  module Entity = struct
    type t = Chamo | Player

    let to_key : t -> string = function
      | Chamo -> "Chamo"
      | Player -> "Player"

    let get_by_guid key =
      Orx.Config.(get get_guid) ~section ~key
      |> Orx.Object.of_guid |> Option.get

    let get what = get_by_guid (to_key what)

    let get_speed what =
      match what with
      | Chamo -> Orx.Config.(get get_float) ~section:"Chamo" ~key:"Speed"
      | Player -> Orx.Config.(get get_float) ~section:"Player" ~key:"Speed"
  end
end



module Input = struct
  let check_player () =
    let _ = Orx.Log.log "%d" (3) in
    let player = Runtime.Entity.get Player in (* ça bug mais je sais pas pourquoi... si ça marche gauche et droite devraient bouger le perso*)
    let _ = Orx.Log.log "%d" (4) in
    let player_speed = Runtime.Entity.get_speed Player in
    let right_speed = Orx.Vector.make ~x:player_speed ~y:0.0 ~z:0.0 in
    let left_speed = Orx.Vector.mulf right_speed ~-.1.0 in
    if Orx.Input.is_active "Left" then Orx.Object.set_speed player left_speed;
    if Orx.Input.is_active "Right" then Orx.Object.set_speed player right_speed;
  
end

let init () =
  let _viewport = Orx.Viewport.create_from_config_exn "Viewport" in
  (*let _chamo = Orx.Object.create_from_config_exn "ChamoObject" in*)
  let _player = Orx.Object.create_from_config_exn "PlayerObject" in
  let chamo_spawner = Orx.Object.create_from_config_exn "ChamoSpawner" in
  Runtime.Spawner.set chamo_spawner;
  Ok ()

let run () =
  if Orx.Input.is_active "Quit" then
    Orx.Status.error
  else (
    (*let _ = Input.check_player () in*) (*a décommenter quand ça marche, cf plus haut*)
    Orx.Status.ok;
  )

let () =
  (* Start the main game engine loop *)
  Orx.Main.start ~config_dir:"data/config" ~init ~run "steakdechameau"
  
