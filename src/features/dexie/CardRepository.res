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

