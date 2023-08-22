module Map = Belt.Map;

module StackNames = {
    @react.component
    let make = () => {
        let stackNames = StackRepository.useStackNameIds();

        <dl>
            <h3>{"Stacks: "->React.string}</h3>
            <ul>
                {stackNames
                ->Array.map(((name, id)) =>
                    <Link.Replace hash=`/stack/${id->Int.toString}` key={id->Int.toString}>
                        <li>{name->React.string}</li>
                    </Link.Replace>
                )
                ->React.array}
            </ul>
            <StackPut />
        </dl>
    }
}

@react.component
let make = (~id: int) => {
    let stack = StackRepository.useStack(id);

    <>
        <StackNames />
        <CardPut id={-1} stackId={id} />

        <h1>{`Cards list [${stack.name}]`->React.string}</h1>
        <ul>
            {stack.boxes
            ->Map.toArray
            ->Array.map(((key, value)) => <div key={key->Level.toString}>
                <h2>{key->Level.toString->React.string}</h2>
                <div style={ReactDOMStyle.make(~display="flex", ~overflow="auto", ())}>
                    {value
                    ->List.map(card => <CardView card key={card->Card.getId->Int.toString} />)
                    ->List.toArray
                    ->React.array}
                </div>
            </div>)
            ->React.array}
        </ul>
    </>
}

