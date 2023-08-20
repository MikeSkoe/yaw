module Array = Belt.Array;
module Set = Belt.Set;

let useStackNames = (): array<string> => {
    let dexie = React.useContext(Repository.Context.context);

    let names = Dexie.LiveQuery.use0(async () => Some(
        await dexie
        ->Repository.StackTable.where("id")
        ->Dexie.Where.notEqual(-1)
        ->Dexie.Collection.toArray
    ));

    switch names {
    | None => [Stack.empty.name]
    | Some(arr) =>
        arr
        ->Array.map(({ name }) => name)
        ->Array.concat([Stack.empty.name])
        ->Set.String.fromArray
        ->Set.String.toArray
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

let useStack = (name: string): Stack.t => {
    let dexie = React.useContext(Repository.Context.context);

    let stackRecord = Dexie.LiveQuery.use1(async () =>
        await dexie
            ->Repository.StackTable.findByCriteria({ "name": name })
            ->Dexie.Collection.first,
        [name],
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

