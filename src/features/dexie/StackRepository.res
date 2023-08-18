module List = Belt.List;

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

