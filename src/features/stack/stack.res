type t = { name: string, cards: list<Card.t> };

let empty = { cards: list{}, name: "" };

let make = name => { ...empty, name };

let addCard = (t, card) => { ...t, cards: t.cards->Belt.List.add(card) }

