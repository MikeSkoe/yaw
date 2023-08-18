module Option = Belt.Option;

module CardViewPage = {
    @react.component
    let make = (~id, ~stackName) => {
        let card = CardRepository.useCard(id);

        <>
            <Link.Replace hash="/">
                <button>
                    {"back to main"->React.string}
                </button>
            </Link.Replace>

            {card
            ->Option.map(card => <CardPut id={card->Card.getId} stackName />)
            ->Option.getWithDefault(React.null)}
        </>
    }
}

module StackPage = {
    @react.component
    let make = (~stackName) =>
        <>
            <CardPut id={-1} stackName />

            <h1>{`Cards list [${stackName}]`->React.string}</h1>
            <ul>
                {CardRepository.useCards()
                ->Array.map(card => <CardView card  key={card->Card.getId->Int.toString} />)
                ->React.array}
            </ul>
        </>
}

@react.component
let make = () =>
    <div>
        {switch RescriptReactRouter.useUrl().path {
            | list{"view", id} => switch Int.fromString(id) {
                | Some(id) => <CardViewPage id stackName="unnamed" />
                | None => <div>{"wrong id"->React.string}</div>
            }
            | _ => <StackPage stackName="unnamed" />
        }}
    </div>

