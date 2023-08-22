module Array = Belt.Array;
module Set = Belt.Set;

let useStackNameIds = (): array<(string, int)> => {
    let dexie = React.useContext(Repository.Context.context);

    let emptyNameId = (Stack.empty.name, Stack.empty.id);
    let names = Dexie.LiveQuery.use0(async () => Some(
        await dexie
        ->Repository.StackTable.where("id")
        ->Dexie.Where.notEqual(-1)
        ->Dexie.Collection.toArray
    ));

    switch names {
    | None => [emptyNameId]
    | Some(arr) =>
        arr
        ->Array.map(({ name, id }) => (name, id))
        ->Array.concat([emptyNameId])
    }
}

let usePutStack = () => {
    let dexie = React.useContext(Repository.Context.context);
    let putStack = (stack: Stack.t) =>
        dexie
        ->Repository.StackTable.put(stack->Repository.StackSchema.fromStack)
        ->ignore;

    putStack;
}

let useStack = (id: int): Stack.t => {
    let dexie = React.useContext(Repository.Context.context);

    let stackRecord = Dexie.LiveQuery.use1(async () =>
        await dexie
            ->Repository.StackTable.findByCriteria({ "id": id })
            ->Dexie.Collection.first,
        [id],
    );

    let cardRecords = Dexie.LiveQuery.use1(async () => switch stackRecord {
        | None => Some(
            await dexie
                ->Repository.CardTable.where("stack")
                ->Dexie.Where.equals(Stack.empty.id)
                ->Dexie.Collection.toArray
        )
        | Some(stackRecord) => Some(
            await dexie
                ->Repository.CardTable.where("stack")
                ->Dexie.Where.equals(stackRecord.id)
                ->Dexie.Collection.toArray
        )
    }, [stackRecord]);

    let cards = React.useMemo1(_ =>
        cardRecords
            ->Option.getWithDefault([])
            ->Array.keepMap(Repository.CardSchema.toCard)
            ->List.fromArray,
        [cardRecords],
    );

    let stack = React.useMemo2(_ => switch stackRecord {
        | None => Stack.make(
            Stack.empty.id,
            Stack.empty.name,
            cards,
        )
        | Some(stack) => Stack.make(
            stack.id,
            stack.name,
            cards,
        )
    }, (stackRecord, cards));

    stack;
}

