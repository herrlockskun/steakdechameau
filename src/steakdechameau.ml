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

module State = struct
  type t = { 
    mutable score : int;
    music : Orx.Sound.t;
    _player : Orx.Object.t;
     chamo_spawner: Orx.Object.t;
    _viewport : Orx.Viewport.t;
  }

  let state : t option ref = ref None

  let get () = Option.get !state

  (* Increase the score by a given amount *)
end

module Input = struct
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

module Physics = struct
  let on_add_contact
        (state : State.t)
      ~(sender : Orx.Object.t)
      ~(recipient : Orx.Object.t) =
    let sender_name = Orx.Object.get_name sender in
    let recipient_name = Orx.Object.get_name recipient in

    if String.equal sender_name "ChamoObject" then (
      Orx.Object.set_life_time sender 0.0;
(*      Orx.Object.set_active sender false;*)
      print_string "sender == chameau";
     (* State.increase_score state 1000*)
    );  
    if String.equal recipient_name "ChamoObject" then (
      Orx.Object.set_life_time recipient 0.0;
    (*  Orx.Object.set_active recipient false;*)
      print_string "recipient == chameau";
     (* State.increase_score state 1000*)
    );
    
    Ok()
let event_handler
      (event : Orx.Event.t)
      (physics : Orx.Physics_event.t)
      (_payload : Orx.Physics_event.payload) =
        let state = State.get() in
    match physics with
    | Contact_add ->
      let sender = Orx.Event.get_sender_object event |> Option.get in
      let recipient = Orx.Event.get_recipient_object event |> Option.get in
      on_add_contact state ~sender ~recipient
    | Contact_remove -> Ok ()
end


let init () =
  let _viewport = Orx.Viewport.create_from_config_exn "Viewport" in
  (*let _chamo = Orx.Object.create_from_config_exn "ChamoObject" in*)
  let _player = Orx.Object.create_from_config_exn "PlayerObject" in
  Orx.Object.add_sound_exn _player "Music";
  let music = Orx.Object.get_last_added_sound _player |> Option.get in
  Orx.Sound.play music;
  let chamo_spawner = Orx.Object.create_from_config_exn "ChamoSpawner" in
  Runtime.Spawner.set chamo_spawner;

        State.state := 
                Some {_viewport; _player; music; chamo_spawner; score=0};
  Orx.Event.add_handler Physics Physics.event_handler;

  Ok ()

let run () =
        (* let state = State.get() in  *)
  if Orx.Input.is_active "Quit" then
    Orx.Status.error
  else (
    let _ = Input.check_player () in (*a décommenter quand ça marche, cf plus haut*)
    Orx.Status.ok;
  )

let () =
  (* Start the main game engine loop *)
  Orx.Main.start ~config_dir:"data/config" ~init ~run "steakdechameau"
  
