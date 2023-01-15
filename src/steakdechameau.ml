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

 module Game_over = struct
    let key = "GameOver"
    let set () = Orx.Config.(set set_bool) ~section ~key:"GameOver" true
    let is_game_over () = Orx.Config.(get get_bool) ~section ~key:"GameOver"
  end

  module Score = struct
    let key = "Score"
    let get () = Orx.Config.(get get_int) ~section ~key
  
    let set score = Orx.Config.(set set_int) ~section ~key score
  
    let inc () = set (get () + 1)
    let dec () = set (get () - 1)
    let reset()= set (0)
  end
end

module Input = struct
  let next_scene () = 
    let player = Runtime.Entity.get Player in
    let position = Orx.Object.get_world_position player in
    let increment = Orx.Vector.make ~x:0.0 ~y:0.0 ~z:10.0 in
    let new_position = Orx.Vector.add position increment in
    Orx.Object.set_position player new_position

  let check_player () =
    let player = Runtime.Entity.get Player in
    let player_speed = Runtime.Entity.get_speed Player in
    let right_speed = Orx.Vector.make ~x:player_speed ~y:0.0 ~z:0.0 in
    let left_speed = Orx.Vector.mulf right_speed ~-.1.0 in
    let down_speed = Orx.Vector.make ~x:0.0 ~y:player_speed ~z:0.0 in
    let up_speed = Orx.Vector.mulf down_speed ~-.1.0 in
    let no_speed = Orx.Vector.mulf down_speed ~-.0.0 in

    Orx.Object.set_speed player no_speed;
    if Orx.Input.is_active "Left" then Orx.Object.set_speed player left_speed;
    if Orx.Input.is_active "Right" then Orx.Object.set_speed player right_speed;
    if Orx.Input.is_active "Up" then Orx.Object.set_speed player up_speed;
    if Orx.Input.is_active "Down" then Orx.Object.set_speed player down_speed;
    if Orx.Input.is_active "Left" && Orx.Input.is_active "Up"
      then Orx.Object.set_speed player (Orx.Vector.mulf (Orx.Vector.add left_speed up_speed) 0.7);
    if Orx.Input.is_active "Up" && Orx.Input.is_active "Right"
      then Orx.Object.set_speed player (Orx.Vector.mulf (Orx.Vector.add up_speed right_speed) 0.7);
    if Orx.Input.is_active "Right" && Orx.Input.is_active "Down"
      then Orx.Object.set_speed player (Orx.Vector.mulf (Orx.Vector.add right_speed down_speed) 0.7);
    if Orx.Input.is_active "Down" && Orx.Input.is_active "Left"
      then Orx.Object.set_speed player (Orx.Vector.mulf (Orx.Vector.add down_speed left_speed) 0.7);
    if Orx.Input.is_active "Right" && Orx.Input.is_active "Left"
      then Orx.Object.set_speed player no_speed;
    if Orx.Input.is_active "Down" && Orx.Input.is_active "Up"
      then Orx.Object.set_speed player no_speed;
  
end


let event_handler
    (event : Orx.Event.t)
    (physics : Orx.Physics_event.t)
    (_payload : Orx.Physics_event.payload) =
  ( match physics with
  | Contact_remove -> ()
  | Contact_add ->
    let recipient = Orx.Event.get_recipient_object event |> Option.get in
    Orx.Object.set_life_time recipient 0.0; |> ignore;
    Runtime.Score.inc ();
  );

  Ok ()
  

let init () =
  let _viewport = Orx.Viewport.create_from_config_exn "Viewport1" in
  (*let _chamo = Orx.Object.create_from_config_exn "ChamoObject" in*)
  let _score = Orx.Object.create_from_config_exn "ScoreObject" in
  let _player = Orx.Object.create_from_config_exn "PlayerObject" in

  Orx.Object.add_sound_exn _player "Music";
  let music = Orx.Object.get_last_added_sound _player |> Option.get in
  Orx.Sound.play music;

  let chamo_spawner = Orx.Object.create_from_config_exn "ChamoSpawner" in
(*  let _baril_spawner = Orx.Object.create_from_config_exn "BarilSpawner" in*)
(*  let _table_spawner = Orx.Object.create_from_config_exn "TableSpawner" in*)

  let _prairieBackground = Orx.Object.create_from_config_exn "BackgroundChamo" in
  let _barilBackground = Orx.Object.create_from_config_exn "BackgroundBaril" in
  let _restoBackground = Orx.Object.create_from_config_exn "BackgroundResto" in
  
  Runtime.Spawner.set chamo_spawner;



  Orx.Event.add_handler Physics event_handler;
  

  Ok ()

let level2 () =
  (let _viewport2 = Orx.Viewport.create_from_config_exn "Viewport2" in
let _baril_spawner = Orx.Object.create_from_config_exn "BarilSpawner" in
Runtime.Score.inc ();
Input.next_scene ();)

let level3 () =
  (let _viewport3 = Orx.Viewport.create_from_config_exn "Viewport3" in
let _table_spawner = Orx.Object.create_from_config_exn "TableSpawner" in
Runtime.Score.inc ();
Input.next_scene ();)


let run () =
  if Orx.Input.is_active "Quit" then
    Orx.Status.error
  else (
    Input.check_player (); (*a décommenter quand ça marche, cf plus haut*)
    let _game_over = Runtime.Game_over.is_game_over () in
    let _no_more_blocks = Runtime.Spawner.no_more_blocks () in
    let _score = Runtime.Score.get () in
    (*( if (not game_over) && no_more_blocks || (_score>=5) then
      let (_ : Orx.Object.t) = Orx.Object.create_from_config_exn "EndText" in
      Runtime.Game_over.set ()
    );*)
    (if _score == 5 then level2 (););

    Orx.Status.ok
  )


let () =
  (* Start the main game engine loop *)
  Orx.Main.start ~config_dir:"data/config" ~init ~run "steakdechameau"
