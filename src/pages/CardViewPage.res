module Option = Belt.Option;

@react.component
let make = (~id) => {
    open Option;
    let card = CardRepository.useCard(id);
    let s = React.string;

    <>
        <Link.Replace hash="/">
            <button>{s("back to main")}</button>
        </Link.Replace>

        {card
            ->map(card => <CardPut id={card->Card.getId} stackId={card->Card.getStackId} />)
            ->getWithDefault(React.null)}
    </>
}

