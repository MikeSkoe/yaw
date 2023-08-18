module Array = Belt.Array;
module Set = Belt.Set;

let useStackNames = (): array<string> => {
    let dexie = React.useContext(CardsDexie.Context.context);

    let names = Dexie.LiveQuery.use0(async () => Some(
        await dexie
        ->CardsDexie.Table.where("id")
        ->Dexie.Where.notEqual(-1)
        ->Dexie.Collection.sortBy("stackName")
    ));

    switch names {
    | None => []
    | Some(arr) =>
        arr
        ->Array.map(Card.getStackName)
        ->Set.String.fromArray
        ->Set.String.toArray
    }
}

let useStack = (name: string): Stack.t => {
    let dexie = React.useContext(CardsDexie.Context.context);

    let cards = Dexie.LiveQuery.use0(async () => Some(
        await dexie
        ->CardsDexie.Table.where("stackName")
        ->Dexie.Where.equals(name)
        ->Dexie.Collection.toArray
    ));

    Stack.make(
        name,
        cards
        ->Option.map(List.fromArray)
        ->Option.getWithDefault(list{}),
    );
}

