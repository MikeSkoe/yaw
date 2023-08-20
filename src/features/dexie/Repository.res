module CardSchema = {
    type id = int;
    type t = {
        id: int,
        front: string,
        back: string,
        level: Level.t,
        description: string,
        stack: int,
    };

    let empty = {
        id: 0,
        front: "",
        back: "",
        level: Level.empty,
        description: "",
        stack: 0,
    }

    let toCard = (record: t): option<Card.t> =>
        {
            ...Card.empty,
            id: record.id,
            front: record.front,
            back: record.back,
            description: record.description,
            level: record.level,
        }
        ->Card.validate;

    let fromCard = (Card.Validated(card)) =>
        {
            id: card.id,
            front: card.front,
            back: card.back,
            level: card.level,
            description: card.description,
            stack: card.stackId,
        }

    let tableName = "cards";
    let schema = (tableName, "++id,front,back,level,description,stack");
}

module StackSchema = {
    type id = int;
    type t = {
        id: int,
        name: string,
    };

    let empty = {
        id: 0,
        name: "string",
    };

    let toStack = (record: t): Stack.t => {
        ...Stack.empty,
        id: record.id,
        name: record.name,
    }

    let tableName = "stacks";
    let schema = (tableName, "++id,name");
}

module CardTable = Dexie.Table.MakeTable(CardSchema);
module StackTable = Dexie.Table.MakeTable(StackSchema);

module Context = {
    let dexie = Dexie.Database.make("cards");
    let version = dexie
        ->Dexie.Database.version(2)
        ->Dexie.Version.stores([CardSchema.schema, StackSchema.schema]);

    let context = React.createContext(dexie);

    module Provider = {
        let make = React.Context.provider(context);
    }
}

