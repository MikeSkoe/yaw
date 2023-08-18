module Schema = {
    type id = int;
    type t = Card.t;

    let tableName = "cards";
    let schema = [("cards", "++id,front,back,level,description,stackName")];
}

module Table = Dexie.Table.MakeTable(Schema);

module Context = {
    let dexie = Dexie.Database.make("cards");
    let version = dexie
        ->Dexie.Database.version(2)
        ->Dexie.Version.stores(Schema.schema);

    let context = React.createContext(dexie);

    module Provider = {
        let make = React.Context.provider(context);
    }
}

