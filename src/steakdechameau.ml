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
end


let init () =
  let _viewport = Orx.Viewport.create_from_config_exn "Viewport" in
  (*let _chamo = Orx.Object.create_from_config_exn "ChamoObject" in*)
  let chamo_spawner = Orx.Object.create_from_config_exn "ChamoSpawner" in
  Runtime.Spawner.set chamo_spawner;
  Ok ()

let run () =
  if Orx.Input.is_active "Quit" then
    Orx.Status.error
  else(if Orx.Input.is_active "Left" then
    let _ = Orx.Log.log "PRESSED" in
    Orx.Status.ok
  else (
    Orx.Status.ok
  ))

let () =
  (* Start the main game engine loop *)
  Orx.Main.start ~config_dir:"data/config" ~init ~run "steakdechameau"
  
