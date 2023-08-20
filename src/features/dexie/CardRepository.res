let useDeleteCard = () => {
    let dexie = React.useContext(Repository.Context.context);

    Repository.CardTable.delete(dexie);
}

let useCard = id => {
    let dexie = React.useContext(Repository.Context.context);
    let card = Dexie.LiveQuery.use0(() => dexie->Repository.CardTable.getById(id));

    React.useMemo1(_ => card->Option.flatMap(Repository.CardSchema.toCard), [card]);
}

let usePutCard = () => {
    let dexie = React.useContext(Repository.Context.context);
    let putCard = (card: Card.t) =>
        dexie
        ->Repository.CardTable.put(card->Repository.CardSchema.fromCard)
        ->ignore;

    putCard;
}

