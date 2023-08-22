@react.component
let make = () => {
    open Belt.Option;
    open Stack;
    let s = React.string;

    <div>{switch RescriptReactRouter.useUrl().path {
        | list{"view", id} =>
            Int.fromString(id)
            ->map(id => <CardViewPage id />)
            ->getWithDefault(<div>{s("wrong id")}</div>)
        | list{"stack", id} =>
            Int.fromString(id)
            ->map(id => <StackPage id />)
            ->getWithDefault(<div>{s("wrong stack id")}</div>)
        | _ =>
            <StackPage id=empty.id />
    }}</div>
}

