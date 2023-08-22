let useDeleteCard = () => {
    let dexie = React.useContext(Repository.Context.context);

    Repository.CardTable.delete(dexie);
}

let useCard = id => {
    let dexie = React.useContext(Repository.Context.context);
    let card = Dexie.LiveQuery.use0(() => dexie->Repository.CardTable.getById(id));

    React.useMemo1(_ => card->Option.flatMap(Repository.CardSchema.toCard), [card]);
}

let usePutCard = (stackId: int) => {
    let dexie = React.useContext(Repository.Context.context);
    let putCard = async (unvalidated: Card.unvalidated) => switch unvalidated->Card.validate {
        | None => Error("Failed to validate the card")
        | Some(card) => {
            let stack =
                await dexie
                    ->Repository.StackTable.findByCriteria({ "id": stackId })
                    ->Dexie.Collection.first;

            let stack = stack->Option.getWithDefault(Repository.StackSchema.empty);

            dexie
            ->Repository.CardTable.put({
                ...card->Card.unvalidate->Repository.CardSchema.fromCard,
                stack: stack.id,
            })
            ->ignore;

            Ok(());
        }
    }

    putCard;
}

