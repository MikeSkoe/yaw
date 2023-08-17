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

    card;
}

let usePutCard = () => {
    let dexie = React.useContext(CardDexie.Context.context);
    let putCard = card => dexie->CardDexie.Table.put(card)->ignore;

    putCard;
}

