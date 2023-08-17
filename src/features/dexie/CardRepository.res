let useCards = () => {
    let dexie = React.useContext(CardsDexie.Context.context);

    let cards = Dexie.LiveQuery.use0(async () => Some(
        await dexie
            ->CardsDexie.Table.where("id")
            ->Dexie.Where.notEqual(-1)
            ->Dexie.Collection.toArray,
    ));

    cards->Option.getWithDefault([]);
}

let useDeleteCard = () => {
    let dexie = React.useContext(CardsDexie.Context.context);

    CardsDexie.Table.delete(dexie);
}

let useCard = id => {
    let dexie = React.useContext(CardsDexie.Context.context);
    let card = Dexie.LiveQuery.use0(() => dexie->CardsDexie.Table.getById(id));

    card;
}

let usePutCard = () => {
    let dexie = React.useContext(CardsDexie.Context.context);
    let putCard = card => dexie->CardsDexie.Table.put(card)->ignore;

    putCard;
}

