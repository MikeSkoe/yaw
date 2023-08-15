let useCards = () => {
    let dexie = React.useContext(CardDexie.Context.context);

    let cards = Dexie.LiveQuery.use0(async () => Some(
        await dexie
            ->CardDexie.Table.where("id")
            ->Dexie.Where.notEqual(-1)
            ->Dexie.Collection.toArray,
    ));

    cards->Option.getWithDefault([]);
}

let useDeleteCard = () => {
    let dexie = React.useContext(CardDexie.Context.context);

    CardDexie.Table.delete(dexie);
}

let useCard = id => {
    let dexie = React.useContext(CardDexie.Context.context);
    let card = Dexie.LiveQuery.use0(() => dexie->CardDexie.Table.getById(id));
    let setCard: (Card.t => Card.t) => unit
        = fn => switch card {
            | Some(card) => dexie->CardDexie.Table.put(fn(card))->ignore;
            | _ => None->ignore;
        };

    (card->Option.getWithDefault(Card.empty), setCard);
}

let usePutCard = () => {
    let dexie = React.useContext(CardDexie.Context.context);
    let putCard = card => dexie->CardDexie.Table.put(card)->ignore;

    putCard;
}
