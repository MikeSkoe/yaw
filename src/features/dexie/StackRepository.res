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

let useStack = (name: string): Stack.t => {
    let dexie = React.useContext(Repository.Context.context);

    let stack = Dexie.LiveQuery.use0(async () =>
        await dexie
        ->Repository.StackTable.findByCriteria({ "name": name })
        ->Dexie.Collection.first
    )->Option.map(Repository.StackSchema.toStack);

    let cards = Dexie.LiveQuery.use1(async () => switch stack {
        | None => Some({
            let arr =
                await dexie
                ->Repository.CardTable.where("stack")
                ->Dexie.Where.equals(Stack.empty.id)
                ->Dexie.Collection.toArray;

            arr->Array.keepMap(Repository.CardSchema.toCard)
        })
        | Some(stack) => Some({
            let arr =
                await dexie
                ->Repository.CardTable.where("stack")
                ->Dexie.Where.equals(stack.id)
                ->Dexie.Collection.toArray;

            arr->Array.keepMap(Repository.CardSchema.toCard)
        })
    }, [stack]);

    switch stack {
        | None => Stack.make(
            Stack.empty.id,
            Stack.empty.name,
            cards
            ->Option.map(List.fromArray)
            ->Option.getWithDefault(list{}),
        )
        | Some(stack) => Stack.make(
            stack.id,
            stack.name,
            cards
            ->Option.map(List.fromArray)
            ->Option.getWithDefault(list{}),
        )
    }
}

