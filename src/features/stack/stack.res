module Map = Belt.Map;

module LevelCmp = Belt.Id.MakeComparable({
  type t = Level.t
  let cmp = (a, b) => Pervasives.compare(a, b)
});

type boxes = Map.t<LevelCmp.t, list<Card.t>, LevelCmp.identity>;

type t = {
    id: int,
    name: string,
    boxes: boxes,
};

let empty = {
    id: 0,
    name: "unnamed",
    boxes: Map.make(~id=module(LevelCmp)),
};

let makeId = () => Belt.Float.toInt(Js.Date.now() *. 10000.);

let make = (
    id: int,
    name: string,
    cards: list<Card.t>,
): t => {
    let rec makeBoxes = (cards: list<Card.t>, boxes: boxes): boxes => switch cards {
        | list{} => boxes
        | list{card, ...cards} => {
            let level = card->Card.getLevel;
            let currentValue = boxes->Map.get(level);

            let levelCards = switch currentValue {
                | None => list{card}
                | Some(levelCards) => levelCards->List.add(card)
            };

            makeBoxes(cards, boxes->Map.set(level, levelCards));
        }
    }
    let boxes = makeBoxes(cards, empty.boxes);

    { name, boxes, id }
};

