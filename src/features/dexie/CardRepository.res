let useDeleteCard = () => {
    let dexie = React.useContext(Repository.Context.context);

    Repository.CardTable.delete(dexie);
}

let useCard = id => {
    let dexie = React.useContext(Repository.Context.context);
    let card = Dexie.LiveQuery.use0(() => dexie->Repository.CardTable.getById(id));

    React.useMemo1(_ => card->Option.flatMap(Repository.CardSchema.toCard), [card]);
}

let usePutCard = (stackName: string) => {
    let dexie = React.useContext(Repository.Context.context);
    let putCard = async (card: Card.card) => {
        switch card->Card.validate {
            | None => Error("Failed to validate the card")
            | Some(card) => {
                let stack =
                    await dexie
                        ->Repository.StackTable.findByCriteria({ "name": stackName })
                        ->Dexie.Collection.first;

                let stack = stack->Option.getWithDefault(Repository.StackSchema.empty);

                dexie
                ->Repository.CardTable.put({
                    ...card->Repository.CardSchema.fromCard,
                    stack: stack.id,
                })
                ->ignore;

                Ok(());
            }
        }
    }

    putCard;
}

